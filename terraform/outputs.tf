output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  # Value will be populated once ALB module is added
  value = "Check back after Phase 2 - Step: Load Balancing"
}
