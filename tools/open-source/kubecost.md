# Kubecost: Kubernetes Cost Visibility at Scale

![Kubecost](https://img.shields.io/github/stars/kubecost/cost-model?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache--2.0-green?style=for-the-badge)
![CNCF](https://img.shields.io/badge/CNCF-Sandbox-blue?style=for-the-badge)

> **"Stop overpaying for Kubernetes"**

## Overview

Kubecost provides **real-time cost visibility and allocation for Kubernetes clusters**. Originally developed by Azure, now part of IBM, it helps organizations understand exactly how much each namespace, deployment, and pod costs to run.

### Key Statistics
- **GitHub Stars**: 8,500+
- **Organizations Using**: 10,000+
- **Cloud Providers**: AWS, Azure, GCP, On-prem
- **Deployment Options**: Self-hosted, SaaS, Embedded

## Core Features

### 1. Real-Time Cost Allocation
```
┌─────────────────────────────────────────────────────────────┐
│  Cluster Cost Summary                                        │
├─────────────────────────────────────────────────────────────┤
│  Total Cost: $124,532/month                                  │
│  ├── Compute: $98,400 (79%)                                 │
│  ├── Storage: $18,200 (14.6%)                               │
│  └── Network: $7,932 (6.4%)                                 │
├─────────────────────────────────────────────────────────────┤
│  Top 5 Cost Drivers:                                        │
│  1. production-api (namespace): $32,450                    │
│  2. data-processing (namespace): $28,100                   │
│  3. ml-training (namespace): $21,800                        │
│  4. monitoring (namespace): $15,200                         │
│  5. default (namespace): $8,900                             │
└─────────────────────────────────────────────────────────────┘
```

### 2. Namespace & Pod Level Allocation
- CPU, memory, storage, network breakdown
- Idle resource allocation
- Shared cost distribution

### 3. Efficiency Metrics
```yaml
Cost Efficiency Score: 68%
├── Request vs. Usage Efficiency: 45%
├── Right-sizing Opportunities: 23%
└── Unused Resources: 12%
```

### 4. Savings Recommendations
```json
{
  "recommendations": [
    {
      "type": "rightsize",
      "namespace": "api-server",
      "current": "4 CPU, 8Gi",
      "recommended": "2 CPU, 4Gi",
      "savings": "$180/month"
    }
  ]
}
```

### 5. Unified Dashboard
- Cluster overview
- Namespace costs
- Deployment costs
- Resource costs
- Savings projections

## Pricing Model

| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | Self-hosted, basic features |
| Cloud | Custom | SaaS, SLA, Support |
| Enterprise | Custom | On-prem, SSO, Audit |

## Pros and Cons

### ✅ Pros

| Advantage | Description | Impact |
|-----------|-------------|--------|
| **K8s Native** | Built for Kubernetes | Deep visibility |
| **Real-Time** | Minute-level granularity | Fast detection |
| **Multi-Cluster** | Federated views | Enterprise scale |
| **Accurate** | Actual cloud pricing | Trustworthy data |
| **Savings Plans** | RIs & SPs tracking | Optimization |
| **Alerts** | Anomaly notifications | Proactive |
| **Integrations** | Prometheus, Grafana | Flexible |
| **Open Source** | Self-hostable | No lock-in |

### ❌ Cons

| Limitation | Description | Workaround |
|------------|-------------|------------|
| **K8s Only** | No VMs or serverless | Use Komiser |
| **Complex Setup** | Requires Prometheus | Managed option |
| **No Remediation** | Visibility only | Cloud Custodian |
| **Storage Costs** | Additional storage needed | Minimal |
| **Learning Curve** | K8s concepts required | Training |

## Use Cases

### 1. Platform Teams - Chargeback
```
Before: Shared cluster, no accountability
After:  Per-namespace cost, team ownership
```

### 2. Dev Teams - Optimization
```
Before: Request everything, waste resources
After:  Right-sized pods, efficient usage
```

### 3. Finance Teams - Budgeting
```
Before: Cluster-level budgets
After:  Namespace-level budgets with alerts
```

## Installation

### Helm Chart (Recommended)
```bash
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm install kubecost kubecost/cost-analyzer -n kubecost --create-namespace
```

### kubectl
```bash
kubectl apply -f https://raw.githubusercontent.com/kubecost/cost-analyzer-helm-chart/develop/cost-analyzer.yaml
```

### Kubefed (Multi-Cluster)
```bash
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm install kubecost-federated kubecost/cost-analyzer \
  --set kubecostToken="your-token" \
  --set kubecostModel.federatedStorageConfig=true
```

## Quick Start

### 1. Access Dashboard
```bash
kubectl port-forward -n kubecost deployment/kubecost-cost-analyzer 9090
# Open http://localhost:9090
```

### 2. View Costs
```bash
# Get namespace costs
kubectl get cost -n kubecost

# Export CSV
kubecost status --csv > costs.csv
```

### 3. Configure Alerts
```yaml
apiVersion: kubecost.com/v1
kind: Alert
metadata:
  name: namespace-budget
spec:
  threshold: 10000
  type: budget
  window: 1d
  notifications:
    - slack
```

## Advanced Configuration

### Cloud Provider Integration
```yaml
# AWS EKS
kubecostModel:
  aws.region: us-east-1
  aws.amazonWebServicesName: true

# Azure AKS
kubecostModel:
  azure.subscriptionId: your-subscription
  azure.account: your-account

# GCP GKE
kubecostModel:
  gcp.projectId: your-project
```

### ETL Pipeline
```yaml
kubecostModel:
  etl:
    bucket: gs://kubecost-etl
    config: /opt/cost-model/etlBuckets.json
```

## ROI Analysis

### Typical Savings
```
Before Kubecost:
- 60% efficiency (40% waste)
- $100K/month cluster cost
- $40K/month wasted

After Kubecost:
- 85% efficiency (15% waste)
- $100K/month cluster cost
- $15K/month wasted

Monthly savings: $25,000
Annual savings: $300,000
```

### Time to Value
- **Setup**: 1-2 hours
- **First insights**: Immediate
- **Optimization**: 2-4 weeks

## Alternatives

| Tool | Cost | Pros | Cons |
|------|------|------|------|
| OpenCost | Free | CNCF standard | Less mature |
| CloudHealth | $45K+ | Enterprise | K8s support limited |
| Datadog | Custom | Observability | Expensive |

## Best Practices

1. **Start with Namespace Tagging**: Essential for allocation
2. **Set Budget Alerts**: Proactive notifications
3. **Review Weekly**: Regular optimization cadence
4. **Combine with Infracost**: For new deployments
5. **Use Labels Wisely**: Enable fine-grained allocation

## Conclusion

Kubecost is the **essential tool for Kubernetes cost visibility**. While it doesn't provide automation, its accurate cost allocation and savings recommendations make it invaluable for any organization running containers at scale.

**Rating**: ⭐⭐⭐⭐⭐ (5/5)
**Best For**: K8s teams, Platform engineers, SREs
**Must-Have Add-on**: Cloud Custodian (for automation)
