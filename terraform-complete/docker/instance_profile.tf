data "aws_iam_policy_document" "assume_role" {

  statement {

    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }

}

resource "aws_iam_role" "instance" {

  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Terraform   = true
    Name        = var.name
    Environment = var.environment
  }

}

data "aws_iam_policy_document" "instance_policy" {

  statement {
    effect = "Allow"
    sid    = "AllowReadingTagsInstancesRegionsFromEC2"
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeIamInstanceProfileAssociations",
      "ec2:DescribeVolumes"
    ]

    resources = [
    "*"]
  }

  statement {
    effect = "Allow"
    sid    = "AllowReadingResourcesForTags"
    actions = [
      "tag:GetResources"
    ]

    resources = [
    "*"]
  }


}

resource "aws_iam_policy" "instance_policy" {
  name   = "${var.environment}-${var.name}"
  path   = "/"
  policy = data.aws_iam_policy_document.instance_policy.json
}

resource "aws_iam_role_policy_attachment" "instance_policy" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.instance_policy.arn
}

resource "aws_iam_instance_profile" "instance" {
  name = var.name
  role = aws_iam_role.instance.name
}