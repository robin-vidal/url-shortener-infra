resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title  = "ALB - Request Count"
          region = "us-east-1"
          metrics = [["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]]
          period = 60
          stat   = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "ALB - 5XX Errors"
          region = "us-east-1"
          metrics = [["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix]]
          period = 60
          stat   = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "ALB - Target Response Time"
          region = "us-east-1"
          metrics = [["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix]]
          period = 60
          stat   = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "EC2 Backend - CPU"
          region = "us-east-1"
          metrics = [["AWS/EC2", "CPUUtilization", "InstanceId", var.backend_instance_id]]
          period = 60
          stat   = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "EC2 Frontend - CPU"
          region = "us-east-1"
          metrics = [["AWS/EC2", "CPUUtilization", "InstanceId", var.frontend_instance_id]]
          period = 60
          stat   = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "RDS - CPU"
          region = "us-east-1"
          metrics = [["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_identifier]]
          period = 60
          stat   = "Average"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB 5XX errors exceed 10 in 1 minute"
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "backend_cpu" {
  alarm_name          = "${var.project}-backend-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Backend CPU > 80%"
  dimensions = {
    InstanceId = var.backend_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project}-rds-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU > 80%"
  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}
