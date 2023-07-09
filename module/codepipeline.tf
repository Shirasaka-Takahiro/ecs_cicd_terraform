resource "aws_codepipeline" "pipeline" {
  name     = "${var.general_config["project"]}-${var.general_config["env"]}-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.bucket_pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      #owner            = "ThirdParty"
      owner            = "AWS"
      #provider         = "GitHub"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        #Owner                = "Shirasaka-Takahiro"
        #Repo                 = "ecs_cicd_terraform-image"
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "https://github.com/Shirasaka-Takahiro/ecs_cicd_terraform.git"
        BranchName              = "main"
        #OAuthToken           = aws_ssm_parameter.github_personal_access_token.value
        #PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.cluster.arn
        ServiceName = aws_ecs_service.service.name
        FileName    = "imagedef.json"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "github" {
  name = "${var.general_config["project"]}-github-connection"
  provider_type = "GitHub"
}

#resource "aws_codepipeline_webhook" "webhook" {
#  name            = "webhook-fargate-deploy"
#  authentication  = "GITHUB_HMAC"
#  target_action   = "Source"
#  target_pipeline = aws_codepipeline.pipeline.name

#  authentication_configuration {
#    secret_token = aws_ssm_parameter.github_personal_access_token.value
#  }

#  filter {
#    json_path    = "$.ref"
#    match_equals = "refs/heads/{Branch}"
#  }
#}