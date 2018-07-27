provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "m-terraform-state"
    key    = "aws_blog_engine/iam/terraform.tfstate"
    region = "us-east-1"
  }
}

# CodeBuild for Build and Test and Deploy
# CodePipeline to deploy
# Github trigger will be done in CloudFormation

resource "aws_codepipeline" "app_pipeline" {
  name     = "${var.app_name}-pipeline"
  role_arn = "${data.terraform_remote_state.iam.codepipeline_iam_role}"

  artifact_store {
    location = "${var.codepipeline_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration {
        PollForSourceChanges = "false"
        Owner                = "${var.github_account}"
        Repo                 = "${var.github_repo}"
        Branch               = "${var.github_branch}"
        OAuthToken           = "${var.github_oauth_token}"
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
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      version          = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.app_build.id}"
      }
    }
  }

  # TODO Setup testing for you app
  # stage {
  #   name = "Test"


  #   action {
  #     name            = "Build"
  #     category        = "Build"
  #     owner           = "AWS"
  #     provider        = "CodeBuild"
  #     input_artifacts = ["test"]
  #     version         = "1"


  #     configuration {
  #       ProjectName = "test"
  #     }
  #   }
  # }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build"]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.app_deploy.id}"
      }
    }
  }
}

# Codebuild to build, test and deploy
resource "aws_codebuild_project" "app_build" {
  name          = "${var.app_name}-build-project"
  description   = "Build and package app for ${var.app_name}"
  build_timeout = "10"
  service_role  = "${data.terraform_remote_state.iam.codebuild_iam_role}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.codebuild_build_cache_s3}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.codebuild_image}"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "APP_DIR"
      "value" = "${var.app_directory}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  tags = "${var.tags}"
}

resource "aws_codebuild_project" "app_deploy" {
  name          = "${var.app_name}-deploy-project"
  description   = "Deploy for ${var.app_name}"
  build_timeout = "10"
  service_role  = "${data.terraform_remote_state.iam.codebuild_iam_role}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.codebuild_deploy_cache_s3}"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = "true"

    environment_variable {
      "name"  = "S3_DEPLOY_BUCKET"
      "value" = "${var.app_directory}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "deployspec.yml"
  }

  tags = "${var.tags}"
}
