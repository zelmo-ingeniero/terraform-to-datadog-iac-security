
# Terraform with AWS

> [!NOTE] 
> Keep in mind that **each account directory contains unique compositions and credentials**. This ensures that resources are managed separately and securely for each composition
Keep in mind that **each account directory contains unique compositions and credentials**. This ensures that resources are managed separately and securely for each composition
> [!INFO] 
> Hashicorp consider that iam_users, key_pairs, acms certificates, and organizations should be created in the web browser, to avoid conflicts and composition lost

I recommend to review this links:

- [Terraform roadmap](https://roadmap.sh/terraform)
- [aws provider registry](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [HCL and CLI docs](https://developer.hashicorp.com/terraform/language)
- [best practices](https://www.terraform-best-practices.com/)

Remember to put the next lines in the `.gitignore` file

```conf
**/.terraform/*
*tfplan*
*.*cred*
*.tfstate
*.tfstate.*
*.pem
*.key
*.pub
*.tfvars
*.tfvars.json
*_override.tf
*_override.tf.json
override.tf
override.tf.json
crash.log
crash.*.log
.terraformrc
terraform.rc
```

## Getting started with AWS

1. Create or paste the IAM SECRET and ACCESS keys of your user (from the desired AWS account)

```
[default]
aws_access_key_id = EXAMPLEXAMPLEXAMPLEX
aws_secret_access_key = exampleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
region = us-east-1
```

2. Install on your OS the Terraform CLI (and also other recomended tools as mentioned later)
3. Clone this repository
4. Put your keys in a new `.credentials` file (ignored by git) in the next ways

```
.                   # each account should have their own credentials
├── account_1/
│   ├── ...
│   └── .credentials
├── account_2/
│   ├── ...
│   └── .credentials
└── account_n/
    ├── base/
    ├── modules/       
    └── .credentials
```

Each account typically uses a specific region and has a specific account ID

- The Terraform state is a large JSON file that keeps stored all of the infraestructure, their details and metadata. If Terraform is not finding the bucket to store the remote state it will show an error and will cannot run `terraform init`
- If Terraform detect that the region or the account ID is different to the stablished to the code, it will show errors

You can change the region, the credentials or the code of the output validation

5. Go to the AWS console in the AWS account, then list the S3 buckets and if no exist a bucket to the "**remote Terraform state backend**" or similar then is needed to create it
  
    Follow this instructions: [Stablish the remote state to Terraform](#Create-remote-state)

**the remote state is to have more reliability and security**

6. Once ready the "remote terraform state backend" in the account you can run `terraform init` and `terraform state list` to view the resources already existing

## About CLI

- With minimum changes (or writing new things never written) you can use `terraform validate` to find syntax errors
- For every important changes in`.tf` files run `terraform plan`
- Run `terraform apply` or `terraform apply -auto-approve` to create, modify or erase resources according to the plan
- Always as possible use the `plan` command with the `-out=` flag (`terraform plan -out=tfplan`), and then use that file with the `apply` command (`terraform apply tfplan`)
- Run `terraform state list` to list current resources or resource modules managed by the composition 
- Run `terraform output` to print only the outputs in the composition
- Run `terraform refresh` to find *drift* (differences between the code and the real existing resources) 
- Run `terraform plan -destroy` to examine what resources will be deleted in case of run `terraform destroy` wihtout destroying them

### Managing the state

I need soon to learn the `state` commands

### Import already existing resources

Here are a list of [disadvantages](https://developer.hashicorp.com/terraform/tutorials/state/state-import#limitations-and-other-considerations)

## About testing the code

- With `.tftest.hcl` files run `terraform test` (if applicable) to ensure that all is working good

There are a variety of included mechanisms to implement tests

- The `fmt -recursive`, `validate`, and `plan` commands: ensure that the code is writed correctly. If this fails commonly Terraform stops. This is the most used
- `check` blocks: Ideal to test another external services that you want to use, like check if that one API or website is available. If a `check` fails it only shows warnings that let you apply changes
- `validation` blocks in variables: Ideal to implement at the creation of custom modules. If it fails Terraform stops
- `postcondition` blocks in outputs: Can be used to review that the resources or even the composition are the desired. Ideal to check if the AWS account or region is the correct. If this tests fails you cannot `apply` but let you read almost all of the plan and output
- `precondition` and `postcondition` in the `lifecycle` blocks: This are not commonly used
- The buckets and other storage resources should have different conditions to avoid that type of misconfigurations

> [!INFO]
> There are another external testing tools like using shellcripts with some AWS CLI commands, Terratest, Terrascan, TFSec, TFtest, checkov and so on

### The `terraform test` command:

This is the most powerful an native tool to do testing, you can configure even "extra resources" to do complex validation at infraestructure level. But the most quickly, easy to implement, easy to copy-paste and efective way to use it is writing the next code in a file called `<directory name>.tftest.hcl`

```js
run "<directory name>_plan" {
  command = plan
}
run "<directory name>_apply" {
  command = apply
}
```

Honestly, Here running `terraform test` is equivalent to run `terraform plan && terraform apply -auto-approve && terraform destroy -auto-approve` 

I recommend to keep the code in tests files as simpler as possible

### The 'tflint' tool

This tool is one of the most used by the companies, TFlint scans the code statically and evaluate different rules. For me the best rules are:

- Deprecated syntaxis (e.g. Using `.*.` instead of `[*]`)
- Resource blocks, data blocks, variables and more writted but unused
- Bad calls or invalid input to functions parameters (even if is known that `apply` will work in that execution)

Install TFlint just by download the binary and copy it to `/usr/bin`

The rules to be applied are declared in the `.tflint.hcl` file. The most specific and advanced would be to have a `.tflint.hcl` file per module (but for this repo I just use one)

By default running in some directory the command `tflint` it just scans and looks for the `.tflint.hcl` file in the current directory. I prefer to scan the entire repository at once, to do that I put a copy of my `.tflint.hcl` in my user direcotry `~`  and the command used to scan the entire repository is: 

```bash
tflint -c ~/.tflint.hcl --recursive
```

Disadvantages:

- Logical errors (for example inserting `null` in a map instead of {}) prevents the scan from starting and the output only shows those errors
- Easily can add complexity to a repository (adding `.tflint.hcl` files everywhere)
- The tool download the linters locally in the path `~/.tflint.d/plugins` by running `tflint --init` command
- The tool is still in 0 releases

### The `trivy` (new version of TFSec) tool

This tool created by Aquasecurity can scan vulnerabilities statically in the Terraform code whithout syntax errors and is uncommented. I just installed Trivy with `dnf` in my device. Is possible to ignore vulnerabilities that you want to permit (like the security group rules that enable access to 0.0.0.0/0) with a simple text file called `.trivyignore` with the ID of the Trivy vulnerability detected

This tool is used with commands like this:

```bash
trivy conf --ignorefile .trivyignore aws-infraestructura-exos # scan all the AWS directory ignoring some vulnerabilities
trivy conf -s CRITICAL,HIGH ./                                # shows only certain categories
trivy conf --debug aws-infraestructura-exos/examples/cicd     # scan only some modules and show more detailed logs about what files are scanned
trivy fs --scanners secret,misconfig ./                       # looks for secrets or passwords hardcoded in plain text
```

Scans a Terraform plan

```js
terraform plan --out tfplan
terraform show -json tfplan > tfplan.json
trivy conf ./                             # scan the entire directory including the tfplan files
```

Keep in mind that Trivy scans the entire given directory including that is not currently created or used, to scan only the real used or created resources only scan the `tfplan` compressed file (as in the example above). I consider that Trivy is good, easy to implement and fast to learn. This tool will help me to practice hardening in IaC, I will to use it as much as possible

Disadvantages:

- The modules, submodules or subdirectories sometimes might not be detected properly. More specifically: all `.tf` files are readed, parsed and scanned by Trivy but if the call to the directory (module) is commented then the code is considered unused and then you will no have the scan results in the output, that fact forces you to review and modify files
- Resource and data blocks are the objective, while check, locals, variable and output blocks represents no risks
- Files in JSON format with policies are not scanned with this tool, that is bad because I use all policies as JSON file (I know that can be scanned with checkov)
- By default external modules downloaded automatically in `.terraform` directory are also scanned (this repo don't use external modules)
- Currently is safer to scan both the `.tf` files and the plan, not only one
- The tool is still in 0 releases

## CI/CD to Terraform

I'm not sure how to implement this part, but is required and is utilized in different companies

## Create remote state

Summary:

1. Init a local state file: `terraform init`
2. Write the code to create a bucket
3. Create locally a bucket: `terraform apply`
4. Change the code to continue using the bucket as remote state
5. Migrate local state to the bucket: `terraform init -migrate-state`
6. Delete the empty state file

> [!INFO] 
> Review the [different options](https://developer.hashicorp.com/terraform/language/settings/backends/http) to store the terraform state file

I want to try the [Free layer of Spacelift](https://spacelift.io/pricing), but the disadvantage is that you only can have 1 terraform state 

Read the next code, create a bucket name in the variable. I recommend to include "remote, backend, state, terraform" or similar words. Optionally is recommended to split it in `main.tf`, `s3.tf` and `vars.tf` files

```js
terraform {
  required_version = "~> <version>"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> <version>"
    }
  }
  # uncomment after local apply
  # backend "s3" {
  #   profile                  = "infra"
  #   shared_credentials_files = ["<path to credential file>"]
  #   bucket                   = "<the bucket name as in the var.bucket_name>"
  #   key                      = "<name that will have the state file>"
  #   region                   = "us-east-1"
  #   encrypt                  = true
  # }
}

provider "aws" {
  shared_config_files      = ["<path to credential file>"]
  shared_credentials_files = ["<path to credential file>"]
  profile                  = "<credential profile>"
}

resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" // "aws:kms" or "aws:kms:dsse"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket     = aws_s3_bucket.this.id
  depends_on = [aws_s3_bucket_versioning.this]
}

variable "bucket_name" {
  type    = string
  default = "<insert the bucket name>-tarraform-state"
  validation {
    condition     = length(regexall("[!-,:-@[-`{-~/]+", var.bucket_name)) == 0
    error_message = "The bucket name has special symbols"
  }
  validation {
    condition     = length(regexall("[A-Z]+", var.bucket_name)) == 0
    error_message = "The bucket name has uppercases"
  }
  validation {
    condition     = length(var.bucket_name) < 64 && length(var.bucket_name) > 2 || length(var.logging) == 0
    error_message = "The bucket name is too short or large"
  }
}
```

Once writed the new bucket name, then run `terraform init`, `terraform validate`, `terraform plan` and `terraform apply`. 

This commands creates the bucket but right now the **.tfstate** file is only in your device. Now to upload the new **.tfstate** to the bucket, update uncomment the code in the  `terraform {}` block

Then run `terraform init -migrate-state` and write `yes` in the prompt. 

> [!NOTE] 
> From now on, the command `destroy` is not available to the composition, because it attempts to destroy the bucket, If the bucket is destroyed Terraform will require run a new `terraform init` forgetting the last state

## Oldest code (ignore)

One bucket with objects can be empty by adding the next code

```js
resource "null_resource" "delete_objects" {
  count = length(data.aws_s3_bucket_objects.all_objects.keys)
  provisioner "local-exec" {
    command = "aws s3 rm s3://${aws_s3_bucket.my_bucket.bucket}/${data.aws_s3_bucket_objects.all_objects.keys[count.index]}"
  }
  depends_on = [data.aws_s3_bucket_objects.all_objects]
}
```

power off instance

```js
resource "aws_ec2_instance_state" "prd" {
  count       = var.instances
  instance_id = aws_instance.prd[count.index].id
  state       = var.instance-status
}
```

Instances per tgp

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
resource "aws_instance" "alb" {
  for_each = {
    for i in local.instances-list :
    i.instance-name => {
      sg       = i.instance-name
      instance = i.instance
      subnet   = i.az
    }
  }
  ami                    = data.aws_ami.AL2023.id
  instance_type          = each.value.instance
  key_name               = aws_key_pair.lb.key_name
  subnet_id              = aws_subnet.alb[each.value.subnet].id
  vpc_security_group_ids = [aws_security_group.sg-instance[each.value.sg].id]
  root_block_device {
    tags = {
      Name = "vol-${var.project}-${each.key}${var.suffix}"
    }
  }
  tags = {
    Name = "${var.project}-${each.key}${var.suffix}"
  }
}
resource "aws_security_group" "sg-instance" {
  for_each = {
    for i in local.instances-list : i.instance-name => i
  }
  vpc_id      = aws_vpc.vpc.id
  name        = "sgp-${var.project}-${each.key}${var.suffix}"
  tags = {
    Name = "sgp-${var.project}-${each.key}${var.suffix}"
  }
}
```

Use multiple "`user_datas`"

```js
data "cloudinit_config" "cic-jboss" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    filename     = "jboss.sh"
    content      = file("jboss.sh")
  }
}
resource "aws_instance" "jboss-ec2" {
  ami = data.aws_ami.al2023.id
  // t2.micro is at risk of using 100% of RAM and CPU
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.jboss-key.key_name
  security_groups = [aws_security_group.to-jboss.name]
  monitoring      = true
  //you need to connect to the instance to run it
  user_data = data.cloudinit_config.cic-jboss.rendered
  provisioner "file" {
    source      = "./jdk-7u80-linux-x64.rpm"
    destination = "/home/ec2-user/jdk-7u80-linux-x64.rpm"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${self.key_name}.pem")
      host        = self.public_dns
    }
  }
  provisioner "file" {
    source      = "./jboss-as-7.1.1.Final.zip"
    destination = "/home/ec2-user/jboss-as-7.1.1.Final.zip"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${self.key_name}.pem")
      host        = self.public_dns
    }
  }
  provisioner "file" {
    source      = "./jboss.sh"
    destination = "/home/ec2-user/jboss.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${self.key_name}.pem")
      host        = self.public_dns
    }
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 8
    volume_type           = "gp2"
    tags = {
      Name = "storage-to-jboss-tf"
    }
  }
  tags = {
    Name = "jboss-srv-tf"
  }
}
```

Create KMS key pair to the instance

```js
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "kp" {
  key_name   = "autoscaling"
  public_key = tls_private_key.tls.public_key_openssh
  tags = {
    Name = "autoscaling"
  }
}
resource "local_file" "kp" {
  filename        = "${aws_key_pair.kp.key_name}.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 0400
}
```

```js
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "kp" {
  key_name   = "installation"
  public_key = tls_private_key.tls.public_key_openssh
  tags = {
    Name = "installation"
  }
}
resource "local_file" "file" {
  filename        = "${aws_key_pair.kp.key_name}.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 0400
}
```

```js
resource "aws_key_pair" "kp" {
  count      = var.instances
  key_name   = "${var.project}${count.index + 1}-dev-${var.env-number}"
  public_key = tls_private_key.tls.public_key_openssh
  tags = {
    Name = "kp-${var.project}-${count.index + 1}-dev${var.env-number}${var.suffix}"
  }
}
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "key-file" {
  count           = var.instances
  filename        = "${aws_key_pair.kp[count.index].key_name}.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 0400
}
```

```js
resource "aws_key_pair" "kp" {
  count      = var.instances
  key_name   = "${var.project}${count.index}-prd"
  public_key = tls_private_key.tls.public_key_openssh
  tags = {
    Name = "kp-${var.project}${count.index}-prd${var.suffix}"
  }
}
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "key-file" {
  count           = var.instances
  filename        = "${aws_key_pair.kp[count.index].key_name}.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 0400
}
```

```js
resource "tls_private_key" "lb" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "lb" {
  key_name   = "${var.project}${var.suffix}"
  public_key = tls_private_key.lb.public_key_openssh
  tags = {
    Name = "${var.project}${var.suffix}"
  }
}
resource "local_file" "lb" {
  filename        = "${aws_key_pair.lb.key_name}.pem"
  content         = tls_private_key.lb.public_key_openssh
  file_permission = 0400
}
```

security group

```js
resource "aws_security_group" "public" {
  for_each = var.public_subnets

  description = "for public-${each.value} subnet"
  name        = "sgp-public-${each.value}${var.tag_name}"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "to SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.cidr_zero]
  }
  egress {
    description      = "no outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.cidr_zero]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sgp-public-${each.value}${var.tag_name}"
  }
}


resource "aws_security_group" "sg-private" {
  for_each    = var.private-subnets
  name        = "sgp-private-${each.key}${var.suffix}"
  description = "for private-${each.key} subnet"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "to SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr-zero]
  }
  egress {
    description      = "no outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr-zero]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "sgp-${each.key}-private${var.suffix}"
  }
}

```

move existent resources from root to a module without destroying them

```js
moved {
  from = aws_s3_bucket.backend
  to = module.s3-vpc.aws_s3_bucket.backend
}
moved {
  from = aws_s3_bucket_acl.backend
  to = module.s3-vpc.aws_s3_bucket_acl.backend
}
moved {
  from = aws_s3_bucket_ownership_controls.backend
  to = module.s3-vpc.aws_s3_bucket_ownership_controls.backend
}
moved {
  from = aws_s3_bucket_public_access_block.backend
  to = module.s3-vpc.aws_s3_bucket_public_access_block.backend
}
moved {
  from = aws_s3_bucket_versioning.backend
  to = module.s3-vpc.aws_s3_bucket_versioning.backend
}
```
