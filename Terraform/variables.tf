# ---------------
# variables.tf
# ---------------

variable "site_domain" {
  # 公開するサイトのドメイン
  default = ""
}

variable "root_domain" {
  # 公開するサイトのルートドメイン
  default = ""
}

data "aws_caller_identity" "current" {}

variable "email" {
  description = "your email adress"
}
