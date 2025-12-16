variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "user_data" {
  type = string
}

variable "target_group_arns" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

resource "aws_launch_template" "app" {
  name_prefix   = "holiday-shop-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_groups
  }

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "HolidayShoppingAppNode"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = var.subnets
  target_group_arns   = var.target_group_arns

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}
