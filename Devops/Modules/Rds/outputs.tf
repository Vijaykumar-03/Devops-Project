output "rds_endpoint" {

  value = aws_db_instance.postgres.endpoint

}

output "rds_port" {

  value = aws_db_instance.postgres.port

}

output "rds_security_group_id" {

  value = aws_security_group.rds.id

}

output "db_subnet_group_name" {

  value = aws_db_subnet_group.main.name

}
