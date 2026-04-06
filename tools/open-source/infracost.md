# Infracost: Shift-Left FinOps for Modern Teams

![Infracost](https://img.shields.io/github/stars/infracost/infracost?style=for-the-badge)
![Go](https://img.shields.io/badge/Language-Go-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache--2.0-green?style=for-the-badge)

> **"Cloud cost estimates in your pull requests"**

## Overview

Infracost is the leading open-source infrastructure-as-code cost estimation tool. It provides **cloud cost estimates for Terraform before deployment**, enabling developers to understand the financial impact of their infrastructure changes.

### Key Statistics
- **GitHub Stars**: 12,200+
- **GitHub Forks**: 664
- **Primary Language**: Go (97.4%)
- **Weekly Downloads**: 50,000+
- **Contributors**: 200+

## Core Features

### 1. Cost Estimation in Pull Requests
```
Comment on PR:
💰 **Cost Change**: +$245.50/month
├── terraform plan output
│   ├── +aws_instance.web_server: $180/month
│   ├── +aws_rds.cluster: $450/month
│   └── -aws_instance.old_server: -$384.50/month
```

### 2. Multi-Cloud Support
| Cloud Provider | Services Covered | Pricing Updates |
|----------------|------------------|-----------------|
| AWS | 280+ resources | Hourly |
| Azure | 200+ resources | Daily |
| GCP | 180+ resources | Daily |
| Kubernetes | EKS, AKS, GKE | Real-time |

### 3. CI/CD Integration
```yaml
# GitHub Actions Example
- name: Run Infracost
  uses: infracost/infracost-action@v2
  with:
    api_key: ${{ secrets.INFRACOST_API_KEY }}
```

### 4. Terragrunt Support
Native Terragrunt integration for monorepo architectures.

### 5. Breakdown & Diff Reports
- **Price list view**: Full resource cost breakdown
- **Diff view**: Before/after comparison
- **HTML reports**: Visual cost analysis

## Pricing Model

| Tier | Price | Features |
|------|-------|----------|
| Community | Free | CLI, open-source |
| Plus | $50/month | 5 repos, 3 users |
| Pro | $300/month | Unlimited repos, 10 users |
| Enterprise | Custom | SSO, SLA, Dedicated support |

## Pros and Cons

### ✅ Pros

| Advantage | Description | Impact |
|-----------|-------------|--------|
| **Shift-Left FinOps** | Cost visibility before deployment | Prevents cost surprises |
| **Developer Experience** | Familiar workflow (git PRs) | High adoption rate |
| **Accurate Estimates** | Real-time pricing data | Trust in estimates |
| **CI/CD Native** | GitHub, GitLab, Bitbucket | Automation ready |
| **Open Source** | Full transparency | No vendor lock-in |
| **Multi-Cloud** | AWS, Azure, GCP | Single tool |
| **Terragrunt** | Monorepo support | Enterprise ready |

### ❌ Cons

| Limitation | Description | Workaround |
|------------|-------------|------------|
| **IaC Only** | Requires Terraform/Terragrunt | Use with Komiser for running resources |
| **Estimate vs Actual** | Estimates can differ from bills | Use with Cloud Custodian |
| **No Auto-Fix** | Only shows costs, doesn't remediate | Manual or Cloud Custodian |
| **Learning Curve** | Requires IaC knowledge | Training investment |
| **Rate API Limits** | Cloud provider API limits | Caching enabled |

## Use Cases

### 1. Development Team - Pre-Deployment Cost Review
```
Before: Developer creates infrastructure → Cost discovered at billing
After:  Developer sees cost in PR → Informed decision made
```

### 2. Platform Team - Budget Enforcement
```
Before: Team overspends → Surprise billing
After:  Budget limits enforced → Controlled spend
```

### 3. Finance Team - Cost Visibility
```
Before: Monthly bill analysis → Reactive
After:  Real-time estimates → Proactive governance
```

## Installation

### macOS
```bash
brew install infracost
```

### Linux
```bash
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
```

### Docker
```bash
docker pull infracost/infracost:latest
docker run --rm -it infracost/infracost [command]
```

## Quick Start

### 1. Initialize
```bash
infracost auth login
infracost configure set api_key your-api-key
```

### 2. Create Cost Estimate
```bash
cd your-terraform-project
infracost breakdown --path .
```

### 3. Compare Costs
```bash
infracost diff --path . --compare-to previous-plan.json
```

### 4. Generate HTML Report
```bash
infracost output --format html --path . > cost-report.html
```

## CI/CD Integration Examples

### GitHub Actions
```yaml
name: Infracost
on: [pull_request]
jobs:
  infracost:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: infracost/infracost-action@v2
        with:
          api_key: ${{ secrets.INFRACOST_API_KEY }}
```

### GitLab CI
```yaml
infracost:
  image: infracost/infracost:latest
  script:
    - infracost breakdown --path .
    - infracost comment gitlab --path . --repo-token $CI_MERGE_REQUEST_TOKEN
```

### Azure DevOps
```yaml
- task: Infracost@0
  inputs:
    apiKey: $(INFRACOST_API_KEY)
    terraformPlanFile: plan.json
```

## Alternatives Considered

| Tool | Cost | Focus | Infracost Advantage |
|------|------|-------|---------------------|
| Terraform Cloud | $20/user | State management | Free, CLI-first |
| AWS Calculator | Free | Single-cloud | Multi-cloud |
| Azure Calculator | Free | Single-cloud | CI/CD integration |

## ROI Analysis

### Time to Value
- **Setup**: 15 minutes
- **First estimate**: Immediate
- **ROI**: Immediate (prevents overspending)

### Cost Savings Example
```
Scenario: 10 developers
Each creates 2 infrastructure PRs/week
Average cost of unexpected resources: $500
Prevention rate with Infracost: 80%

Annual savings: 10 × 2 × 52 × $500 × 0.8 = $416,000
```

## Community & Support

- **GitHub**: [infracost/infracost](https://github.com/infracost/infracost)
- **Documentation**: [infracost.io/docs](https://www.infracost.io/docs/)
- **Slack**: 3,000+ members
- **Discussions**: Active community

## Best Practices

1. **Start Small**: Begin with one critical repository
2. **Set Budget Thresholds**: Fail PRs that exceed budget
3. **Use Comments**: Enable PR comments for visibility
4. **Combine with Policies**: Use with Cloud Custodian for enforcement
5. **Track Trends**: Monitor cost changes over time

## Conclusion

Infracost is the **gold standard for shift-left FinOps**. Its deep integration with developer workflows, accurate cost estimates, and open-source model make it essential for any organization practicing FinOps.

**Rating**: ⭐⭐⭐⭐⭐ (5/5)
**Best For**: Dev teams, IaC users, CI/CD pipelines
**Must-Have Add-on**: Cloud Custodian (for remediation)
