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
  ## Phase 2 Owner: Amr (Multi-Tenant Scale & State Resilience)

---

## Deliverable 3: Shared Remote State Collaboration & Resource Isolation
- **Action:** Cloned the shared repository, established connection to the existing live S3 backend via `terraform init`, and created a new file named `vpc_amr.tf`.
- **Implementation:** Isolated infrastructure tracking by giving the resource a unique local HCL name (`resource "aws_vpc" "amr"`) and allocating a separate CIDR block (`10.1.0.0/16`) to avoid state collisions or resource overwriting with Sameh's VPC.
- **Result:** Successfully executed `terraform apply`. Both VPCs now coexist happily under management within the same shared `terraform.tfstate` file.

## Deliverable 4: Concurrent Execution & Concurrency Lock Test
- **Action:** Tested the DynamoDB locking mechanisms under a real-world multi-engineer collision simulation by starting an active `apply` while a teammate simultaneously attempted a write execution.
- **Observation:** The concurrent execution was immediately blocked and safely rejected by DynamoDB. The blocked engineer received the following explicit error message:
  ```text
  Error: Error acquiring the state lock
  Error message: ConditionalCheckFailedException: The conditional request failed
  Lock Info:
    ID:        <UUID-STRING>
    Path:      sameh-amr-mamdouh-project/day1/terraform.tfstate
    Operation: OperationTypeApply
    Who:       amr@desktop
