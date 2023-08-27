###################
# EC2 Instance role
###################

# Sts policy
data "aws_iam_policy_document" "docker_sts_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "docker_role" {
  name               = "dockerec2_role_docker_-${random_pet.randy.id}"
  assume_role_policy = data.aws_iam_policy_document.docker_sts_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    aws_iam_policy.docker_policy.arn
  ]
}

# IAM Policy
resource "aws_iam_policy" "docker_policy" {
  name = "docker_policy_-${random_pet.randy.id}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:MetadataHttpEndpoint",
          "ec2:MetadataHttpPutResponseHopLimit",
          "ec2:MetadataHttpTokens",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Instance Profile
resource "aws_iam_instance_profile" "docker_profile" {
  name = "docker_ec2_profile_-${random_pet.randy.id}"
  role = aws_iam_role.docker_role.name
}


