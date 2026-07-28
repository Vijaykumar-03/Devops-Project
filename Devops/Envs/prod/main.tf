module "network" {

  source = "../../modules/network"

  project_name = var.project_name

  region = var.aws_region

  vpc_cidr = var.vpc_cidr

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

}
module "ecs" {

  source = "../../modules/ecs"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  public_subnet_1_id = module.network.public_subnet_1_id
  public_subnet_2_id = module.network.public_subnet_2_id

  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id

  container_image = "nginx:latest"

  container_port = 80

  cpu = 512

  memory = 1024

  desired_count = 2

}
module "rds" {

  source = "../../modules/rds"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id

  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_name = "hoteldb"

  db_username = "postgres"

  db_password = var.db_password

  db_instance_class = "db.t3.medium"

  allocated_storage = 50

  backup_retention_period = 30

  deletion_protection = true

}
