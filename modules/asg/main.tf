resource "aws_launch_template" "this" {
  instance_type = var.instance_type
  image_id      = var.image_id
  vpc_security_group_ids = var.security_group_ids
  key_name = var.key_name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  # user_data...
}

resource "aws_autoscaling_group" "this" {
  name                      = "my-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_type         = "EC2" ########
  health_check_grace_period = 300
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "my-asg-instance"
    propagate_at_launch = true
  }
  tag {
    key = "InstanceGroup"
    value = "my-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  lb_target_group_arn    = var.lb_target_group_arn
}