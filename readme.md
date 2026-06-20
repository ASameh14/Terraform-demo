# Day 1: Terraform Core Foundations & Remote State

**Team:** Sameh, Amr, Mamdouh  
**Date:** June 20, 2026  
**Phase 1 Owner:** Sameh (Backend Architect)

---

## Deliverable 1: Remote Backend Migration Confirmation

- Successfully deployed `vpc.tf` locally with an initial offline state file.
- Manually provisioned an S3 Bucket (with versioning enabled) and a DynamoDB table (`terraform-locks`) with `LockID` as the partition key.
- Configured `backend.tf` and successfully executed `terraform init` to safely migrate the local state file to AWS S3.

## Deliverable 2: Live Drift Test Report

- **Action:** Manually altered the VPC resource tags directly within the AWS Web Console, changing the `Role` tag from `"Foundation"` to `"Backend"`.
- **Observation:** Ran `terraform plan`. Terraform successfully acquired a state lock from DynamoDB, refreshed the state against the cloud API, and flagged the infrastructure drift:
  ```text
  ~ "Role" = "Backend" -> "Foundation"
  Plan: 0 to add, 1 to change, 0 to destroy.
  ```
