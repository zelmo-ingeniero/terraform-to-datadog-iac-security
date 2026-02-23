
# Original custom infraestructure modules

**Remember to add the credential file**

```bash
# cat .credentials
[default]
aws_access_key_id = 
aws_secret_access_key = 
region = us-east-1
```

## Each directory is a module or a group of modules

| Directory      | To do                           |
|----------------|---------------------------------|
| instalations   | using Ansible                   |
| cicd           | creating multi codepipeline     |
| lambda         | combine with a new APIGW        |
| load_balancers | checking the listeners and TGPs |
| vpc            | completed                       |

The next directories has their own *tfstates* and testing files

* base: 
  contains the remote backend bucket, one vpc with CIDR = `172.20.0.0/16` and three subnets = [ `172.20.0.0/20`, `172.20.16.0/20`, `172.20.32.0/20` ]
* examples (depends on base bucket) and contains reusable modules that can be copied to another account

