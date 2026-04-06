# Cloud-Agnostic FinOps Proof of Concept (POC) Framework

> **"Validate your FinOps strategy before committing to expensive tools"**

## Overview

This POC framework provides a **production-ready, cloud-agnostic FinOps implementation** that works across AWS, Azure, GCP, and OCI. It validates FinOps capabilities without vendor lock-in.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 Cloud-Agnostic FinOps POC                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                   Cloud Providers                      │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐   │   │
│  │  │   AWS   │  │  Azure  │  │   GCP   │  │   OCI   │   │   │
│  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘   │   │
│  └───────┼───────────┼───────────┼───────────┼─────────────┘   │
│          │           │           │           │                 │
│  ┌───────▼───────────▼───────────▼───────────▼─────────────┐   │
│  │                  Data Connectors                        │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │   │
│  │  │ AWS Native  │ │ Azure CUR   │ │ GCP Billing │        │   │
│  │  │ APIs        │ │ Exports     │ │ Export      │        │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐ │
│  │              Normalization Layer (FOCUS)                 │ │
│  │  ┌─────────────────────────────────────────────────┐    │ │
│  │  │ - Schema normalization                           │    │ │
│  │  │ - Currency conversion                            │    │ │
│  │  │ - Unit standardization                          │    │ │
│  │  │ - Tag mapping                                   │    │ │
│  │  └─────────────────────────────────────────────────┘    │ │
│  └──────────────────────────┬──────────────────────────────┘ │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐ │
│  │                   Analytics Engine                        │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │ │
│  │  │ Cost        │ │ Anomaly     │ │ Rightsizing │        │ │
│  │  │ Allocation  │ │ Detection   │ │ Engine      │        │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │ │
│  │  │ Forecasting │ │ Tag         │ │ Commitment  │        │ │
│  │  │             │ │ Compliance  │ │ Analysis    │        │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │ │
│  └──────────────────────────┬──────────────────────────────┘ │
│                              │                                 │
│  ┌──────────────────────────▼──────────────────────────────┐ │
│  │                   Reporting & Alerts                      │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │ │
│  │  │ Dashboards  │ │ Reports     │ │ Alerts      │        │ │
│  │  │ (Grafana)   │ │ (PDF/CSV)   │ │ (Email/Slack)│        │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘        │ │
│  └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites
```bash
# Required tools
- Docker & Docker Compose
- Python 3.10+
- jq
- curl
- AWS CLI (for AWS)
- Azure CLI (for Azure)
- gcloud CLI (for GCP)
```

### Run the POC

```bash
# 1. Clone and navigate
cd poc

# 2. Configure cloud credentials
cp config/providers.yaml.example config/providers.yaml
# Edit with your cloud credentials

# 3. Start the framework
./run-poc.sh --all-providers

# 4. Access dashboards
# - Grafana: http://localhost:3000
# - API: http://localhost:8000
# - Reports: http://localhost:8080
```

## Components

### 1. Data Connectors

#### AWS Connector
```python
class AWSConnector:
    """
    Collects cost and usage data from AWS.
    """
    
    SOURCES = [
        'cost_explorer',      # Daily/monthly costs
        'cur',                # Detailed billing
        'usage_api',          # Resource usage
        'ce_forecast',        # Cost forecasts
    ]
    
    def collect(self, source):
        if source == 'cost_explorer':
            return self.get_cost_explorer_data()
        elif source == 'cur':
            return self.get_cur_data()
        # ...
```

#### Azure Connector
```python
class AzureConnector:
    """
    Collects cost and usage data from Azure.
    """
    
    SOURCES = [
        'cost_management',     # Cost analysis API
        'usage_details',       # Detailed usage
        'budgets',            # Budget data
    ]
```

#### GCP Connector
```python
class GCPConnector:
    """
    Collects cost and usage data from GCP.
    """
    
    SOURCES = [
        'billing_export',      # BigQuery billing export
        'cloud_api',           # Resource APIs
        'recommendations',     # Optimization recs
    ]
```

### 2. Normalization Engine

#### FOCUS Compliance
```python
class FOCUSNormalizer:
    """
    Normalizes all cloud data to FOCUS specification.
    """
    
    def normalize(self, raw_data, provider):
        """
        Converts provider-specific data to FOCUS format.
        """
        normalizer = {
            'aws': self.normalize_aws,
            'azure': self.normalize_azure,
            'gcp': self.normalize_gcp,
        }
        
        return normalizer[provider](raw_data)
    
    def normalize_aws(self, data):
        """
        Normalize AWS Cost and Usage Report to FOCUS.
        """
        return {
            'billingPeriod': data['bill/BillingPeriodStartDate'],
            'lineItem': {
                'id': data['lineItem/LineItemId'],
                'productCode': data['lineItem/ProductCode'],
                'usageType': data['lineItem/UsageType'],
                'usageAmount': data['lineItem/UsageAmount'],
                'cost': data['lineItem/UnblendedCost'],
            },
            'properties': {
                'region': data['product/Region'],
                'accountId': data['bill/PayerAccountId'],
                'service': data['product/ServiceName'],
            }
        }
```

### 3. Analytics Engine

#### Cost Allocation
```python
class CostAllocator:
    """
    Allocates costs to business units, teams, products.
    """
    
    def allocate(self, costs, allocation_rules):
        """
        Apply allocation rules to distribute shared costs.
        """
        results = []
        
        for rule in allocation_rules:
            if rule.type == 'tag-based':
                results.extend(self.tag_based_allocation(costs, rule))
            elif rule.type == 'usage-based':
                results.extend(self.usage_based_allocation(costs, rule))
            elif rule.type == 'fixed':
                results.extend(self.fixed_allocation(costs, rule))
        
        return results
```

#### Anomaly Detection
```python
class AnomalyDetector:
    """
    ML-based anomaly detection for cost spikes.
    """
    
    def detect(self, time_series, threshold=3.0):
        """
        Detect anomalies using statistical methods.
        """
        # Z-score based detection
        z_scores = self.calculate_z_scores(time_series)
        anomalies = [p for p, z in zip(time_series, z_scores) 
                     if abs(z) > threshold]
        
        return anomalies
```

#### Rightsizing Engine
```python
class RightsizingEngine:
    """
    Recommends and applies rightsizing optimizations.
    """
    
    def analyze(self, resources):
        """
        Analyze resources for rightsizing opportunities.
        """
        recommendations = []
        
        for resource in resources:
            utilization = self.get_utilization(resource)
            
            if utilization.cpu < 20 and resource.type == 'compute':
                recommendations.append({
                    'resource': resource.id,
                    'current_type': resource.instance_type,
                    'recommended_type': self.suggest_type(resource, utilization),
                    'savings_monthly': self.calculate_savings(
                        resource, 
                        self.suggest_type(resource, utilization)
                    ),
                    'risk': 'low' if utilization.cpu < 10 else 'medium'
                })
        
        return recommendations
```

### 4. Reporting & Alerts

#### Dashboard Configuration
```yaml
# grafana/dashboards/finops-overview.json
{
  "dashboard": {
    "title": "FinOps Overview",
    "tags": ["finops", "cost"],
    "timezone": "browser",
    "panels": [
      {
        "title": "Total Cloud Spend",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(focus_cost_total)",
            "legendFormat": "{{provider}}"
          }
        ]
      },
      {
        "title": "Daily Cost Trend",
        "type": "graph",
        "targets": [
          {
            "expr": "sum by (provider) (focus_cost_daily)",
            "legendFormat": "{{provider}}"
          }
        ]
      }
    ]
  }
}
```

#### Alert Configuration
```yaml
# alerts/cost-alerts.yaml
alerts:
  - name: high_daily_spend
    condition: daily_spend > budget * 0.8
    threshold: 10000
    notification:
      channels:
        - slack: "#finops-alerts"
        - email: finops-team@company.com
  
  - name: cost_anomaly
    condition: cost_spike > 3 * std_dev
    threshold: 50  # percent
    notification:
      channels:
        - slack: "#finops-critical"
        - pagerduty: finops-oncall
```

## Usage Examples

### 1. Run Full Analysis
```bash
# Collect and analyze all cloud costs
./run-poc.sh --all-providers --analyze --report

# Output:
# - Cost summary
# - Anomalies detected
# - Rightsizing recommendations
# - Tag compliance report
```

### 2. Generate Cost Report
```bash
# Generate PDF report for last month
./run-poc.sh --report --format=pdf --period=last_month

# Generate CSV export
./run-poc.sh --export --format=csv --dimensions=service,account
```

### 3. Check Tag Compliance
```bash
# Check tag compliance across all clouds
./run-poc.sh --check-tags --required=Environment,Owner,CostCenter

# Output:
# - Compliance percentage
# - Non-compliant resources
# - Recommendations
```

### 4. Rightsizing Analysis
```bash
# Analyze compute resources
./run-poc.sh --rightsizing --resource-type=compute

# Output:
# - Current vs. recommended
# - Monthly savings
# - Risk assessment
```

## Configuration

### providers.yaml
```yaml
providers:
  aws:
    enabled: true
    accounts:
      - id: "prod-main"
        name: "Production"
        regions: ["us-east-1", "eu-west-1"]
        credentials: env  # or path to credentials
    
  azure:
    enabled: true
    subscriptions:
      - id: "sub-prod-001"
        name: "Production"
        credentials: env
    
  gcp:
    enabled: true
    projects:
      - id: "prod-main-123"
        name: "Production"
        credentials: env
```

### allocation.yaml
```yaml
allocation:
  rules:
    - name: "Shared Network"
      type: "usage-based"
      shared_costs:
        - NAT Gateway
        - VPN
        - Direct Connect
      split_by:
        - tag: "Team"
          weight: 0.7
        - tag: "Environment"
          weight: 0.3
    
    - name: "Support Costs"
      type: "fixed"
      fixed_costs:
        - AWS Enterprise Support
        - Azure Enterprise Agreement
      split_by:
        - method: "equal"
          per: "account"
```

## ROI Calculator

### Input Your Numbers
```bash
# Run ROI calculator
./run-poc.sh --roi-calculator

# Enter:
# - Monthly cloud spend
# - Number of resources
# - Current waste percentage
# - Team size

# Output:
# - Expected savings
# - Implementation cost
# - ROI timeline
# - Payback period
```

### Example ROI
```
Monthly Cloud Spend: $500,000
Current Waste: 25% ($125,000)

With FinOps POC:
├── Rightsizing Savings: $75,000/month
├── Commitment Optimization: $30,000/month
├── Waste Elimination: $20,000/month
└── Total Savings: $125,000/month

Implementation Cost: $50,000
ROI: 250%
Payback Period: 0.4 months (12 days)
```

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Cost Visibility | 100% | All resources tracked |
| Tag Compliance | >95% | Required tags present |
| Waste Reduction | >20% | Monthly cost decrease |
| Commitment Coverage | >60% | RIs/SPs coverage |
| Anomaly Detection | <1hr | Time to alert |
| Rightsizing | >15% | Resource optimization |

## Next Steps

After POC validation:

1. **Tool Selection**: Choose commercial tools based on gaps identified
2. **Process Design**: Document FinOps processes and workflows
3. **Team Structure**: Define FinOps team roles and responsibilities
4. **Governance**: Implement policies and guardrails
5. **Automation**: Build automated remediation workflows

## Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Reference](docs/configuration.md)
- [API Documentation](docs/api.md)
- [Troubleshooting](docs/troubleshooting.md)

## License

MIT License - See [LICENSE](LICENSE)
