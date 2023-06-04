# ---------------
# variables.tf
# ---------------

variable "site_domain" {
  # 公開するサイトのドメイン
  default = "myawsportfolio.click"
}

variable "root_domain" {
  # 公開するサイトのルートドメイン
  default = "myawsportfolio.click"
}

data "aws_caller_identity" "current" {}

variable "email" {
  description = "your email adress"
}