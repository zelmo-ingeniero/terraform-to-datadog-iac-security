
output "iam_role_name" {
  value = aws_iam_role.this.name
}

output "codepipeline_stages" {
  value = {
    (aws_codepipeline.this.id) = { for s in aws_codepipeline.this.stage :
      s.name => s.action[*].name
    }
  }
}
