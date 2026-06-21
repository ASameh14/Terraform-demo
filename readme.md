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


## Phase 3 Owner: Mamdouh (State Surgery & State Inspection)

## Deliverable 5: Third VPC Deployment & Dependency Graph Analysis

**Action:** Cloned the shared repository, initialized Terraform against the existing remote S3 backend, and created vpc_mamdouh.tf containing a new VPC resource with CIDR block 10.2.0.0/16 and tags identifying ownership.

**Result:** Successfully executed terraform apply. The shared remote state now tracked three independent VPC resources managed by different team members.

## Graph Analysis:
Executed terraform graph to inspect Terraform's dependency graph. The output displayed all VPC resources as separate nodes with no dependency arrows between them. This indicates that Terraform recognizes each VPC as an independent resource with no references or relationships to the others. Since VPC resources do not depend on one another, Terraform can create, update, or destroy them independently.

## Deliverable 6: State Move (state mv) Resource Rename Test

**Action:** Renamed the local Terraform resource name for the VPC in the configuration file and executed terraform state mv to update the resource address stored in the state file.

## Example:
terraform state mv aws_vpc.mamdouh aws_vpc.primary

**Observation:** The state entry was successfully updated without modifying the actual AWS VPC. A subsequent terraform plan reported no infrastructure changes, confirming that Terraform correctly understood the resource had only been renamed within the configuration.

## Result:
Plan: 0 to add, 0 to change, 0 to destroy.

## Deliverable 7: State Removal (state rm) Test

**Action:** Executed terraform state rm against the VPC resource.

**Observation:** Terraform removed the resource from the state file while leaving the VPC fully intact within AWS. Verification through the AWS Console confirmed that the VPC continued to exist and operate normally.

## Cleanup Decision:
The VPC was re-imported into Terraform state using terraform import to avoid leaving unmanaged infrastructure and to maintain consistency within the shared project state.

**Deliverable 8:** Raw State Inspection (state pull)

**Action:** Executed terraform state pull to retrieve the raw JSON state directly from the remote S3 backend and reviewed its contents.

## Observation:
The state file contained detailed metadata for each tracked VPC, including:

* Resource address and type
* AWS VPC ID
* ARN (Amazon Resource Name)
* CIDR block
* Tags
* Owner information
* Provider metadata
* Terraform schema version
* Resource instance attributes

## Conclusion:
The exercise demonstrated how Terraform state can be safely manipulated without affecting live infrastructure, how resource addresses can be updated using state mv, how resources can be detached from management using state rm, and how the complete infrastructure record can be inspected directly through state pull.
