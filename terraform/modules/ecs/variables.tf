variable "environment" {}
variable "aws_region" {}
variable "private_subnet_ids" { type = list(string) }
variable "ecs_tasks_sg_id" {}
variable "target_group_arn" {}
variable "ecs_execution_role_arn" {}
variable "ecs_task_role_arn" {}
variable "container_image" {
  description = "Docker image to deploy"
}
variable "container_port" {}
variable "cpu" {
  default = "256"
}
variable "memory" {
  default = "512"
}
variable "desired_count" {
  default = 2
}
