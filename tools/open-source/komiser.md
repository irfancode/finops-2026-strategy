# Komiser: Discovering Hidden Cloud Waste

![Komiser](https://img.shields.io/github/stars/tailwarden/komiser?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache--2.0-green?style=for-the-badge)
![Go](https://img.shields.io/badge/Language-Go-blue?style=for-the-badge)

> **"Find and eliminate cloud waste before it finds your budget"**

## Overview

Komiser is an **open-source cloud resource inventory and waste discovery tool**. It scans your cloud accounts across multiple providers to build a complete inventory of resources and identify unused or misconfigured resources that are costing you money.

### Key Statistics
- **GitHub Stars**: 4,800+
- **Cloud Providers**: AWS, Azure, GCP, OCI, Kubernetes
- **Contributors**: 150+
- **Downloads**: 100,000+

## Core Features

### 1. Multi-Cloud Inventory
```
┌─────────────────────────────────────────────────────────────┐
│  Cloud Resources Dashboard                                  │
├─────────────────────────────────────────────────────────────┤
│  Total Resources: 2,847                                     │
│  ├── AWS: 1,523 (53%)                                       │
│  ├── Azure: 892 (31%)                                       │
│  └── GCP: 432 (15%)                                        │
├─────────────────────────────────────────────────────────────┤
│  Potential Savings: $45,230/month                            │
│  ├── Idle Resources: $28,500                                │
│  ├── Unused Storage: $12,300                                │
│  └── Overprovisioned: $4,430                                │
└─────────────────────────────────────────────────────────────┘
```

### 2. Waste Detection
```yaml
Waste Categories:
├── 💤 Idle Resources
│   ├── Stopped instances (billed but unused)
│   ├── Unattached volumes
│   └── Idle load balancers
├── 📦 Unused Storage
│   ├── Empty S3 buckets
│   ├── Old snapshots
│   └── Orphaned backups
└── ⚡ Overprovisioned
    ├── Oversized instances
    └── Overallocated databases
```

### 3. Cost Analysis
```json
{
  "costs": {
    "total": 45230,
    "byProvider": {
      "aws": 28500,
      "azure": 12300,
      "gcp": 4430
    },
    "byService": {
      "EC2": 18500,
      "RDS": 8200,
      "S3": 6500,
      "EKS": 5000
    }
  },
  "recommendations": [
    {
      "type": "delete",
      "resource": "unused-volume-001",
      "savings": 150,
      "confidence": "high"
    }
  ]
}
```

### 4. Resource Relationships
```yaml
Dependencies:
instance-001
├── sg-001 (Security Group)
├── subnet-001 (Subnet)
├── ebs-vol-001 (Root Volume)
└── ebs-vol-002 (Data Volume)
```

### 5. Alert System
```yaml
alerts:
  - name: high-cost-threshold
    threshold: 10000
    period: daily
    action: slack
  - name: new-resource
    event: create
    channels:
      - finance
      - security
```

## Pricing Model

| Tier | Price | Features |
|------|-------|----------|
| Open Source | Free | Self-hosted |
| Cloud | Free tier | Up to 50K resources |
| Pro | $49/month | 500K resources |
| Enterprise | Custom | Unlimited, SSO |

## Pros and Cons

### ✅ Pros

| Advantage | Description | Impact |
|-----------|-------------|--------|
| **Simple Setup** | Quick to deploy | Fast time-to-value |
| **Multi-Cloud** | One view for all | Simplified |
| **Waste Detection** | Automatic discovery | Cost savings |
| **Resource Map** | Dependency view | Impact analysis |
| **Open Source** | Full transparency | No lock-in |
| **Dashboard** | Visual interface | Easy to use |
| **Free Tier** | Cloud option free | Accessible |
| **Alerting** | Proactive notifications | Continuous |

### ❌ Cons

| Limitation | Description | Workaround |
|------------|-------------|------------|
| **No Automation** | Discovery only | Cloud Custodian |
| **Limited Analytics** | Basic reporting | Additional tools |
| **Cost Estimation** | Approximate | Cloud pricing APIs |
| **Large Scale** | Performance at scale | Multiple accounts |
| **No Remediation** | No auto-fix | Manual or scripts |

## Use Cases

### 1. Monthly Waste Review
```
Before: Manual discovery, spreadsheets
After:  Automated scan, dashboard
Time saved: 4-6 hours/month
```

### 2. Post-Migration Cleanup
```
Before: Resources left behind
After:  Complete inventory, cleanup plan
Savings: Often 20-30% of post-migration cost
```

### 3. Security Posture
```
Before: Unknown resource inventory
After:  Complete view, untagged resources flagged
Risk reduction: Significant
```

## Installation

### Docker (Recommended)
```bash
docker run -d \
  -p 3000:3000 \
  -v ~/.komiser:/root/.komiser \
  tailwarden/komiser:latest
```

### Docker Compose
```yaml
version: '3'
services:
  komiser:
    image: tailwarden/komiser:latest
    ports:
      - "3000:3000"
    volumes:
      - ./config.toml:/root/.komiser/config.toml
    environment:
      - KOMISER_PORT=3000
      - KOMISER_DATABASE=sqlite
```

### Kubernetes
```bash
helm repo add komiser https://chart.komiser.io
helm install komiser komiser/komiser -n komiser --create-namespace
```

### Build from Source
```bash
git clone https://github.com/tailwarden/komiser.git
cd komiser
go build -o komiser
./komiser start
```

## Quick Start

### 1. Start Server
```bash
docker run -p 3000:3000 tailwarden/komiser:latest
```

### 2. Open Dashboard
```
http://localhost:3000
```

### 3. Add Cloud Account
```
Dashboard → Add Account → Select Provider → Configure
```

### 4. View Waste
```
Dashboard → Waste → See Recommendations
```

## Configuration

### config.toml
```toml
[aws]
  [[aws.account]]
    id = "123456789"
    name = "production"
    region = "us-east-1"
    credentials = "~/.aws/credentials"

[azure]
  enabled = true

[gcp]
  enabled = true
```

### Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export KOMISER_PORT=3000
export KOMISER_DATABASE=postgres
```

## ROI Analysis

### Typical Findings
```
Inventory Size: 1,000 resources
Typical Waste Found: 15-25% of spend

Example Monthly Cloud Spend: $100,000
Typical Waste: $15,000-$25,000
Cleanup Effort: 2-4 hours
ROI: 1000%+ on first run
```

### Real World Example
```
Company: Mid-size SaaS
Resources: 500
Monthly Waste Found: $18,000
Annual Savings: $216,000
Implementation Time: 30 minutes
```

## Best Practices

1. **Weekly Scans**: Regular inventory updates
2. **Tag Everything**: Enable ownership tracking
3. **Set Budgets**: Alert before overspending
4. **Document Policies**: Cleanup standards
5. **Combine with Automation**: Cloud Custodian for fixes

## Conclusion

Komiser is the **perfect starting point for FinOps**. Its simple setup, multi-cloud support, and waste discovery capabilities make it ideal for organizations beginning their cloud optimization journey. While it doesn't automate fixes, its clear visualization of waste provides the foundation for cost optimization.

**Rating**: ⭐⭐⭐⭐ (4/5)
**Best For**: Beginners, Quick wins, Multi-cloud
**Must-Have Add-on**: Cloud Custodian (automation)
