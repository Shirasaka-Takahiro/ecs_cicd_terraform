■Set-Up
1. Create S3 for tfstate
ex)example-dev-alb-accesslog-bucket

2. Build Dockerfile locally

■Resources
<br />
ECS(fargate) x 2
<br />
ECR
<br />
ALB x 1
<br />
Cloud Watch Log Group
<br />
Route53
<br />
ACM

■Architecture
<br />
Go to wiki page!

■Deploy
1. Move prod directory
2. terraform init
3. terraform plan
4. terraform apply