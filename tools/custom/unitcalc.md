# UnitCalc: Real-Time Unit Economics Engine

## The Vision

**UnitCalc** provides **real-time unit economics for cloud-native businesses**. It transforms raw cloud costs into meaningful business metrics: cost per customer, cost per transaction, cost per feature—so engineering teams can make data-driven decisions.

## The Problem

| Issue | Impact | Current Solutions |
|-------|--------|-------------------|
| No cost-per-unit | Wrong pricing decisions | Guesswork |
| Slow reporting | Quarterly reviews | Manual Excel |
| Missing attribution | Blame games | None |
| Unit economics unknown | Business at risk | Consultants |

## Market Opportunity

- **Problem Size**: 60% of cloud-native companies lack unit economics
- **TAM**: $4B by 2028
- **Target**: SaaS, E-commerce, Cloud-native
- **Revenue Potential**: $100K/quarter

## Core Features

### 1. Unit Definition Engine
```yaml
Unit Types:

transaction:
  definition: API call or database write
  instrumentation: Trace every call
  cost_attribution: Direct + shared allocation
  
customer:
  definition: Active user (30-day)
  instrumentation: Auth system + usage
  cost_attribution: All direct + proportional shared

feature:
  definition: Feature module/component
  instrumentation: Feature flags + metrics
  cost_attribution: Direct resources + shared

api_call:
  definition: HTTP request to service
  instrumentation: API gateway logs
  cost_attribution: Direct compute + proportional infra
```

### 2. Real-Time Cost Attribution
```
┌─────────────────────────────────────────────────────────────┐
│  Live Unit Economics Dashboard                               │
├─────────────────────────────────────────────────────────────┤
│  Cost Per Customer: $2.34                                    │
│  ├── Compute: $1.45 (62%)                                    │
│  ├── Database: $0.62 (26%)                                   │
│  ├── Storage: $0.18 (8%)                                    │
│  └── Network: $0.09 (4%)                                    │
│                                                              │
│  This Month vs Last Month: -8.2%                             │
│  └── Trend: 📉 Improving                                     │
│                                                              │
│  Customer Segments:                                          │
│  ├── Enterprise: $12.45/customer                            │
│  ├── Professional: $4.23/customer                           │
│  └── Starter: $0.89/customer                                │
└─────────────────────────────────────────────────────────────┘
```

### 3. Attribution Model
```python
class UnitAttributor:
    """
    Distributes cloud costs to business units using
    multiple attribution methods.
    """
    
    ATTRIBUTION_METHODS = [
        'direct',           # Resource directly used
        'time-based',       # Split by time used
        'request-based',    # Split by requests
        'value-based',      # Split by business value
        'custom',          # User-defined weights
    ]
    
    def attribute_cost(self, resource, units):
        """
        Takes a cloud resource and attributes its cost
        to business units.
        """
        direct_costs = self.find_direct_costs(resource)
        shared_costs = self.find_shared_costs(resource)
        
        attribution = {}
        for unit in units:
            direct = sum(d.cost for d in direct_costs if d.unit == unit)
            shared = self.allocate_shared(
                shared_costs,
                method=self.ATTRIBUTION_METHODS.request-based,
                units=units
            )
            attribution[unit] = direct + shared.get(unit, 0)
        
        return attribution
```

### 4. Trend Analysis
```json
{
  "unit_economics_trends": {
    "period": "90d",
    "cost_per_customer": {
      "current": 2.34,
      "30d_ago": 2.67,
      "90d_ago": 2.89,
      "trend": "decreasing",
      "change_pct": -19%
    },
    "cost_per_transaction": {
      "current": 0.0042,
      "30d_ago": 0.0048,
      "90d_ago": 0.0051,
      "trend": "decreasing",
      "change_pct": -18%
    }
  },
  "drivers": {
    "improvement_reasons": [
      {
        "factor": "EC2 rightsizing",
        "impact": "-$0.15/customer"
      },
      {
        "factor": "Database optimization",
        "impact": "-$0.08/customer"
      },
      {
        "factor": "Storage tiering",
        "impact": "-$0.05/customer"
      }
    ]
  }
}
```

### 5. Feature Cost Analysis
```yaml
Feature: Video Processing
├── Monthly Cost: $45,230
├── Active Users: 12,450
├── Cost Per User: $3.63
│
├── Cost Breakdown:
│   ├── Transcoding EC2: $28,500
│   ├── Storage S3: $8,200
│   ├── CDN: $5,300
│   └── Database: $3,230
│
├── Usage Metrics:
│   ├── Videos Processed: 2.1M/month
│   ├── Avg Processing Time: 45s
│   └── Cost Per Video: $0.022
│
├── Comparison to Industry:
│   ├── Our Cost: $0.022/video
│   ├── Industry Avg: $0.035/video
│   └── Position: 35% more efficient
│
└── Recommendations:
    ├── Consider Spot instances: -$0.003/video
    ├── Batch processing: -$0.002/video
    └── Total Potential: -$0.005/video = -$10,500/month
```

## Technical Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    UnitCalc Platform                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ Cloud Costs  │  │ Business     │  │ Usage        │       │
│  │ AWS/Azure/GCP│  │ CRM/Auth     │  │ APM/Traces   │       │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│         │                 │                 │               │
│         └────────────┬────┴────┬────────────┘               │
│                      ▼         ▼                            │
│              ┌───────────────┴───────────────┐              │
│              │    Data Integration Layer      │              │
│              │  ┌─────────────────────────┐  │              │
│              │  │ - Cost data sync        │  │              │
│              │  │ - Usage data collection │  │              │
│              │  │ - Customer sync         │  │              │
│              │  │ - Real-time streaming   │  │              │
│              │  └─────────────────────────┘  │              │
│              └───────────────┬───────────────┘              │
│                              ▼                               │
│              ┌───────────────────────────────┐              │
│              │     Attribution Engine         │              │
│              │  ┌─────────────────────────┐  │              │
│              │  │ - Multi-method alloc   │  │              │
│              │  │ - Shared cost splitter │  │              │
│              │  │ - Trend calculation    │  │              │
│              │  │ - Anomaly detection   │  │              │
│              │  └─────────────────────────┘  │              │
│              └───────────────┬───────────────┘              │
│                              ▼                               │
│              ┌───────────────────────────────┐              │
│              │     Dashboard & API            │              │
│              │  ┌─────────────────────────┐  │              │
│              │  │ - Real-time KPIs        │  │              │
│              │  │ - Trend charts          │  │              │
│              │  │ - Alert engine          │  │              │
│              │  │ - Export APIs          │  │              │
│              │  └─────────────────────────┘  │              │
│              └───────────────────────────────┘              │
└─────────────────────────────────────────────────────────────┘
```

## Pricing Model

| Tier | Price | Monthly Units | Features |
|------|-------|---------------|----------|
| Free | $0 | 10K customers | Basic metrics |
| Starter | $149/mo | 50K customers | + Trends, API |
| Growth | $449/mo | 200K customers | + Segments, exports |
| Scale | $1,299/mo | 1M customers | + Anomaly detection |
| Enterprise | Custom | Unlimited | + Custom attribution |

## Revenue Model

```
Target: 150 paying customers by Q4 2026

Revenue Projections:
├── Q1: 15 customers × $200 avg = $3K/month
├── Q2: 45 customers × $300 avg = $14K/month
├── Q3: 90 customers × $400 avg = $36K/month
└── Q4: 150 customers × $500 avg = $75K/month

Quarterly Revenue: $225K

With Enterprise:
├── Enterprise: 10 customers × $2K/mo = $20K/month
├── Standard: 140 customers × $500/mo = $70K/month
└── Total: $90K/month = $270K/quarter

Complete Suite Bundle:
├── CloudLens: $1,499/mo
├── TagGuard: $499/mo
├── WasteHunter: $599/mo
├── FinOps.ai: $299/mo
├── UnitCalc: $499/mo
Total Bundle: $3,395/mo

Target: 100 bundle customers = $339K/month = $1M+/quarter
```

## Competitive Advantages

| Feature | UnitCalc | Manual Excel | CloudZero | Built in-house |
|---------|----------|-------------|-----------|----------------|
| Real-time | ✅ | ❌ | Basic | ❌ |
| Attribution | ✅ | Manual | ✅ | ❌ |
| Trends | ✅ | Manual | ✅ | ❌ |
| Integration | ✅ | ❌ | ✅ | ❌ |
| Alerts | ✅ | ❌ | ✅ | ❌ |
| Price | $$ | Free | $$$$ | 💰💰💰 |

## Development Roadmap

```
Q1 2026:
├── [x] Core attribution engine
├── [x] Basic dashboard
├── [x] AWS integration
└── [ ] 15 beta customers

Q2 2026:
├── [ ] Azure, GCP support
├── [ ] CRM integration
├── [ ] Anomaly detection
└── [ ] 45 paying customers

Q3 2026:
├── [ ] Feature cost tracking
├── [ ] Custom attribution
├── [ ] Export APIs
└── [ ] 90 paying customers

Q4 2026:
├── [ ] ML forecasting
├── [ ] Industry benchmarks
├── [ ] Enterprise features
└── [ ] 150 customers, $100K/quarter
```

## Success Metrics

| Metric | Q1 | Q2 | Q3 | Q4 |
|--------|-----|-----|-----|-----|
| Paying Customers | 15 | 45 | 90 | 150 |
| MRR | $3K | $14K | $36K | $75K |
| Avg Cost Per Customer | $2.34 | $2.15 | $1.95 | $1.80 |
| Time to Insight | 4hr | 1hr | 15min | 5min |

## Why UnitCalc Will Succeed

1. **Business Alignment**: Connects cloud costs to business metrics
2. **Real-time**: Instant insights vs. quarterly reviews
3. **SaaS Focus**: Built for subscription businesses
4. **Integration**: Works with existing tools
5. **Partnership**: Essential for complete FinOps suite

## Get Started

```bash
# Install UnitCalc SDK
pip install unitcalc

# Initialize
unitcalc init --org-id your-org --api-key your-key

# Define your units
unitcalc define unit --type customer --source auth-system
unitcalc define unit --type transaction --source api-gateway

# Start tracking
unitcalc track --live
```

## Documentation

- [Getting Started](docs/getting-started.md)
- [Attribution Methods](docs/attribution.md)
- [Integrations](docs/integrations.md)
- [API Reference](docs/api.md)

---

**UnitCalc**: Know what every customer, transaction, and feature really costs.
