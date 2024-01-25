variable "cidr-block" {
  type    = string
  default = "10.1.0.0/16"
}
variable "vpc-name" {
  type    = string
  default = "jupiter-terraform-vpc"
}

variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]

}
variable "publicsubnetCidr" {
  type = map(any)
  default = {
    "Public_Subnet_AZ1" = "10.1.1.0/24"
    "Public_Subnet_AZ2" = "10.1.2.0/24"
  }

}

variable "privateSubnetcidr" {
  type = map(any)
  default = {
    "Private_Subnet_AZ1" = "10.1.3.0/24"
    "Private_Subnet_AZ2" = "10.1.4.0/24"
  }
}

variable "tags" {
  type    = list(string)
  default = ["Public-RT", "Private-RT"]
}


variable "PublicRT-Destination" {
  default = "0.0.0.0/0"
}

variable "tfstate-bucket" {
  default     = "my-tf-state-bucket"
  description = "Store the state files"
}

# variable "ACM" {
#   type    = string


# }

variable "s3policyarn" {
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

variable "ssmpolicyarn" {
  default = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

variable "from_port" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "to_port" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "ip_protocol" {
  type    = string
  default = "tcp"
}

variable "upload_web" {
  description = "The source of the files to be uploaded to S3"
  default     = "E:\\KODEKLOUD\\JupiterRunback\\jupitar"       #This is where I had my files to be uploaded to S3 locally, but if you store them within the tf module,
                                                              # you can use the ${path.module} to point to it.
}

variable "web_asg_desired_capacity" {
  default = 2
  type    = number
}


variable "certificate_domain_name" {
  default = "*.myaws2022lab.com"
}