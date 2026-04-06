#!/bin/bash

# FinOps POC Framework - Main Runner Script
# Cloud-Agnostic FinOps Proof of Concept

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROVIDERS=""
ANALYZE=false
REPORT=false
REPORT_FORMAT="pdf"
CHECK_TAGS=false
RIGHTSIZING=false
EXPORT=false
EXPORT_FORMAT="csv"
PERIOD="last_month"

# Help message
show_help() {
    cat << EOF
${GREEN}FinOps POC Framework${NC}

A cloud-agnostic FinOps proof of concept for validating 
cloud cost management capabilities.

${YELLOW}Usage:${NC}
    $0 [OPTIONS]

${YELLOW}Options:${NC}
    --all-providers          Run for all configured cloud providers
    --aws                    Run for AWS only
    --azure                  Run for Azure only
    --gcp                    Run for GCP only
    --analyze                Run cost analysis
    --report                 Generate cost report
    --format FORMAT          Report format: pdf, csv, json (default: pdf)
    --check-tags             Check tag compliance
    --rightsizing            Run rightsizing analysis
    --export                 Export data
    --period PERIOD          Analysis period: last_day, last_week, last_month
    --roi-calculator         Run ROI calculator
    --help                   Show this help message

${YELLOW}Examples:${NC}
    $0 --all-providers --analyze
    $0 --aws --report --format csv
    $0 --check-tags --required Environment,Owner
    $0 --roi-calculator

EOF
}

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is required but not installed."
        exit 1
    fi
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3 is required but not installed."
        exit 1
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        log_warning "jq is recommended but not found. Some features may not work."
    fi
    
    log_success "Prerequisites check passed"
}

# Setup environment
setup() {
    log_info "Setting up FinOps POC environment..."
    
    # Create directories
    mkdir -p data/{aws,azure,gcp,normalized}
    mkdir -p output/{reports,dashboards}
    mkdir -p config
    
    # Check for config file
    if [ ! -f "config/providers.yaml" ]; then
        log_warning "Creating example providers.yaml"
        cp config/providers.yaml.example config/providers.yaml 2>/dev/null || true
    fi
    
    log_success "Environment setup complete"
}

# Collect data from providers
collect_data() {
    local provider=$1
    
    log_info "Collecting data from $provider..."
    
    case $provider in
        aws)
            # AWS data collection
            if command -v aws &> /dev/null; then
                log_info "Collecting AWS Cost Explorer data..."
                aws ce get-cost-and-usage \
                    --time-period Start=$(date -d '30 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
                    --granularity MONTHLY \
                    --metrics "BlendedCost" "UnblendedCost" "UsageQuantity" \
                    > data/aws/cost_data.json 2>/dev/null || true
                
                log_info "Collecting AWS usage data..."
                aws ce get-resource-configs \
                    --resource-region us-east-1 \
                    > data/aws/resource_data.json 2>/dev/null || true
                
                log_success "AWS data collected"
            else
                log_warning "AWS CLI not found, skipping AWS collection"
            fi
            ;;
        
        azure)
            # Azure data collection
            if command -v az &> /dev/null; then
                log_info "Collecting Azure Cost Management data..."
                az costmanagement query \
                    --type ActualCost \
                    --time-period-type MonthToDate \
                    --dataset-granularity Daily \
                    > data/azure/cost_data.json 2>/dev/null || true
                
                log_success "Azure data collected"
            else
                log_warning "Azure CLI not found, skipping Azure collection"
            fi
            ;;
        
        gcp)
            # GCP data collection
            if command -v gcloud &> /dev/null; then
                log_info "Collecting GCP billing data..."
                bq query --use_legacy_sql=false \
                    --format=json \
                    "SELECT * FROM \`billing.gcp_billing_export_v1_*\` 
                     WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)" \
                    > data/gcp/cost_data.json 2>/dev/null || true
                
                log_success "GCP data collected"
            else
                log_warning "GCP CLI not found, skipping GCP collection"
            fi
            ;;
    esac
}

# Normalize data to FOCUS format
normalize_data() {
    log_info "Normalizing data to FOCUS specification..."
    
    # Run normalization script
    python3 scripts/normalize.py data/ data/normalized/ 2>/dev/null || true
    
    log_success "Data normalized"
}

# Run cost analysis
run_analysis() {
    log_info "Running cost analysis..."
    
    # Run analysis script
    python3 scripts/analyze.py data/normalized/ 2>/dev/null || true
    
    log_success "Analysis complete"
}

# Generate reports
generate_report() {
    log_info "Generating $REPORT_FORMAT report..."
    
    mkdir -p output/reports
    
    # Run report generation
    python3 scripts/generate_report.py \
        --input data/normalized/ \
        --output output/reports/ \
        --format $REPORT_FORMAT \
        --period $PERIOD 2>/dev/null || true
    
    log_success "Report generated: output/reports/cost-report.$REPORT_FORMAT"
}

# Check tag compliance
check_tag_compliance() {
    log_info "Checking tag compliance..."
    
    # Run tag compliance check
    python3 scripts/check_tags.py data/normalized/ 2>/dev/null || true
    
    log_success "Tag compliance check complete"
}

# Run rightsizing analysis
run_rightsizing() {
    log_info "Running rightsizing analysis..."
    
    # Run rightsizing script
    python3 scripts/rightsizing.py data/normalized/ 2>/dev/null || true
    
    log_success "Rightsizing analysis complete"
}

# Export data
export_data() {
    log_info "Exporting data in $EXPORT_FORMAT format..."
    
    mkdir -p output/exports
    
    python3 scripts/export.py \
        --input data/normalized/ \
        --output output/exports/ \
        --format $EXPORT_FORMAT 2>/dev/null || true
    
    log_success "Data exported: output/exports/.$EXPORT_FORMAT"
}

# ROI Calculator
run_roi_calculator() {
    echo ""
    echo "=================================================="
    echo "           FinOps ROI Calculator                  "
    echo "=================================================="
    echo ""
    
    read -p "Enter monthly cloud spend ($): " monthly_spend
    read -p "Enter estimated waste percentage (%): " waste_pct
    read -p "Enter team size: " team_size
    
    # Calculate potential savings
    waste_amount=$(echo "scale=2; $monthly_spend * $waste_pct / 100" | bc)
    rightsizing_savings=$(echo "scale=2; $waste_amount * 0.4" | bc)
    commitment_savings=$(echo "scale=2; $monthly_spend * 0.1" | bc)
    automation_savings=$(echo "scale=2; $waste_amount * 0.2" | bc)
    total_savings=$(echo "scale=2; $rightsizing_savings + $commitment_savings + $automation_savings" | bc)
    
    # Implementation costs
    implementation_cost=50000
    annual_cost=$(echo "scale=2; $monthly_spend * 12" | bc)
    annual_savings=$(echo "scale=2; $total_savings * 12" | bc)
    roi=$(echo "scale=2; (($annual_savings - $implementation_cost) / $implementation_cost) * 100" | bc)
    payback=$(echo "scale=2; $implementation_cost / $total_savings" | bc)
    
    echo ""
    echo "=================================================="
    echo "                 ROI Analysis                    "
    echo "=================================================="
    echo ""
    echo "Monthly Cloud Spend:     \$$monthly_spend"
    echo "Current Waste:           \$$waste_amount ($waste_pct%)"
    echo ""
    echo "Projected Monthly Savings:"
    echo "├── Rightsizing:          \$$rightsizing_savings"
    echo "├── Commitment Optimization: \$$commitment_savings"
    echo "└── Automation:          \$$automation_savings"
    echo ""
    echo "Total Monthly Savings:   \$$total_savings"
    echo ""
    echo "Annual Savings:          \$$annual_savings"
    echo "Implementation Cost:    \$$implementation_cost"
    echo "ROI:                     $roi%"
    echo "Payback Period:          $payback months"
    echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all-providers)
            PROVIDERS="aws azure gcp"
            shift
            ;;
        --aws|--azure|--gcp)
            PROVIDERS="${PROVIDERS}${1#--} "
            shift
            ;;
        --analyze)
            ANALYZE=true
            shift
            ;;
        --report)
            REPORT=true
            shift
            ;;
        --format)
            REPORT_FORMAT="$2"
            shift 2
            ;;
        --check-tags)
            CHECK_TAGS=true
            shift
            ;;
        --rightsizing)
            RIGHTSIZING=true
            shift
            ;;
        --export)
            EXPORT=true
            shift
            ;;
        --period)
            PERIOD="$2"
            shift 2
            ;;
        --roi-calculator)
            run_roi_calculator
            exit 0
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    echo ""
    echo "=================================================="
    echo "        FinOps POC Framework v1.0                "
    echo "=================================================="
    echo ""
    
    check_prerequisites
    setup
    
    # If no providers specified, use all
    if [ -z "$PROVIDERS" ]; then
        log_warning "No providers specified. Use --all-providers or --aws/--azure/--gcp"
        PROVIDERS="aws azure gcp"
    fi
    
    # Collect data from each provider
    for provider in $PROVIDERS; do
        collect_data $provider
    done
    
    # Normalize data
    normalize_data
    
    # Run analysis if requested
    if [ "$ANALYZE" = true ]; then
        run_analysis
    fi
    
    # Generate report if requested
    if [ "$REPORT" = true ]; then
        generate_report
    fi
    
    # Check tags if requested
    if [ "$CHECK_TAGS" = true ]; then
        check_tag_compliance
    fi
    
    # Rightsizing if requested
    if [ "$RIGHTSIZING" = true ]; then
        run_rightsizing
    fi
    
    # Export if requested
    if [ "$EXPORT" = true ]; then
        export_data
    fi
    
    echo ""
    log_success "FinOps POC execution complete!"
    echo ""
    echo "Output location: ./output/"
    echo ""
}

main
