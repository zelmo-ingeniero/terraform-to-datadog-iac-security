
resource "aws_codepipeline" "this" {
  name          = "CPipeline-repo-env"
  role_arn      = aws_iam_role.this.arn
  pipeline_type = "V2"
  artifact_store {
    type     = "S3"
    location = var.bucket_name
  }
  stage {
    name = "Source"
    action {
      name             = "this-is-visible-1"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["tmp"]
      configuration = {
        S3Bucket    = "tmp-to-cicd-policy-tests"
        S3ObjectKey = "repo/repo.zip"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "this-is-visible-2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["tmp"]
      configuration = {
        ApplicationName     = "repo"
        DeploymentGroupName = "repo-env"
      }
    }
  }

  tags = {
    Name = "CPipeline-repo-env"
  }
}
