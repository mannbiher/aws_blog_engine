@echo off
cd iam
echo In iam folder deploying IAM roles
terraform init
terraform plan -out=iam.plan
terraform apply -input=false -auto-approve iam.plan
terraform output
echo IAM roles deployed
cd ..\app
echo In app folder deploying app
terraform init
terraform plan -var-file=account.tfvars -out=app.plan
terraform apply -input=false -auto-approve app.plan
terraform output
for /f %%i in ('terraform output codepipeline_name') do set codepipeline_name=%%i
rem Find better way to find version
set codepipeline_version=1
echo Application deployed
cd ..\cf
echo In cf folder deploying cloudformation
aws cloudformation create-stack --stack-name github-webhook-5 ^
    --template-body file://webhook.yaml ^
    --parameters ParameterKey=SecretKey,ParameterValue=%SECRET_TOKEN% ^
        ParameterKey=PipelineARN,ParameterValue=%codepipeline_name% ^
        ParameterKey=PipelineVersion,ParameterValue=%codepipeline_version%
echo Check Cloudformation status in console
cd ..
