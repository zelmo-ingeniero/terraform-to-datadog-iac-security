# HTTP load balancer

Here are 4 different parts

1. The load balancing itself, in `main-lb.tf`
3. The Certificate to HTTPS (**in progress**)
4. The computing or the EC2s to be balanced

![Module load-balancers infrastructure ](lb-module-01.png)

Ignoring the ENIs because they represents too work and don't worth it, there are 2 ENI per subnet

1. The ENI to connect the LB `security_group` to each subnet
2. The ENI to connect the instance `security_group` to the parent subnet

> This directory is still in research phase, because the route53 records are expensive, slow and hard to create, the HTTP version is ready in previous com

## Call to module

Previously is required an existing VPC with their respective subnets (either public or privates)

- The `ports = []` variable create a new Security Group with that ports open to receive traffic

```js
module "lb" {
  source = "./load_balancers"
  vpc_id = module.vpc.vpc_id
  name   = "my-alb"
  ports  = [80, 443]
}
```

- Or instead you can introduce a list of existing security groups ids to avoid creating a new one

```js
module "lb" {
  source  = "./load_balancers"
  vpc_id  = module.vpc.vpc_id
  name    = "my-alb"
  sgp_ids = ["<sgp id 1>", "<sgp id 2>"]
}
```

I will to check how to create listeners, tgps and more


## (legacy, please ignore this) Issues in the code

### The instances per subnet

To create multiple resources I use the `for_each = map(any)` argument, where for example the instances are created through

```js
resource "aws_instance" "alb-instance" {
  for_each  = aws_subnet.alb
  subnet_id = each.value.id
  ...
}
```

With this we are creating 1 instance per subnet but if you want variable instances per subnet you need 3 radical changes

1. Add 1 object to that instances per subnet
2. Create 1 `locals {}` block where you transform the `subnets { instances }` to `instances { subnet }`, in other words, send the instance attributes in an understandable format
3. Use `for_each = { for in locals }` inside your instance (and their respective `security_group`s to avoid cycle dependencies)

### `subnet-list` variable

Then the changes in the variable `subnet-list` in the `main.tf` file are

```js
module "load-balancers" {
  ...
  subnet-list = {
    az = {
      instances = {
        instance-x = "instance-type"
      }
      ...
    }
  }
}
```

### The `instances-list` local

In the `ec2.tf` file the first change is to add the `locals {}` where we will to transform the `subnet.list` values

**I will explaining for parts** The `flatten()` function convert embeded list to simplest list, check out this [documentation](https://developer.hashicorp.com/terraform/language/functions/flatten)

```js
locals {
  instances-list = flatten( [ var.subnet-list ] )
}
```

Now is time to consider that there will are *variable subnets* and in each one are *variable instances per subnet*, if we need the total number of subnet.instances then we need a double `for` expresion. There are 2 different `for` loops

1. **List** that looks like `[ for in list : a = b ]` and return 1 list `[""]`
2. **Object** that looks like `{ for in list : a => b }` and return 1 object `{"" = ""}`

I expect that the explanation was enough to understand that in the next code, the output should be a list of objects `[ {"" = ""} ]`

```js
locals {
  instances-list = flatten([
    for subnet-az, subnet in var.subnet-list : [
      for instance-number, instance in subnet.instances : {
        ...
      }
    ]
  ])
}
```

Now, to each instance I want

* The subnet that is indexed through the AZ
* The instance index writed by the user inside the `subnet-list` variable, could be `string` or `number`
* I want to naming the instances in the format `"parent-subnet intance-number"`, without this `locals` this could be impossible
* And the instance characteristics and values writed by the user inside the `subnet-list` variable, right now there is only 1 simple `string` but in the future can be more complex

To get that info I stablished this `object` per instance, this 4 lines are flexible and you can change it according to your needs

```js
locals {
  instances-list = flatten([
    for subnet-az, subnet in var.subnet-list : [
      for instance-number, instance in subnet.instances : {
        az            = subnet-az
        instance-id   = instance-number
        instance-name = "${subnet-az}-${instance-number}"
        instance      = instance
      }
    ]
  ])
}
```

### The resources `for_each`

The third change is directly on the resources, as you can remember the local.instances-list has the format `[ {""=""} ]` and instead `{ "" = {""=""} }` is required by `for_each`

By this reason, we can use 1 object `for` loop in the `for_each`, we need some like

```js
resource "aws_instance" "alb" {
  for_each = { for i in local.instances-list : ... }
  ...
}
```

Think that in my case the `i` loop variable will content the values `az`, `instance-id`, `instance-name`, `instance` thanks to the `local`

```js
locals {
  instances-list = ...
    az            = subnet-az
    instance-id   = instance-number
    instance-name = "${subnet-az}-${instance-number}"
    instance      = instance
  ...
}
```

You can get that values with the usual `.` notation, then I want `instance-name = { subnet = "" instance-name = "" }` and so on, as in the next code

```js
resource "aws_instance" "alb" {
  for_each = {
    for i in local.instances-list :
      i.instance-name => {
        sg       = i.instance-name
        instance = i.instance
        subnet   = i.az
      }
  }
}
```

I also want 1 `security_group` per instance, that is easier having our `instance-list` local

```js
resource "aws_security_group" "sg-instance" {
  for_each = {
    for i in local.instances-list : i.instance-name => i
  }
  name        = "sgp-${var.project}-${each.key}${var.suffix}"
  description = "exclusive to ${each.key}"
  ...
}
```

### CIDRs per subnet

I'm still thinking about the mapping, **how to choice the subnets, their AZs and their CIDR blocks**.

In the website you choice each AZ and the subnets with their CIDR will be created automatically, in this case is very difficult to do the CIDR segmentation

In the documentation [Terraform IP functions](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet) exist a `cidrsubnet(cidr, newbits, binary_num)` function, but this is not working correctly (probably uses octal numeric system). After some experiments and tests I consider that this function is not usable

> Then you need to select each AZ as in the website and then write the CIDR to each subnet

At the end i decided the next format

```js
subnet-list = {
  "AZ" = "CIDR"
}
```  

but I think that there are better ways to do it, maybe using *regular expressions*, I'm open to suggestions

```js
module "load-balancers" {
  source   = "./load-balancers"
  region   = var.region
  project  = "third"
  suffix   = "-attempt"
  domain   = "exos-test.mx"
  cidr-vpc = "10.0.0.0/16"
  subnet-list = {
    "${var.region}a" = {
      cidr      = "10.0.1.0/24"
      instances = {}
    }
    "${var.region}b" = {
      cidr = "10.0.2.0/24"
      instances = {
        1 = "t2.micro"
      }
    }
    "${var.region}c" = {
      cidr      = "10.0.3.0/24"
      instances = {}
    }
  }
}
```
