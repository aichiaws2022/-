## 1. 本ポートフォリオ作成の目的
 IT業界未経験からインフラエンジニアへの転職を目指すにあたり、一定の自走力があることを
証明するために作成しました。商用CMSにおいてシェア一位のWordpressをAWSサービスと IaC技術を
用いてデプロイするインフラ環境の構築を目標としました。インフラ自動化についてはCloudFormationと
Terraformの二つのツールを選定。

インフラ環境構築図
![インフラ drawio](https://github.com/aichiaws2022/-/assets/117337037/33a3c38e-5e26-4b7d-bd18-fae2614f5517)


  
## 2. AWS基本設計
### 2.1 可用性
二つの異なるAZにインスタンスとRDSを配置し冗長化を確保。またALBによりインスタンスへのアクセス分散を行い、負荷の集中を防ぐ。
### 2.2 セキュリティ
Wordpress用サーバをプライベートサブネットに配置し、インターネットからのアクセス制御を管理する。
管理者がEC2 インスタンスへ SSH接続する際にSession Managerを使用することで、踏み台サーバを用いるよりもセキュリティを確保可能。またACMを用いて、WordpressサイトをHTTPS化する。

### 2.3 開発手法
 マネジメントコンソールではなく、CloudFormationとTerraformnの二つのIaCツールを用いたコード開発でインフラ環境を構築する。インスタンスへのミドルウェアのダウンロード及びファイルシステムのマウントも自動化対象とした。


## 3. AWS詳細設計
###  サービス一覧
No.|サービス名|主な用途|備考
--|--|--|--
1|EC2|サーバ|Userdataを使い、Wordpress構築に必要なミドルウェアを自動でダウンロード
2|RDS|データベース|マルチAZ
3|IAM|認証|Session Manager用のIAMロールをIAM インスタンスプロファイルとして使用
4|ALB|負荷分散|プライベートサブネットに配置された二つのEC2インスタンスに対して負荷分散を行う
5|SecurityGroup|トラフィック制御|
6|VPC|仮想ネットワーク|サブネット・IGW
7|CloudWatch|メトリクス監視|システムエラー時のインスタンス自動復旧、インスタンスcpu使用率(80％)の監視,ALBによるインスタンス死活監視の三つのアラームをサポート
8|WAF|ファイアウォール|Wordpress用WAFルールを適用
9|Route53|ドメイン管理|本ポートフォリオでは事前にドメイン（myawsportfolio.click）を登録
10|ACM|SSL証明書の管理|Route 53で登録したドメインのSSL証明書の発行、サイトのhttps化に使用
11|SNS|メール通知|CloudWatchアラームと連携して管理者に通知
12|VPC Endpoint・S3|Session Manager通信用|
13|CloudFormation・Terraform|IaCツール|
14|Session Manager|EC2との通信|EC2へセキュアに接続
15|Secrets Manager|パスワード管理|RDSのパスワードを自動生成、インフラ構築後コンソールから確認可能
16|NAT Gateway|NAT|プライベートサブネットのインスタンスがWordpress用データをダウンロードする際に使用。ダウンロード後、削除することでコストを抑えることが可能
17|Elastic File System|ファイルストレージ|Wordpress用ディレクトリをEFS上に作成

構築例

![インフラ2](https://github.com/aichiaws2022/-/assets/117337037/d841c9e3-50a9-4910-b0fd-6c893793d6f9)

![スクリーンショット (32)](https://github.com/aichiaws2022/-/assets/117337037/0bad0717-5730-4ea4-af17-d3f510d1b76c)
