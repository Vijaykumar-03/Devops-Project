output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
