# Public and private subnets

Here we have some like the next example

![Module infrestructure](network-module-02.png)

By now there is no way to do attachments between security groups and other resources with this module.

## Call to module

Basic call to module

```js
module "vpc" {
  source = "./vpc"
  cidr   = "172.40.0.0/16"
}
```

- This only creates the VPC with their `internet_gateway` and `main_route_table` and no more

Add public subnets

```js
module "vpc" {
  source = "./vpc"
  cidr   = "172.40.0.0/16"
  public_subnets = {
    "172.20.0.0/20"  = "first"
    "172.20.16.0/20" = "second"
  }
}
```

- Each one with have their `route_table` associated
- The availability zones will be `a`, `b`, `c`, `d` and so on. (e.g. The "first" will be in the AZ a and "second" in the AZ b) 

Add an optional suffix to the name

```js
module "vpc" {
  source   = "./vpc"
  cidr     = "172.20.0.0/16"
  tag_name = "-project-1"
  public_subnets = {
    "172.20.0.0/20"  = "first"
    "172.20.16.0/20" = "second"
  }
}
```

- The suffix should start with a dash `-` for easy reading, this will be at the end of resource names

Add an optional suffix to the name

```js
module "vpc" {
  source   = "./vpc"
  cidr     = "172.20.0.0/16"
  tag_name = "-project-1"
  public_subnets = {
    "172.20.0.0/20"  = "first"
    "172.20.16.0/20" = "second"
  }
  private_subnets = {
    "172.20.32.0/20" = "three"
    "172.20.48.0/20" = "four"
  }
}
```

- Both subnets ("first" and "three") will have the same AZ
- Both subnets ("second" and "four") will have the same AZ 
- Every subnets will use the same `internet_gateway`

## notes

- Coming soon I need to explore how to add more complex routes
- By costs this module don"t use `nat_gateways`
