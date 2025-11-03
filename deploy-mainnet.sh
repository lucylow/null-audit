#!/bin/bash

# Arbitra ICP Mainnet Deployment Script
# This script deploys all canisters to the Internet Computer mainnet

set -e

echo "🚀 Arbitra IC Mainnet Deployment"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if dfx is installed
if ! command -v dfx &> /dev/null; then
    echo -e "${RED}❌ Error: dfx is not installed${NC}"
    echo "Please install dfx: https://internetcomputer.org/docs/current/developer-docs/setup/install"
    exit 1
fi

echo -e "${GREEN}✅ dfx found: $(dfx --version)${NC}"

# Check current identity
CURRENT_IDENTITY=$(dfx identity whoami)
echo ""
echo "📋 Current identity: $CURRENT_IDENTITY"

if [ "$CURRENT_IDENTITY" == "default" ]; then
    echo -e "${YELLOW}⚠️  WARNING: You are using the default identity${NC}"
    echo "The default identity is not secure for mainnet deployments."
    echo ""
    echo "Options:"
    echo "1. Create a new secure identity: dfx identity new <name>"
    echo "2. Use an existing identity: dfx identity use <name>"
    echo "3. Continue with default (NOT RECOMMENDED)"
    echo ""
    read -p "Do you want to continue with the default identity? (yes/no): " CONTINUE
    
    if [ "$CONTINUE" != "yes" ]; then
        echo "Deployment cancelled. Please create a secure identity first."
        exit 1
    fi
    
    export DFX_WARNING=-mainnet_plaintext_identity
fi

# Check cycles balance
echo ""
echo "💰 Checking cycles balance..."
CYCLES_BALANCE=$(dfx cycles balance --network ic 2>&1 || echo "0")

if [[ "$CYCLES_BALANCE" == *"0"* ]] || [[ "$CYCLES_BALANCE" == *"Error"* ]]; then
    echo -e "${RED}❌ Insufficient cycles balance${NC}"
    echo ""
    echo "You need cycles to deploy to mainnet. Options:"
    echo "1. Get free cycles: https://internetcomputer.org/docs/current/developer-docs/setup/cycles/cycles-faucet"
    echo "2. Convert ICP to cycles: dfx cycles convert --amount=0.5 --network ic"
    echo "3. Use NNS Dapp: https://nns.ic0.app/"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Cycles balance: $CYCLES_BALANCE${NC}"

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}❌ Error: pnpm is not installed${NC}"
    echo "Please install pnpm: npm install -g pnpm"
    exit 1
fi

# Install frontend dependencies
echo ""
echo "📦 Installing frontend dependencies..."
cd src/arbitra_frontend
pnpm install --silent
cd ../..
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Confirm deployment
echo ""
echo "⚠️  You are about to deploy to IC MAINNET"
echo "This will:"
echo "  - Create 5 canisters on mainnet"
echo "  - Consume cycles for deployment"
echo "  - Make your application publicly accessible"
echo ""
read -p "Are you sure you want to proceed? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# Deploy to mainnet
echo ""
echo "🚀 Deploying to IC mainnet..."
echo "This may take 5-10 minutes..."
echo ""

dfx deploy --network ic

# Check if deployment was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 Canister IDs:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    ARBITRA_BACKEND=$(dfx canister id arbitra_backend --network ic)
    EVIDENCE_MANAGER=$(dfx canister id evidence_manager --network ic)
    AI_ANALYSIS=$(dfx canister id ai_analysis --network ic)
    BITCOIN_ESCROW=$(dfx canister id bitcoin_escrow --network ic)
    FRONTEND=$(dfx canister id arbitra_frontend --network ic)
    
    # Write Vite environment variables for frontend
    echo ""
    echo "📝 Writing frontend environment variables..."
    cat > src/arbitra_frontend/.env << ENVEOF
VITE_ARBITRA_BACKEND_CANISTER_ID=${ARBITRA_BACKEND}
VITE_EVIDENCE_MANAGER_CANISTER_ID=${EVIDENCE_MANAGER}
VITE_AI_ANALYSIS_CANISTER_ID=${AI_ANALYSIS}
VITE_BITCOIN_ESCROW_CANISTER_ID=${BITCOIN_ESCROW}
VITE_DFX_NETWORK=ic
ENVEOF
    echo "✅ Environment variables written to src/arbitra_frontend/.env"
    
    echo "arbitra_backend:    $ARBITRA_BACKEND"
    echo "evidence_manager:   $EVIDENCE_MANAGER"
    echo "ai_analysis:        $AI_ANALYSIS"
    echo "bitcoin_escrow:     $BITCOIN_ESCROW"
    echo "arbitra_frontend:   $FRONTEND"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🌐 Your application is live at:"
    echo ""
    echo -e "${GREEN}https://${FRONTEND}.icp0.io${NC}"
    echo ""
    echo "Alternative URL:"
    echo "https://${FRONTEND}.ic0.app"
    echo ""
    echo "🎉 Arbitra is now running on IC mainnet!"
    echo ""
    echo "Next steps:"
    echo "1. Open the URL in your browser"
    echo "2. Login with Internet Identity"
    echo "3. Create a test dispute to verify functionality"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "Please check the error messages above and try again."
    echo ""
    echo "Common issues:"
    echo "- Insufficient cycles: dfx cycles convert --amount=0.5 --network ic"
    echo "- Network issues: Check your internet connection"
    echo "- Identity issues: Use a secure identity"
    echo ""
    exit 1
fi
