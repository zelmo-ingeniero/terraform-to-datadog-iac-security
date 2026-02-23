# EC2 instance with software installation scripts

ShellScripts to 1 EC2 instance with the next softwares installed

Every script are in different `.sh` files and are designed to **AL 2023**

add ami id and add multiple userdatas

To call the module before **is recommended to use the VPC module** of this repository

Basic call to module

```js
data "aws_key_pair" "this" {
  key_name = "<the name of one key_pair in the account>"
}

module "installations" {
  source   = "./installations"
  key_pair = data.aws_key_pair.this.key_name
  ports    = [22]
  subnet   = module.vpc.public_subnets_ids[0]
  name     = "my-instance"
}
```

- The VPC will be auto detected
- A new security group will be created
- NodeJS will be installed in the instance
- The name will be also in all of the tag names in the module as a suffix

Select the scripts to be executed to install softwares

```js
data "aws_key_pair" "this" {
  key_name = "<the name of one key_pair in the account>"
}

module "installations" {
  source   = "./installations"
  key_pair = data.aws_key_pair.this.key_name
  ports    = [22]
  subnet   = module.vpc.public_subnets_ids[0]
  name     = "my-instance"
}
```

> [!NOTE]
> Coming soon I will to migrate to Ansible

Turn off the instance writing the line `status = "stopped"` and applying changes. Then, to start the instancce delete the line and apply changes

```js
module "installations" {
  source   = "./installations"
  key_pair = data.aws_key_pair.this.key_name
  ports    = [22]
  subnet   = module.vpc.public_subnets_ids[0]
  name     = "my-instance"
  status   = "stopped"
}
```

To assocciate one new Elastic IP write the line `with_eip = true` and apply the changes

```js
module "installations" {
  source      = "./installations"
  key_pair    = data.aws_key_pair.this.key_name
  ports       = [22]
  subnet      = module.vpc.public_subnets_ids[0]
  name        = "my-instance"
  with_eip    = true
}
```

Optional, personalize other values: 

- the `os` or ami name can be `AL_2023` or `AL2` (default is `AL_2023`)
- the `instance_type` (default is `t2.micro`)
- the `volume_type` (default is `gp3`)
- the `volume_size` (default is `8`)

```js
module "installations" {
  source      = "./installations"
  key_pair    = data.aws_key_pair.this.key_name
  ports       = [22]
  subnet      = module.vpc.public_subnets_ids[0]
  name        = "my-instance"
  os          = "AL2"
  type        = "t2.micro"
  volume_size = 8
  volume_type = "gp3"
}
```

## Module issues

- In case of calling 2 modules and the two will be put in the same VPC, is necessary to change the name to the instance. This is because one VPC cannot have two security groups with the same name

## Outputs

```js
```

## `nginx.sh` ✅

Requirements installed with `yum`:

- `make`
- `gcc-c++`
- `python3`
- `python3-pip`


The `/usr/local/nginx/conf/nginx.conf` file is not properly configured, this is to say that is a need to connect by `ssh` with the instance OS and edit manually this file

The version is `nginx-1.25.0`

## `jboss` ✅

Requires `jdk` and the version installed is `jdk-8u131-linux-x64` but here is the script to a newer version

```bash
JDK_VERSION=jdk-17.0.9_linux-x64_bin
cd /opt
wget https://download.oracle.com/java/17/archive/$JDK_VERSION.tar.gz
gunzip $JDK_VERSION.tar.gz
tar -xvf $JDK_VERSION.tar
rm -f $JDK_VERSION.tar
mv jdk-17.0.9 jdk-17
ln -s /opt/jdk-17/bin/java /usr/bin
```

Only is configured the `/standalone/configuration/standalone.xml` port, is necessary more configurations in `standalone.conf`

## Limits of `user_data`

The file size limit is **16 000 characters or 16384 bytes**, some people says that the limit is 64 kB 

The reponse is store the desired script .sh in a bucket and then the user_data will be only some commands like 

```bash
aws configure
aws s3 cp s3://bucket-with-script/ ./ --recursive
```
