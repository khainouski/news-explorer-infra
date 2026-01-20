locals {
  name        = "${var.project_name}-${var.environment}"
  common_tags = [var.project_name, "env:${var.environment}"]
}
