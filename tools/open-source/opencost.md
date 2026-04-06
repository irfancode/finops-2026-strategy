# OpenCost: The CNCF Standard for Kubernetes Cost Monitoring

![OpenCost](https://img.shields.io/github/stars/opencost/opencost?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache--2.0-green?style=for-the-badge)
![CNCF](https://img.shields.io/badge/CNCF-Incubating-blue?style=for-the-badge)

> **"The vendor-neutral K8s cost monitoring standard"**

## Overview

OpenCost is a **Cloud Native Computing Foundation (CNCF) incubating project** that provides a vendor-neutral, open-source standard for Kubernetes cost monitoring. It enables fine-grained resource cost allocation and real-time cost visibility for Kubernetes workloads.

### Key Statistics
- **GitHub Stars**: 3,200+
- **Contributors**: 150+
- **Adoption**: Growing rapidly
- **Cloud Providers**: AWS, Azure, GCP, On-prem

## Core Features

### 1. Open Cost Model
```yaml
# Standardized cost allocation
costData:
  namespace: default
  pod: nginx-abc123
  container: nginx
  cpu:
    cost: 0.048  # per core-hour
    request: 2
    usage: 0.8
  memory:
    cost: 0.012  # per GiB-hour
    request: 4
    usage: 2.5
  storage:
    cost: 0.0001  # per GiB-hour
    request: 10
  network:
    cost: 0.05  # per GiB
    transfer: 1.2
```

### 2. Prometheus Integration
- Metrics endpoint for Prometheus scraping
- Pre-built Grafana dashboards
- Custom metric support

### 3. Multi-Cluster Support
```yaml
# federator.yaml
clusters:
  - name: prod-us-east
    url: https://prod-us-east.k8s.local
  - name: prod-eu-west
    url: https://prod-eu-west.k8s.local
```

### 4. Kubecost Compatibility
OpenCost is designed as the open-source foundation that Kubecost and other tools can build upon.

### 5. Custom Allocation Model
```yaml
allocation:
  sharedNamespaces:
    - kube-system
    - monitoring
  sharedSplit: weighted  # or even, proportional
  idleByNode: true
```

## Pricing Model

| Tier | Price | Features |
|------|-------|----------|
| Open Source | Free | Full functionality |
| Enterprise Support | Custom | SLA, training |

## Pros and Cons

### ✅ Pros

| Advantage | Description | Impact |
|-----------|-------------|--------|
| **CNCF Standard** | Vendor neutral | Future-proof |
| **Open Standard** | Open cost model | Portability |
| **Prometheus Native** | OOTB integration | Easy adoption |
| **Lightweight** | Low resource overhead | Efficient |
| **Extensible** | Custom allocation | Flexibility |
| **Community Driven** | CNCF governance | Longevity |
| **Compatible** | Kubecost compatible | Migration path |

### ❌ Cons

| Limitation | Description | Workaround |
|------------|-------------|------------|
| **Early Stage** | Less mature than Kubecost | Rapid development |
| **Limited UI** | Basic dashboard | Grafana dashboards |
| **Documentation** | Growing | Community support |
| **No Built-in Alerts** | Needs external | AlertManager |
| **Setup Required** | Manual configuration | Helm chart |

## Use Cases

### 1. Multi-Cloud Kubernetes
```
Before: Different tools per cloud
After:  Single standard across all
```

### 2. Vendor Neutral Strategy
```
Before: Locked to Kubecost
After:  Open standard, portable
```

### 3. Standardization Initiative
```
Before: Shadow IT cost tools
After:  CNCF-backed standard
```

## Installation

### Helm (Recommended)
```bash
helm repo add opencost https://opencost.io/opencost-helm-chart
helm install opencost opencost/opencost -n opencost --create-namespace
```

### kubectl
```bash
kubectl apply -f https://raw.githubusercontent.com/opencost/opencost/develop/kubernetes/opencost.yaml
```

### Kubefed (Multi-Cluster)
```bash
helm install federation opencost/opencost \
  --set opencost.federator.enabled=true
```

## Quick Start

### 1. Access Metrics
```bash
# Prometheus scrape config
- job_name: 'opencost'
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      action: keep
      regex: opencost
  metrics_path: /metrics
```

### 2. View in Grafana
```bash
# Import dashboard ID: 17778
```

### 3. Query Costs
```promql
# Total cluster cost
sum(kube_cost_container_memory_allocation_bytes)

# By namespace
sum by (namespace) (container_cpu_allocation_cores * on(cluster) group_left(cluster)
  kube_node_status_capacity_cpu_cores)
```

## Comparison with Kubecost

| Feature | OpenCost | Kubecost |
|---------|----------|----------|
| License | Apache 2.0 | Proprietary |
| UI | Basic | Rich |
| Alerts | No | Yes |
| Enterprise | No | Yes |
| Support | Community | Dedicated |
| Cloud Integration | Basic | Deep |

## ROI Analysis

### Implementation Cost
```
- Engineering time: 4-8 hours
- Ongoing maintenance: 1-2 hours/month
- Total first-year cost: ~$5,000
```

### Potential Savings
```
- Visibility leads to 15-25% efficiency gains
- For $50K/month K8s spend: $7,500-$12,500/month savings
- Annual ROI: 180-300%
```

## Best Practices

1. **Enable Prometheus**: Required for metrics
2. **Use Grafana**: For visualization
3. **Set Allocation Rules**: Match your org structure
4. **Monitor Idle**: Track wasted capacity
5. **Combine with Kubecost**: If you need advanced features

## Conclusion

OpenCost represents the **future of Kubernetes cost monitoring** - an open, vendor-neutral standard backed by CNCF. While less feature-rich than Kubecost, its open model and growing community make it the right choice for organizations prioritizing portability and vendor independence.

**Rating**: ⭐⭐⭐⭐ (4/5)
**Best For**: Multi-cloud teams, CNCF adopters, Open-source advocates
**Pair With**: Grafana (UI), AlertManager (alerts)
