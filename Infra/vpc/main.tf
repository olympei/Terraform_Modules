module "vpc"{
    source = "./module/vpc"
    cidr = var.cidr
    tag = var.tag

}

