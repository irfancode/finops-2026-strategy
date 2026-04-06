# Cloud Custodian: Policy-as-Code for Cloud Governance

![Cloud Custodian](https://img.shields.io/github/stars/cloud-custodian/cloud-custodian?style=for-the-badge)
![Python](https://img.shields.io/badge/Language-Python-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache--2.0-green?style=for-the-badge)

> **"Rules engine for cloud security, cost optimization, and governance"**

## Overview

Cloud Custodian (c7n) is a **powerful rules engine for cloud resource management**. It uses simple YAML policies to query, filter, and take action on resources across AWS, Azure, and GCP. Originally developed by Capital One, it's one of the most comprehensive open-source cloud governance tools available.

### Key Statistics
- **GitHub Stars**: 5,958+
- **GitHub Forks**: 1,605
- **Cloud Providers**: AWS, Azure, GCP
- **Resources Managed**: 1,000+

## Core Features

### 1. Policy-as-Code
```yaml
policies:
  # Stop idle EC2 instances
  - name: stop-idle-instances
    resource: ec2
    filters:
      - type: instance-attribute
        attribute: instanceType.t2.micro
        op: not-equal
      - type: value
        key: cpuutilization
        value: 10
        op: less-than
    actions:
      - stop

  # Delete unused EBS volumes
  - name: delete-unused-volumes
    resource: ebs
    filters:
      - type: value
        key: attachments
        value: []
    actions:
      - delete
```

### 2. Multi-Cloud Support
```yaml
# AWS
- name: aws-resources
  resource: aws.ec2

# Azure
- name: azure-resources
  resource: azure.vm

# GCP
- name: gcp-resources
  resource: gcp.instance
```

### 3. Real-Time Enforcement
```yaml
- name: enforce-encryption
  resource: ebs
  mode:
    type: cloudtrail
    events:
      - CreateVolume
      - AttachVolume
  filters:
    - type: value
      key: Encrypted
      value: false
  actions:
    - type: mark-for-op
      op: delete
      days: 1
```

### 4. Compliance Reporting
```yaml
- name: compliance-report
  resource: s3
  filters:
    - type: missing-value
      tags:
        - Owner
        - Environment
        - Compliance
  actions:
    - type: notify
      to:
        - security@company.com
      subject: "Non-compliant S3 bucket"
```

## Pricing Model

| Tier | Price | Features |
|------|-------|----------|
| Open Source | Free | Full functionality |
| Enterprise | Custom | UI, Support, Training |

## Pros and Cons

### ✅ Pros

| Advantage | Description | Impact |
|-----------|-------------|--------|
| **Automation** | Enforce policies automatically | Saves time |
| **Multi-Cloud** | Single tool for all providers | Simplifies |
| **Extensible** | Python plugins | Flexibility |
| **Real-Time** | Event-driven mode | Immediate |
| **Comprehensive** | 1,000+ resource types | Coverage |
| **Mature** | 8+ years in production | Reliability |
| **Free** | No licensing cost | Budget-friendly |

### ❌ Cons

| Limitation | Description | Workaround |
|------------|-------------|------------|
| **YAML Learning** | Policy syntax required | Training |
| **No UI** | CLI/Code only | Third-party |
| **Complexity** | Can get complex | Best practices |
| **Rate Limits** | Cloud API limits | Batching |
| **Debugging** | Can be tricky | Dry runs |

## Use Cases

### 1. Cost Optimization
```yaml
# Terminate idle resources
- name: cleanup-idle-resources
  resource: ec2
  filters:
    - type: metrics
      name: CPUUtilization
      days: 7
      period: 86400
      value: 5
      op: less-than
  actions:
    - terminate
```

### 2. Security Compliance
```yaml
# Enforce encryption
- name: require-encryption
  resource: s3
  filters:
    - type: missing-value
      key: ServerSideEncryptionConfiguration
  actions:
    - type: encryption-policy
      attribute: ServerSideEncryptionByDefault
      mode: AES256
```

### 3. Tag Enforcement
```yaml
# Require tags
- name: require-tags
  resource: '*'
  filters:
    - type: missing-value
      tags:
        - CostCenter
        - Environment
        - Owner
  actions:
    - type: mark-for-op
      op: tag
      tag: MissingTags
    - type: notify
```

## Installation

### pip
```bash
pip install c7n
```

### Docker
```bash
docker pull cloudcustodian/c7n
docker run --rm -it cloudcustodian/c7n validate policy.yml
```

### AWS Lambda
```bash
c7n-mailer -s policy.yml
c7n-org -s org-policy.yml
```

## Quick Start

### 1. Create Policy
```yaml
# policy.yml
policies:
  - name: stop-dev-instances
    resource: ec2
    filters:
      - Name: "*dev*"
        op: regex
      - State: running
    actions:
      - stop
```

### 2. Validate
```bash
custodian validate policy.yml
```

### 3. Dry Run
```bash
custodian run -s /tmp/output policy.yml --dryrun
```

### 4. Execute
```bash
custodian run -s /tmp/output policy.yml
```

## Advanced Patterns

### Multi-Account
```bash
c7n-org run -c accounts.yml -s /tmp/output policy.yml
```

### AWS Config Integration
```yaml
- name: config-check
  resource: ec2
  mode:
    type: config-rule
    expression: >
      resource.Name == 'test'
  actions:
    - notify
```

### Lambda Output
```yaml
- name: lambda-cleanup
  resource: lambda
  filters:
    - type: value
      key: LastModified
      value: 90
      op: days-ago
  actions:
    - delete
```

## ROI Analysis

### Real Example (Capital One)
```
Resources scanned: 1 million+
Policies enforced: 100+
Annual savings: $5M+
Time saved: 50+ hours/week
```

### Typical Savings
```
- Stop idle instances: $200-500/instance/month
- Delete unused volumes: $50-100/volume/month
- Enforce rightsizing: 20-40% compute savings
- Total: Often 15-30% of cloud spend
```

## Best Practices

1. **Start with Dry Run**: Always test first
2. **Use Tags**: Enable selective enforcement
3. **Regular Audits**: Review policy effectiveness
4. **Version Control**: Git your policies
5. **Lambda Mode**: For real-time enforcement

## Conclusion

Cloud Custodian is the **Swiss Army knife of cloud governance**. Its policy-as-code approach, multi-cloud support, and powerful automation capabilities make it essential for any FinOps practice. Combined with visibility tools like Infracost and Kubecost, it provides a complete open-source FinOps stack.

**Rating**: ⭐⭐⭐⭐⭐ (5/5)
**Best For**: DevOps, Security, Compliance, FinOps teams
**Must-Have Pair**: Infracost (estimation), Kubecost (visibility)
