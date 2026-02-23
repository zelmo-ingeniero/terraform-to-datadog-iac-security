# lambda function module

Get code from local route `infraestructura-exos/examples/lambda/src/` and send it to a lambda function

**To get code from s3 bucket...**

## call module

```js
module "one" {
  source        = "./lambda"
  function-name = "extraction"
}
```

## outputs

```js
output "one" {
  value = {
    code      = module.one.archive
    role      = module.one.role
    function  = module.one.lambda
    log-group = module.one.cloudwatch
  }
}
```

## test

```js
run "lambda-plan" {
  command = plan
}
run "lambda-apply" {
  command = apply
}
```

Change the handlar name according to the code entrypoint `<>.<>` in the `main.tf` file

Change policies and permissions in the iam.tf file, in the data "aws_iam_policy_document" "s3-cloudwatch" block