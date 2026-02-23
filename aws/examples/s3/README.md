
# S3 buckets 

> [!WARNING]
> The attribute `force_destroy = true` enables the `apply` and `destroy` commands to erase the entire buckets including their content, this attribute can be useful to run the `terraform test` command but in any other cases is very dangerous

The compositions with S3 Buckets has automatically unavailable the command `terraform destroy` as mentioned above

For each bucket is possible to:

- Enable or disable versioning
- Enable or disable logging to another extra bucket

## Call to module

Basic call to module

```js
module "s3" {
  source = "./s3"
  buckets = {
    my-bucket-one = []
    my-bucket-two = []
  }
}
```

- Where the names (`my-bucket-one` and `my-bucket-two`) will be the visible bucket name

To add the current *AWS account id* to the bucket name, call the module by the next way

```js
data "aws_caller_identity" "current" {}

module "s3" {
  source = "./s3"
  buckets = {
    "my-bucket-one-${data.aws_caller_identity.current.id}" = []
  }
}
```

Enable bucket versioning (and object_locking)

```js
module "s3" {
  source = "./s3"
  buckets = {
    my-bucket-one = ["versioning"]
  }
}
```

To enable logging, is required to also add one extra bucket to store the logs over the others. This will create a new bucket with versioning (obviously without logging)

```js
module "s3" {
  source = "./s3"
  buckets = {
    my-bucket-one = ["logging"]
  }
  logging = "extra-bucket-to-store=logs"
}
```

Each bucket will have their own path to their own logs in `/<logging enabled bucket name>/`

Enable both, versioning and logging

```js
module "s3" {
  source = "./s3"
  buckets = {
    my-bucket-one = [ "versioning", "logging" ]
  }
  logging = "extra-bucket-to-store-logs"
}
```

### S3 issues

- There are possibility to only enable secure api conections.... later I will to refactor the policies
- One buckets with versioning and logging almost is PCI DSS compliant, but I still need to check the *KMS bucket Key* feature

One bucket with objects can be empty by adding and applying the next code

```js
resource "null_resource" "delete_objects" {
  count = length(data.aws_s3_bucket_objects.all_objects.keys)
  provisioner "local-exec" {
    command = "aws s3 rm s3://${aws_s3_bucket.my_bucket.bucket}/${data.aws_s3_bucket_objects.all_objects.keys[count.index]}"
  }
  depends_on = [data.aws_s3_bucket_objects.all_objects]
}
```

