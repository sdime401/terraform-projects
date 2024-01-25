resource "aws_s3_bucket" "s3web_bucket" {
  bucket        = "s3web.myaws2022lab.com"
  force_destroy = true

}

# Let's upload the website files into the S3 bucket created

locals {
  files_to_upload = fileset(var.upload_web, "**")   # the ** will copy all the content of the folder, files, and subdirectories. 
                                                    # You can look up the fileset function in terraform for more details
}

resource "aws_s3_object" "jupitar_object" {
  for_each = local.files_to_upload                  

  bucket = aws_s3_bucket.s3web_bucket.bucket
  key    = each.value
  source = "${var.upload_web}/${each.value}"
}