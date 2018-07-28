# Single Tenant(currently) Blog Engine using AWS

## Reinventing the wheel to learn
This blog engine use
1. Amazon S3 bucket to hold static files
2. AWS CloudFront to server the static files
3. Route 53 for CloudFront custom domain
4. AWS CodePipeline trigged via GitHub Webhook
5. AWS CodeBuild to build, test and deploy the application
6. Terraform scripts to create the infrastructure are inside infra folder.