# DevOps Project 02 — AWS VPC Architecture

Production-like AWS infrastructure built with Packer and Terraform. Features a multi-VPC network architecture with a Golden AMI pipeline, Auto Scaling, Application Load Balancer, and CloudWatch observability.

## Architecture

```
Internet
    │
    ├─────────────────────────────────────────────┐
    ▼                                             ▼
┌─────────────────────────┐     ┌──────────────────────────────────────┐
│   Bastion VPC           │     │   App VPC (172.32.0.0/16)            │
│   192.168.0.0/16        │     │                                      │
│                         │     │  ┌──────────────┬──────────────┐     │
│   IGW                   │     │  │172.32.1.0/24 │172.32.2.0/24 │     │
│    │                    │     │  │    ALB       │  NAT GW+EIP  │◄─IGW│
│    ▼                    │     │  └──────┬───────┴──────────────┘     │
│  ┌──────────────────┐   │     │         │                            │
│  │ 192.168.1.0/24   │   │     │  ┌──────────────┬──────────────┐     │
│  │  Bastion EC2     │   │     │  │172.32.3.0/24 │172.32.4.0/24 │     │
│  │  bastion_sg      │   │     │  │  App EC2     │  App EC2     │     │
│  └────────┬─────────┘   │     │  │  (ASG)       │  (ASG)       │     │
└───────────┼─────────────┘     │  └──────────────┴──────────────┘     │
            │                   └──────────────────┬────────────────────┘
            └──────────┐                  ┌────────┘
                       ▼                  ▼
                ┌──────────────────────────┐
                │     Transit Gateway      │
                └──────────────────────────┘
```

## Stack

| Tool | Purpose |
|------|---------|
| Packer | Golden AMI build pipeline |
| Terraform | Infrastructure as Code |
| AWS EC2 | Bastion host + App servers |
| AWS ALB | Application Load Balancer |
| AWS ASG | Auto Scaling Group (min 2 / max 4) |
| AWS SSM | Remote access + Parameter Store |
| CloudWatch | Metrics + log aggregation |
| Transit Gateway | Cross-VPC connectivity |

## Terraform Modules

```
terraform/modules/
├── vpc_public/        # Bastion VPC, subnet, IGW, route table
├── vpc_private/       # App VPC, 4 subnets, IGW, NAT GW, route tables
├── security-groups/   # bastion_sg, alb_sg, app_sg
├── transit-gateway/   # TGW + attachments + routes
├── iam/               # EC2 role: SSM + CloudWatch policies
├── bastion/           # Bastion EC2
├── launch-template/   # App EC2 template with Golden AMI + user_data
├── cloudwatch/        # SSM Parameter Store config for CloudWatch Agent
├── alb/               # ALB + target group + HTTP listener
└── asg/               # Auto Scaling Group, attached to ALB
```

## Golden AMI

Ubuntu 22.04 LTS pre-installed with:
- Apache2
- Amazon CloudWatch Agent
- AWS SSM Agent (pre-installed in Ubuntu 22.04)

## Security Design

- App servers in private subnets — no direct internet access
- SSH to app servers only via Bastion (port 22 from `192.168.1.0/24`)
- Bastion isolated in separate VPC — connected via Transit Gateway
- ALB in public subnets — app servers only accept traffic from ALB SG
- IAM least-privilege role on EC2: SSM + CloudWatch only

## Quick Start

**Prerequisites:** AWS credentials, Packer, Terraform

```bash
# 1. Build Golden AMI
packer init packer/
packer build -var-file=packer/golden-ami.pkrvars.hcl packer/

# 2. Update ami_id in terraform/modules/bastion/variables.tf
#    and terraform/modules/launch-template/variables.tf

# 3. Deploy infrastructure
cd terraform/
terraform init
terraform plan
terraform apply
```

## Cost

~$0.05/hour for NAT Gateway when idle. Run `terraform destroy` when not in use.
