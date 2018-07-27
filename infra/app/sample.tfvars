# Read through all the variables and replace value whereever you find *your*
# and as applicable
aws_region = "us-east-1"

s3_origin_bucket = "s3.yourbucket.com"

# unique user assigned cloudfront origin id
cf_origin_id = "your_web_app_blog"

webapp_desc = "Blog on AWS"

s3_log_bucket = "your-s3-log-bucket"

domain_name = "yourapp.com"

# build_types = [
#   "build",
#   "test",
#   "deploy",
# ]

tags = {
  Name        = "your-app-on-aws"
  Environment = "Production"
}

app_name = "your-app-on-aws"

app_directory = "app"

codepipeline_bucket = "your-codepipeline-bucket"

codebuild_image = "aws/codebuild/nodejs:8.11.0"

# S3 bucket name/prefix
codebuild_cache_s3 = "your-cache-bucket/cache"

# github
github_account = "your.name"

github_branch = "master"

github_repo = "your_repo"
