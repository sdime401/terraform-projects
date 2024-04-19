# How to Host a static Website on AWS Using Terraform

This is the first of a serie of terraform projects I am working on now. In future post, they will be coupled with CI/CD tools such as Github Actions, Jenkins, and adding monitoring and observability tools.

In this project, we will learn step by step how to host a static website on AWS using terraform! This project makes use of different AWS services and resources such as VPC with Public and Private Subnets, Security groups, EC2, Nat gateway, Internet gateway, Application Load Balancer, Route 53, Auto-Scaling Group, Certificate Manager, Route 53, S3, etc.


**Steps** (All the resources have been created through terraform, except the ACM certificate, and Route 53 domain)

- Create an S3 Bucket and Upload Files to it
    I have attached the files to be uploaded to s3 under [**resource**](resources) folder
- Create the VPC for the Project
- Create NAT Gateway
- Create IAM roles
- Create security groups
- Made use of an existing Keypair, to Launch, and SSH Into the AWS EC2 Instance
- Create an Auto Scaling Group and Scaling Policy For Our Auto Scaling Group
- Register a Domain Name in Route 53 for our Website( I made use of an existing domain i had registered with route 53)
- Register for a Free AWS SSL Certificate to secure our website(I made use of an existing)

Using the `terraform plan` and `terraform apply` should render you the link of the website based of the outputs.tf

**Note:** There will be another project where we make use of modules. 