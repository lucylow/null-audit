# Arbitra - Quick Start for IC Mainnet

Get Arbitra running on Internet Computer mainnet in 5 steps.

## Prerequisites

- DFX SDK installed
- Cycles for deployment (see below)
- 10-15 minutes

## Step 1: Get Cycles (FREE)

Visit the cycles faucet to get free cycles for development:

🔗 **https://internetcomputer.org/docs/current/developer-docs/setup/cycles/cycles-faucet**

Complete the verification and receive free cycles instantly.

## Step 2: Create Secure Identity

```bash
# Create a new identity
dfx identity new arbitra-mainnet

# Use the new identity
dfx identity use arbitra-mainnet

# IMPORTANT: Save your seed phrase securely!
```

## Step 3: Verify Cycles

```bash
# Check your cycles balance
dfx cycles balance --network ic
```

You should have at least **2 trillion cycles**.

## Step 4: Deploy

```bash
# Navigate to project
cd arbitra-icp

# Run the deployment script
./deploy-mainnet.sh
```

The script will:
- ✅ Check prerequisites
- ✅ Install dependencies
- ✅ Deploy all canisters
- ✅ Show your live URL

## Step 5: Access Your App

After deployment completes, you'll see:

```
🌐 Your application is live at:
https://<your-canister-id>.icp0.io
```

Open this URL and start using Arbitra!

## What You Get

✅ **5 Canisters** deployed on IC mainnet  
✅ **Permanent URL** accessible worldwide  
✅ **Full functionality** - disputes, evidence, AI analysis, escrow  
✅ **Internet Identity** authentication  
✅ **Production-ready** platform  

## Troubleshooting

### "Insufficient cycles"
```bash
dfx cycles convert --amount=0.5 --network ic
```

### "Default identity not secure"
```bash
dfx identity new my-identity
dfx identity use my-identity
```

### Need more help?
See **MAINNET_DEPLOYMENT.md** for detailed instructions.

## Cost

- **Initial deployment**: 2-3 trillion cycles
- **Monthly operation**: 0.5-1 trillion cycles
- **User transactions**: FREE (reverse gas model)

## Alternative: Convert ICP to Cycles

If you have ICP tokens:

```bash
dfx cycles convert --amount=0.5 --network ic
```

This converts 0.5 ICP to cycles.

## Support

- 📚 **Full Guide**: MAINNET_DEPLOYMENT.md
- 🌐 **DFINITY Forum**: https://forum.dfinity.org/
- 💬 **Discord**: https://discord.gg/jnjVVQaE2C

---

**Ready? Let's deploy!**

```bash
./deploy-mainnet.sh
```

🚀 Your permanent URL will be ready in 5-10 minutes!
