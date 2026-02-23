
# Vital required resources and assets to the account

Is good practice to have a "directory base" or "composition base" with resources or even modules needed and used by other services through the account. For example the VPC subnets, KMS keys, IAM roles, repositories, the S3 buckets and more resources commonly are inserted as inputs to create another resources 

In this case I did just copy-paste the `vpc` and `s3` modules from the `examples/` directory

