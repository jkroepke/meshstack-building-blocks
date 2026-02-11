variable "backplane_management_account_id" {
  type        = string
  nullable    = false
  description = "The AWS account ID of the management account where the crossplane role is located."
}
