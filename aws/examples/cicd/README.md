# CI/CD modules

i will to try multiple pipelines

## CodeBuild

- This codebuild module get artifacts from 1 bucket and then do the build
- Review the `./codebuild/builspec-*.yaml` files
- Each repository can have different environments
- Source files are searched in the path: `env/<repo name>-build/<repo name>.zip` of the bucket

Basic module call

```js
module "codebuild" {
  source = "./codebuild"
  artifact_bucket = "<one bucket name with artifacts>"
  node_repos = {
    <repo number one>   = ["dev01", "stage01"]
    <repo number two>   = ["dev01"]
    <repo number three> = ["dev01", "stage01", "uat01"]
  }
}
```

And is possible to use java repositories

```js
module "codebuild" {
  source = "./codebuild"
  artifact-bucket = "<one bucket name with artifacts>"
  node-repos = {
    <repo number one>   = ["dev01", "dev02"]
    <repo number two>   = ["dev01"]
    <repo number three> = ["dev01", "stage01", "uat01"]
  }
  java-repos = {
    <repo number four>   = ["dev01", "dev02"]
    <repo number five>   = ["dev01"]
  }
}
```

### CodeBuild notes

- Is expected that the artifact_bucket contains the `.zip` files in the path `${repo-env}/${repo-name}-build/` 
- In the AWS Console each codebuild project creates their own "resource_access_policy" as an inline policy over a given service role
- Every codebuild role can only have a maximum of 10 inline policies

But with Terraform the roles and their inline policies will be:

```json
{
  first-repo-role: [
    S3FullAccess-aws-managed-policy
    first-repo-env01-inline-policy
    first-repo-env02-inline-policy
    first-repo-env0n-inline-policy
  ]
  second-repo-role: [
    S3FullAccess-aws-managed-policy
    second-repo-env01-inline-policy
    ...
  ]
  ...
}
```

- The limitation is that cannot be more than 9 environments per repository name

## CodeDeploy

- Each *"repo"* will be a `aws_codedeploy_app`
- Each *"repo-env"* will be a `aws_codedeploy_deployment_group`
- All of the deployment groups and apps in the module will have the same role
- All of the deployment groups in the module will target to the same EC2 instance name, then to target to different instances you will need to call **multiple module blocks**

Module call

```js
module "codeploy" {
  source      = "./codeploy"
  ec2-nametag = <the desired ec2 intance tag name>
  apps = {
    <repo one>   = ["dev01", "uat01"]
    <repo two>   = ["dev01"]
    <repo three> = ["dev01", "uat01", "stage01"]
  }
  role-arn = <one codeploy service role arn>
}
```

Or multiple modules (to target to different EC2 instances)

```js
module "codeploy" {
  source      = "./codeploy"
  ec2-nametag = <the desired ec2 intance tag name>
  role-arn    = <one codeploy service role arn>
  apps = {
    <repo one> = ["dev01", "uat01"]
    <repo two> = ["dev01"]
  }
}

module "codeploy2" {
  source      = "./codeploy"
  ec2-nametag = <another ec2 intance tag name>
  role-arn    = <one codeploy service role arn>
  apps = {
    <repo three> = ["dev01"]
    <repo four>  = ["dev01", "uat01", "stage01"]
    <repo five>  = ["dev01", "uat01", "stage01"]
  }
}
```

Avoid to repeat the repo names

Outputs

```js
output "cicd" {
  value = [
    module.codeploy,
    module.codeploy2
  ]
}
```

### CodeDeploy notes

The service role can be created with this code

```js
data "aws_iam_policy" "AWSCodeDeployRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3-codeploy-cross-account" {
  statement { # unused policy
    effect  = "Allow"
    actions = ["s3:Get*"]
    resources = [ "<bucket arn in another account>/*" ]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [ "<bucket arn in another account>" ]
  }
}

data "aws_iam_policy_document" "kms-codeploy-cross-account" {
  statement { # unused policy
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt"
    ]
    resources = [ "<respective kms arn in root account>" ]
  }
}

resource "aws_iam_role" "codeploy" {
  name                = "project-codeploy-service-role"
  assume_role_policy  = data.aws_iam_policy_document.assume-role.json
  managed_policy_arns = [ data.aws_iam_policy.AWSCodeDeployRole.arn ]
  # uncomment to add
  # inline_policy {
  #   name = "kms-codeploy-cross-account"
  #   policy = data.aws_iam_policy_document.kms-codeploy-cross-account.json
  # }
  # inline_policy {
  #   name = "s3-codeploy-cross-account"
  #   policy = data.aws_iam_policy_document.s3-codeploy-cross-account.json
  # }
}
```

The policies `s3-codeploy-cross-account` and `kms-codeploy-cross-account` are for the cases where the codeploy is targeted to an S3 bucket with KMS encryption in another account

## CodePipeline

Module call

```js
```

Outputs

```js
```

### CodePipeline roles

```js
```

## ECR

Module call

```js
```

Outputs

```js
```

Tests

```js
```

