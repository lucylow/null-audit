# Arbitra - IC Mainnet Deployment Guide

Complete step-by-step guide to deploy Arbitra to the Internet Computer mainnet.

## Prerequisites

Before deploying to mainnet, ensure you have:

1. **DFX SDK** installed (version 0.29.2 or higher)
2. **Cycles** for canister creation and deployment
3. **Secure Identity** (not the default plaintext identity)

## Step 1: Get Cycles

You need cycles to deploy canisters to IC mainnet. Here are your options:

### Option A: Cycles Faucet (Free for Developers)
1. Visit: https://internetcomputer.org/docs/current/developer-docs/setup/cycles/cycles-faucet
2. Complete the verification process
3. Receive free cycles for development

### Option B: Convert ICP to Cycles
```bash
# Convert 0.5 ICP to cycles (adjust amount as needed)
dfx cycles convert --amount=0.5 --network ic
```

### Option C: Use NNS Dapp
1. Visit: https://nns.ic0.app/
2. Purchase cycles through the NNS interface

## Step 2: Create a Secure Identity

**IMPORTANT**: Never use the default identity for mainnet deployments.

```bash
# Create a new secure identity
dfx identity new arbitra-mainnet

# Use the new identity
dfx identity use arbitra-mainnet

# Verify you're using the correct identity
dfx identity whoami
```

**Save your seed phrase securely!** You'll need it to recover your identity.

## Step 3: Verify Cycles Balance

```bash
# Check your cycles balance
dfx cycles balance --network ic
```

You should have at least **2-3 trillion cycles** for deploying all 5 canisters (4 backend + 1 frontend).

## Step 4: Prepare the Project

```bash
# Navigate to project directory
cd arbitra-icp

# Install frontend dependencies
cd src/arbitra_frontend
pnpm install
cd ../..
```

## Step 5: Deploy to Mainnet

```bash
# Deploy all canisters to IC mainnet
dfx deploy --network ic
```

This command will:
1. Create 5 canisters on mainnet
2. Build all Motoko backend canisters
3. Build the React frontend
4. Deploy everything to IC mainnet

**Expected Duration**: 5-10 minutes

## Step 6: Get Your Canister IDs

After successful deployment, get your canister IDs:

```bash
# Get all canister IDs
dfx canister id arbitra_backend --network ic
dfx canister id evidence_manager --network ic
dfx canister id ai_analysis --network ic
dfx canister id bitcoin_escrow --network ic
dfx canister id arbitra_frontend --network ic
```

## Step 7: Access Your Live Application

Your application will be accessible at:

```
https://<frontend-canister-id>.icp0.io
```

Or alternatively:

```
https://<frontend-canister-id>.ic0.app
```

Replace `<frontend-canister-id>` with your actual frontend canister ID.

## Step 8: Verify Deployment

Test your deployment:

1. **Open the URL** in your browser
2. **Login** with Internet Identity
3. **Create a test dispute** to verify functionality
4. **Check backend communication** by viewing disputes

## Troubleshooting

### Issue: "Insufficient cycles balance"

**Solution**: Top up your cycles balance

```bash
dfx cycles convert --amount=1.0 --network ic
```

### Issue: "The default identity is not stored securely"

**Solution**: Create and use a secure identity

```bash
dfx identity new my-secure-identity
dfx identity use my-secure-identity
dfx deploy --network ic
```

### Issue: "Canister not found" after deployment

**Solution**: Wait a few minutes for DNS propagation, then try accessing the URL again.

### Issue: Frontend shows but backend calls fail

**Solution**: Verify all canisters are deployed

```bash
dfx canister status arbitra_backend --network ic
dfx canister status evidence_manager --network ic
dfx canister status ai_analysis --network ic
dfx canister status bitcoin_escrow --network ic
```

## Managing Your Mainnet Deployment

### Check Canister Status

```bash
dfx canister status arbitra_backend --network ic
```

### View Canister Logs

```bash
dfx canister logs arbitra_backend --network ic
```

### Top Up Cycles for a Canister

```bash
dfx canister deposit-cycles 1000000000000 arbitra_backend --network ic
```

### Update a Canister

```bash
# After making code changes
dfx deploy arbitra_backend --network ic
```

## Cost Estimation

Approximate cycles needed:

- **Initial Deployment**: 2-3 trillion cycles
- **Monthly Operation**: 0.5-1 trillion cycles (depends on usage)
- **Per Transaction**: Minimal (ICP's reverse gas model)

## Security Best Practices

1. ✅ **Use a secure identity** with password protection
2. ✅ **Save your seed phrase** in a secure location
3. ✅ **Never commit** identity files to version control
4. ✅ **Monitor cycles balance** regularly
5. ✅ **Test on local replica** before mainnet deployment
6. ✅ **Audit smart contracts** before production use

## Mainnet vs Local Development

| Feature | Local | Mainnet |
|---------|-------|---------|
| Cost | Free | Requires cycles |
| Speed | Instant | 5-10 min deployment |
| Persistence | Temporary | Permanent |
| URL | localhost:4943 | .icp0.io / .ic0.app |
| Identity | Default OK | Secure required |

## Post-Deployment Checklist

- [ ] All 5 canisters deployed successfully
- [ ] Frontend accessible via public URL
- [ ] Internet Identity login works
- [ ] Can create disputes
- [ ] Can view disputes
- [ ] Backend canisters responding
- [ ] Cycles balance monitored
- [ ] Canister IDs documented

## Updating Your Deployment

To update your mainnet deployment after code changes:

```bash
# Build and deploy updates
dfx deploy --network ic

# Or update specific canister
dfx deploy arbitra_backend --network ic
```

## Monitoring and Maintenance

### Set Up Monitoring

1. **Cycles Monitoring**: Check balance weekly
2. **Error Logs**: Review canister logs regularly
3. **Performance**: Monitor response times

### Backup Your Identity

```bash
# Export your identity
dfx identity export arbitra-mainnet > arbitra-mainnet-identity.pem

# Store securely offline
```

## Getting Help

- **DFINITY Forum**: https://forum.dfinity.org/
- **Discord**: https://discord.gg/jnjVVQaE2C
- **Documentation**: https://internetcomputer.org/docs

## Quick Reference Commands

```bash
# Deploy to mainnet
dfx deploy --network ic

# Check cycles
dfx cycles balance --network ic

# Get canister ID
dfx canister id <canister-name> --network ic

# Check status
dfx canister status <canister-name> --network ic

# View logs
dfx canister logs <canister-name> --network ic

# Top up cycles
dfx canister deposit-cycles <amount> <canister-name> --network ic
```

## Success Criteria

Your deployment is successful when:

✅ All 5 canisters show "Running" status  
✅ Frontend loads at public URL  
✅ Internet Identity authentication works  
✅ Can create and view disputes  
✅ All backend calls succeed  
✅ No console errors in browser  

---

## Ready to Deploy?

Once you have cycles and a secure identity:

```bash
cd arbitra-icp
dfx identity use arbitra-mainnet
dfx deploy --network ic
```

Your permanent URL will be:
```
https://<your-frontend-canister-id>.icp0.io
```

**Good luck with your deployment!** 🚀

---

*For LegalHack 2025 | Built on Internet Computer Protocol* ⚖️
