### Define the IAM user
resource "aws_iam_user" "developer_user" {
  name = "developer-user"
}

resource "aws_iam_access_key" "developer_access_key" {
  user    = aws_iam_user.developer_user.name
}

#Define the IAM policy for the KMS key
data "aws_iam_policy_document" "kms_key_policy_document" {
  statement {
    effect  = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_key.s3_key.arn
    ]
  }
}

resource "aws_iam_policy" "kms_policy" {
  name   = "kms_key_developer_access"
  policy = data.aws_iam_policy_document.kms_key_policy_document.json

}

resource "aws_iam_user_policy_attachment" "kms_key_policy_attachment" {
  user       = aws_iam_user.developer_user.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

#Define the IAM policy for the s3 ARGO access
resource "aws_iam_policy" "argo_s3_access" {
  name   = "argo-s3-access"
  policy = jsonencode({
    "Version":"2012-10-17",
    "Statement":[
      {
        "Effect":"Allow",
        "Action":[
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource":"arn:aws:s3:::${aws_s3_bucket.argo_s3_bucket.id}/*"
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:ListBucket"
        ],
        "Resource":"arn:aws:s3:::${aws_s3_bucket.argo_s3_bucket.id}"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "argo_policy_attachment" {
  user       = aws_iam_user.developer_user.name
  policy_arn = aws_iam_policy.argo_s3_access.arn
}
