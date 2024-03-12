module "s3" {
    source = "../../module/s3"

    bucket = var.bucket
    tag_name = var.tag_name
    # destination_bucket = var.destination_bucket
    # storage_class = var.storage_class
    # aws_iam_policy_replication_name = var.aws_iam_policy_replication_name
    # aws_iam_role_rplication_name = var.aws_iam_role_rplication_name
    # bucket_versioning = var.bucket_versioning
    # log_bucket = var.log_bucket
}
