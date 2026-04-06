# Cloud-Agnostic FinOps: A Practical Guide

*Published: April 2026*

## Introduction

Multi-cloud is the new normal. According to recent surveys, 76% of enterprises use multiple cloud providers. But managing costs across AWS, Azure, GCP, and OCI remains a significant challenge.

This guide provides a practical approach to building a cloud-agnostic FinOps practice.

## Table of Contents

1. [The Multi-Cloud Challenge](#the-multi-cloud-challenge)
2. [FOCUS: The Universal Language](#focus-the-universal-language)
3. [Building a Cloud-Agnostic Stack](#building-a-cloud-agnostic-stack)
4. [Implementation Strategy](#implementation-strategy)
5. [Tools for Each Cloud](#tools-for-each-cloud)

---

## The Multi-Cloud Challenge

### The Complexity Matrix

| Cloud | Compute | Storage | Database | Networking |
|-------|---------|---------|----------|------------|
| AWS | EC2, ECS, EKS, Lambda | S3, EBS, EFS | RDS, DynamoDB | VPC, ELB |
| Azure | VM, AKS, Functions | Blob, Disk, Files | SQL, CosmosDB | VNet, LB |
| GCP | GCE, GKE, Cloud Run | Cloud Storage | Cloud SQL, Firestore | VPC |
| OCI | Compute, OKE, Functions | Object Storage | Autonomous | VCN |

### Why Cloud-Agnostic Matters

1. **Avoid Lock-in**: Don't be tied to one vendor's tools
2. **Best-of-Breed**: Use the best tool for each job
3. **Negotiate Power**: Multi-cloud gives you leverage
4. **Resilience**: Don't depend on single provider
5. **Cost Optimization**: Compare across clouds

---

## FOCUS: The Universal Language

The **FinOps Open Cost and Usage Specification (FOCUS)** provides a standardized format for cloud billing data.

### Why FOCUS?

```
Before FOCUS:
┌─────────┐  ┌─────────┐  ┌─────────┐
│ AWS CUR │  │Azure Exp│  │GCP BQ   │
└────┬────┘  └────┬────┘  └────┬────┘
     │           │           │
     ▼           ▼           ▼
  Different    Different   Different
   Schemas     Schemas     Schemas
     │           │           │
     └───────────┴───────────┘
              ↓
        Impossible to compare

After FOCUS:
┌─────────┐  ┌─────────┐  ┌─────────┐
│ AWS CUR │  │Azure Exp│  │GCP BQ   │
└────┬────┘  └────┬────┘  └────┬────┘
     │           │           │
     └───────────┴───────────┘
              ↓
     ┌────────────────┐
     │   FOCUS Spec   │
     └────────────────┘
              ↓
     Unified Analytics
```

### FOCUS Schema Overview

```yaml
FOCUS Standard Fields:
├── billingPeriod: Date range
├── provider: Cloud provider
├── accountId: Account/subscription/project
├── service: Service name (normalized)
├── region: Geographic region
├── resourceId: Specific resource
├── usageType: Usage category
├── usageAmount: Quantity used
├── unitPrice: Price per unit
├── cost: Total cost
└── tags: Resource tags
```

---

## Building a Cloud-Agnostic Stack

### The Universal Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              Cloud-Agnostic FinOps Architecture             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Cloud Providers                      │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  │   │
│  │  │   AWS   │  │  Azure  │  │   GCP   │  │   OCI   │  │   │
│  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘  │   │
│  └───────┼───────────┼───────────┼───────────┼───────────┘   │
│          │           │           │           │                 │
│  ┌───────▼───────────▼───────────▼───────────▼───────────┐   │
│  │                   Connectors Layer                      │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  │   │
│  │  │AWS Native│  │Azure CUR│  │GCP Export│  │OCI API  │  │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘  │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │              Normalization Engine (FOCUS)                 │   │
│  │  ┌─────────────────────────────────────────────────────┐ │   │
│  │  │ - Schema transformation                             │ │   │
│  │  │ - Currency conversion                               │ │   │
│  │  │ - Service name mapping                              │ │   │
│  │  │ - Unit standardization                              │ │   │
│  │  └─────────────────────────────────────────────────────┘ │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │                    Analytics Engine                       │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐   │   │
│  │  │ Cost    │  │ Anomaly │  │ Rightsiz│  │Forecast │   │   │
│  │  │ Allocat │  │ Detect  │  │ Engine  │  │         │   │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘   │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │                   Unified Dashboard                       │   │
│  │  ┌──────────────────────────────────────────────────┐  │   │
│  │  │ - Multi-cloud cost view                            │  │   │
│  │  │ - Cross-cloud comparison                          │  │   │
│  │  │ - Unified reporting                               │  │   │
│  │  └──────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Recommended Tool Stack

| Layer | Open Source | Paid |
|-------|-------------|------|
| **Connectors** | Custom scripts | CloudHealth, CloudZero |
| **Normalization** | Open source FOCUS tools | CloudLens (custom) |
| **Analytics** | Grafana + InfluxDB | Looker, Tableau |
| **Visualization** | Grafana | Power BI, Sigma |
| **Automation** | Cloud Custodian | Spot.io, Turbot |

---

## Implementation Strategy

### Phase 1: Data Collection (Weeks 1-2)

```bash
# AWS: Cost Explorer API
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-04-01 \
  --granularity MONTHLY \
  --metrics BlendedCost,UnblendedCost

# Azure: Cost Management API
az costmanagement query \
  --type ActualCost \
  --time-period-type MonthToDate

# GCP: BigQuery Billing Export
bq query --use_legacy_sql=false \
  "SELECT * FROM billing.gcp_billing_export_v1_*"
```

### Phase 2: Normalization (Weeks 3-4)

```python
# normalize.py - FOCUS Normalization
class FOCUSNormalizer:
    def normalize(self, data, provider):
        if provider == 'aws':
            return self.normalize_aws(data)
        elif provider == 'azure':
            return self.normalize_azure(data)
        elif provider == 'gcp':
            return self.normalize_gcp(data)
        
        # Return standardized FOCUS format
        return {
            'billingPeriod': ...,
            'provider': provider,
            'service': ...,
            'region': ...,
            'cost': ...,
            'usageAmount': ...,
            'tags': ...
        }
```

### Phase 3: Analytics (Weeks 5-6)

```sql
-- Cross-cloud service comparison
SELECT 
    provider,
    service,
    SUM(cost) as total_cost,
    SUM(usage_amount) as total_usage,
    AVG(unit_price) as avg_price
FROM focus_cost_data
WHERE billing_period = '2026-03'
GROUP BY provider, service
ORDER BY total_cost DESC
```

### Phase 4: Visualization (Weeks 7-8)

```yaml
# Grafana Dashboard
apiVersion: 1
providers:
  - name: 'FinOps'
    folder: 'Cloud Costs'
    type: file
    options:
      path: /var/lib/grafana/dashboards
```

---

## Tools for Each Cloud

### AWS Native Tools

| Tool | Purpose | Cost |
|------|---------|------|
| Cost Explorer | Basic cost visibility | Free |
| Budgets | Alert on spend | Free (2 free, then $0.10/day) |
| Cost Anomaly Detection | ML-based alerts | Free |
| Savings Plans | Commitment discounts | Varies |

### Azure Native Tools

| Tool | Purpose | Cost |
|------|---------|------|
| Cost Analysis | Cost visualization | Free |
| Budgets | Alert on spend | Free |
| Advisor | Optimization recommendations | Free |

### GCP Native Tools

| Tool | Purpose | Cost |
|------|---------|------|
| Billing Export | Raw billing data | Free |
| Cost Table | Cost breakdown | Free |
| Recommender | Optimization tips | Free |

### Third-Party Multi-Cloud Tools

| Tool | Strengths | Starting Price |
|------|-----------|----------------|
| CloudHealth | Enterprise, commitment mgmt | $45K/year |
| CloudZero | Engineering focus, unit economics | $19/1K AWS |
| Cloudaware | CMDB integration | $400/month |
| Flexera | ITAM + FinOps | Custom |
| CloudLens | FOCUS-native, real-time | $299/month |

---

## Best Practices

### 1. Standardize Your Tags

```yaml
Required Tags (all clouds):
├── Environment: production, staging, development
├── Owner: email or team
├── Application: application name
├── CostCenter: department code
└── Compliance: SOC2, HIPAA, etc.
```

### 2. Use FOCUS for Analytics

```sql
-- Example FOCUS query
SELECT 
    provider,
    SUM(cost) as total_cost,
    COUNT(DISTINCT account_id) as accounts
FROM focus_data
WHERE billing_period >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY provider
ORDER BY total_cost DESC
```

### 3. Set Cross-Cloud Budgets

```yaml
# Example: 10% budget increase limit
cross_cloud_budget:
  total_monthly: $500,000
  variance_threshold: 10%
  alert_channels:
    - slack: "#finops-alerts"
    - email: finops-team@company.com
```

### 4. Compare Across Clouds

```
Monthly Comparison:
┌─────────┬────────────┬────────────┬────────────┐
│ Service │    AWS     │   Azure   │    GCP     │
├─────────┼────────────┼────────────┼────────────┤
│ Compute │  $45,000   │  $42,000  │  $38,000   │
│ Storage │  $12,000   │  $15,000  │  $10,000   │
│ Network │   $8,000   │   $7,500  │   $6,000   │
├─────────┼────────────┼────────────┼────────────┤
│ TOTAL   │  $65,000   │  $64,500  │  $54,000   │
└─────────┴────────────┴────────────┴────────────┘
Insight: GCP 17% cheaper for comparable workloads
```

---

## Conclusion

Cloud-agnostic FinOps isn't just about using multiple clouds—it's about having a **unified view and strategy** across all of them.

Key takeaways:
1. ✅ Use FOCUS as your common data format
2. ✅ Build connectors for each cloud provider
3. ✅ Normalize data before analysis
4. ✅ Create unified dashboards and reports
5. ✅ Compare costs across clouds regularly
6. ✅ Optimize based on data, not assumptions

The future of FinOps is **cloud-agnostic by design**.

---

*For the complete POC framework, see [../poc/README.md](../poc/README.md)*
