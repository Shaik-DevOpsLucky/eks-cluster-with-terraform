# Private EKS Cluster with Bastion (SSM) – Terraform

This repository provisions a **production-ready, private Amazon EKS cluster** using **Terraform modules**, with:

* ✅ 1 VPC
* ✅ 2 Public subnets (multi-AZ)
* ✅ 2 Private subnets (multi-AZ)
* ✅ Internet Gateway + NAT Gateway
* ✅ Private EKS control plane
* ✅ Managed Node Group (ASG-backed)
* ✅ Public Bastion host (Ubuntu) accessed **only via AWS SSM**

The EKS cluster is **NOT publicly accessible**. All access happens securely **from the bastion host**.

---

## 📁 Directory Structure (IMPORTANT)

```
eks-private-cluster/
│
├── provider.tf          # AWS provider (global entry point)
├── main.tf              # Orchestrates all modules
├── variables.tf         # Global input variables
├── outputs.tf           # Global outputs
│
└── modules/
    ├── vpc/
    │   ├── main.tf      # VPC, subnets, IGW, NAT, route tables
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── iam/
    │   ├── main.tf      # IAM roles for EKS, nodes, bastion
    │   └── outputs.tf
    │
    ├── bastion/
    │   ├── main.tf      # Ubuntu bastion EC2 (SSM only)
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── eks/
        ├── main.tf      # Private EKS cluster + node group
        ├── variables.tf
        └── outputs.tf
```

⚠️ **Terraform is always executed from the ROOT directory** (`eks-private-cluster/`).

---

## 🔧 Prerequisites (Your Local Machine)

Install and configure the following **before running Terraform**:

1. **Terraform** ≥ 1.4
2. **AWS CLI** ≥ v2
3. AWS credentials configured

```bash
aws configure
```

Ensure your IAM user/role has permissions for:

* EC2
* VPC
* EKS
* IAM
* SSM

---

## 🚀 Step 1: Deploy Infrastructure

From the **root directory**:

```bash
cd eks-private-cluster

terraform init
terraform validate
terraform plan
terraform apply
```

Terraform will create:

* VPC & networking
* Bastion host
* Private EKS cluster
* Managed node group

---

## 🔐 Step 2: Connect to the Bastion Host (SSM)

⚠️ **Do NOT SSH** – SSH is intentionally disabled.

From your **local machine**:

```bash
aws ssm start-session --target <BASTION_INSTANCE_ID>
```

You will now have a shell **inside the bastion EC2 instance**.

---

## 🛠️ Step 3: Configure Bastion (ONE-TIME SETUP)

Run the following commands **on the bastion host**.

### 1️⃣ Update OS & Install Tools

```bash
sudo apt update -y
sudo apt install -y curl unzip awscli
```

---

### 2️⃣ Install kubectl

```bash
curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

Verify:

```bash
kubectl version --client
```

---

## ☸️ Step 4: Configure kubeconfig (ON BASTION)

Still **inside the bastion host**, run:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name private-eks-cluster
```

This command:

* Creates `~/.kube/config`
* Uses the **private EKS endpoint**
* Works because the bastion is inside the VPC

---

## ✅ Step 5: Verify Cluster Access

Run the following **on the bastion**:

```bash
kubectl get nodes
kubectl get pods -A
```

Expected result:

* Nodes should be in `Ready` state
* System pods (`kube-system`) should be running

---

## 🔐 Security Model (How Access Works)

```
Your Laptop
   │
   │ aws ssm start-session
   ▼
Bastion EC2 (Public Subnet)
   │
   │ Private VPC routing
   ▼
EKS API Server (Private Endpoint)
```

✔ No public EKS endpoint
✔ No SSH keys
✔ IAM + SSM authentication
✔ Private networking only

---

## 🧠 Key Design Decisions

* **Single NAT Gateway** → cost optimized
* **Private EKS endpoint** → security best practice
* **Managed Node Group** → ASG-backed scaling
* **Ubuntu AMI** → Bastion only
* **EKS-Optimized AMI** → Worker nodes (mandatory)

---

## 🧪 Common Commands (Run on Bastion)

```bash
kubectl get ns
kubectl get svc -A
kubectl get deployments -A
```

---

## ❗ Common Mistakes to Avoid

❌ Running `kubectl` from local machine
❌ Trying to SSH into bastion
❌ Using Ubuntu AMI for EKS nodes
❌ Running Terraform inside modules directory

---

## 📌 Summary

* Terraform runs **only from root directory**
* Bastion is accessed **via SSM**
* EKS is accessed **from bastion only**
* This setup follows **AWS + Kubernetes best practices**

---

## 🚀 Next Improvements (Optional)

* IRSA (IAM Roles for Service Accounts)
* ALB Ingress Controller
* Cluster Autoscaler
* GitOps (ArgoCD)
* Terraform remote backend (S3 + DynamoDB)

---

✅ You now have a **secure, private, production-grade EKS setup**

Preparedby:
Shaik.Moulali
Cloud and DevOps Consultant