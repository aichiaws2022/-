# AmazonSSMManagedInstanceCore の情報を取得
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM ロール
resource "aws_iam_role" "instance" {
  name               = "instance"
  path               = "/"
  assume_role_policy = file("policy.json")
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance_ssm" {
  name   = "instance_ssm"
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy.ssm_core.policy
}

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance"
  role = aws_iam_role.instance.name
}