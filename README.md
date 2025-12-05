<p align="center">
  <img src="client/public/images/nullaudit-banner.png" alt="NullAudit Banner" width="100%"/>
</p>

<h1 align="center">NullAudit</h1>

<p align="center">
  <strong>Deterministic, attested AI audits & agent orchestration</strong>
</p>

<p align="center">
  <a href="#features"><img src="https://img.shields.io/badge/AI_Powered-Multi_LLM-00d4ff?style=for-the-badge&logo=openai&logoColor=white" alt="AI Powered"/></a>
  <a href="#architecture"><img src="https://img.shields.io/badge/Web3-Attestation-8b5cf6?style=for-the-badge&logo=ethereum&logoColor=white" alt="Web3"/></a>
  <a href="#quickstart"><img src="https://img.shields.io/badge/Edge-Ready-10b981?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Edge Ready"/></a>
  <a href="#license"><img src="https://img.shields.io/badge/License-MIT-f59e0b?style=for-the-badge" alt="License"/></a>
</p>

<p align="center">
  Multi-LLM agent pipeline with canonical envelopes, attestation anchoring, MCP tooling, and optional on-chain verification.<br/>
  Reproducible AI-driven audits with auditable outputs and Web3 attestation.
</p>

---

## Dashboard Preview

<p align="center">
  <img src="client/public/images/dashboard-preview.png" alt="NullAudit Dashboard" width="100%" style="border-radius: 8px;"/>
</p>

---

## Features

| Feature | Description |
|---------|-------------|
| 🔒 **Deterministic Audits** | Canonicalizes inputs into reproducible `input_hash` |
| 🤖 **Multi-LLM Ensemble** | Runs multiple AI models for consensus-based findings |
| ⛓️ **On-Chain Attestation** | Merkleized findings anchored to blockchain |
| 🔧 **MCP Tooling** | Model Context Protocol integration for tool orchestration |
| 👥 **Human-in-the-Loop** | HITL gating for critical decisions |
| 📊 **Security Scoring** | Automated severity classification and scoring |

---

## Table of Contents

- [Architecture](#architecture-high-level)
- [Core Concepts](#core-concepts--data-contracts)
- [Repository Layout](#repository-layout)
- [Quickstart](#quickstart--local-development)
- [Deployment](#run-on-lovable--supabase--workers)
- [MCP Integration](#mcp--durable-object-integration)
- [Attestation Flow](#attestation-flow--smart-contract-interface)
- [Analytics & Billing](#analytics-monitoring--billing-stripe)
- [CI/CD](#ci--cd-example-github-actions)
- [Testing](#testing-and-verification)
- [Security](#security--ops-checklist)
- [Contributing](#contributing)
- [License](#license)

---

## Architecture (high-level)

```mermaid
flowchart LR
  subgraph INPUT
    A[repo/, bytecode/, manifests/, logs] --> Canon[Canonicalizer]
  end

  Canon --> EvidenceStore[Evidence Store (IPFS/Arweave)]
  Canon --> Scanners[Static & Dynamic Scanners]
  Scanners --> SigGen[Snippet Fingerprints / Rule Hits]
  SigGen --> LLMMesh[LLM Adapter Mesh]
  EvidenceStore --> LLMMesh

  LLMMesh --> Normalizer
  Normalizer --> ConsensusEngine
  Scanners --> ConsensusEngine
  ConsensusEngine --> PolicyEngine[Policy / Guardrails]
  PolicyEngine --> Reporter[Report Builder / AuditBundle]
  Reporter --> Merkleizer[Merkle leaf builder]
  Merkleizer --> Attestor[Attestation Engine]
  Attestor --> MCPTool[mint_attestation (MCP)]
  Attestor -->|attestationId| Blockchain[AttestationAnchor.sol / On-chain]

  Blockchain --> Consumers[CI/CD | Governance | Bridges]
```

---

## Core concepts & data contracts

### InvocationEnvelope (what we send to tools/LLMs)

```json
{
  "id": "uuid-v4",
  "caller": "SupervisorAgent",
  "tool_id": "llm:gpt-4-code",
  "action": "analyze",
  "prompt_template_id": "security-audit-v1",
  "input_hash": "0xabc123...",
  "evidence_refs": ["cid:Qm..."],
  "inputs": { "filePath": "contracts/Bridge.sol", "lineRange": [1, 400] },
  "capability_token": "macaroon-or-jwt",
  "ts": 1712345678
}
```

### ResponseEnvelope (tool responses)

```json
{
  "invocation_id": "uuid-v4",
  "success": true,
  "payload": {
    "findings": [
      { "id":"f1","finding":"reentrancy risk","severity":3,"evidence_ref":"cid:..." }
    ]
  },
  "compute_receipt": { "cost_units": 2.3, "provider_raw": {...} },
  "sig": "base64-provider-signature",
  "ts": 1712345690
}
```

### ConsensusReport

```json
{
  "report_id": "uuid",
  "score": 67,
  "severity_vector": { "reentrancy": 0.8, "access_control": 0.2 },
  "evidence_weight": 0.85,
  "leaf_refs": ["cid:...", "cid:..."]
}
```

---

## Repository layout

```
/
├─ contracts/                   # Solidity attestation contract(s)
│  ├─ AttestationAnchor.sol
│  └─ NullshotCore.sol
├─ client/                      # Frontend React application
│  ├─ src/
│  │  ├─ components/            # UI components
│  │  ├─ pages/                 # Page components
│  │  └─ contexts/              # React contexts
├─ server/                      # Backend Express server
│  ├─ routes/                   # API routes
│  ├─ services/                 # Business logic
│  └─ middleware/               # Express middleware
├─ shared/                      # Shared types and utilities
├─ supabase/                    # Supabase configuration
└─ README.md
```

---

## Quickstart — Local development

> **Prerequisites:** Node >=18, npm/pnpm

### 1. Clone & Install

```bash
git clone https://github.com/lucylow/arbita-blank-canvas.git
cd arbita-blank-canvas
npm install
```

### 2. Environment Setup

Create `.env.local`:

```env
# AI provider
AI_PROVIDER=openai
AI_PROVIDER_API_KEY=sk-...

# MCP
MCP_SERVER_URL=http://localhost:3000

# Optional: Stripe
STRIPE_SECRET_KEY=sk_live_...
```

### 3. Run Development Server

```bash
npm run dev
```

---

## Run on Lovable / Supabase / Workers

This repo is architected for edge platforms:

- **Lovable Cloud**: Full-stack deployment with Supabase backend
- **Cloudflare Workers**: Durable Objects for session & MCP servers
- **Docker**: Containerized deployment option

**Configuration Notes:**

- Store API keys in environment secrets
- Configure bindings for `ANALYTICS`, `MEMORY_STORE`, and `STREAM`

---

## MCP & Durable Object integration

### Demo Client Example

```js
import fetch from 'node-fetch';
import crypto from 'crypto';

const MCP_URL = process.env.MCP_SERVER_URL || 'http://localhost:3000';

async function mintAttestation(merkleRoot, reportCID, score) {
  const body = { merkleRoot, reportCID, score, signer: 'demo-signer' };
  const res = await fetch(`${MCP_URL}/mcp/tool/mint_attestation`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });
  return res.json();
}
```

---

## Attestation flow & Smart contract interface

### Attestor Workflow

1. Build AuditBundle JSON
2. Create leaf per finding: `sha256(JSON.stringify(findingEnvelope))`
3. Build Merkle tree → `merkleRoot`
4. Pin AuditBundle to IPFS/Arweave → `reportCID`
5. Call `mint_attestation` MCP tool
6. Optionally anchor on-chain via `AttestationAnchor.sol`

### Solidity Interface

```solidity
interface IAttestationAnchor {
    event Anchored(bytes32 root, uint256 anchorId, uint256 blockNumber);
    function anchor(bytes32 merkleRoot, uint256 blockNumber, bytes calldata signerSigs) external returns (uint256 anchorId);
    function getAnchor(uint256 anchorId) external view returns (bytes32 root, uint256 blockNumber, bytes memory signerSigs);
}
```

---

## Analytics, monitoring & billing (Stripe)

- Time-series metrics: `agent_metrics`, `billing_events`, `user_satisfaction`
- Key metrics: `processing_time_ms`, `tokens_consumed`, `compute_cost`
- Usage-based billing via Stripe metered subscriptions

---

## CI / CD (example GitHub Actions)

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm test
```

---

## Testing and verification

```bash
npm run test            # Unit tests
npm run test:integration
npm run lint
```

---

## Security & Ops checklist

- ✅ Secrets in secure managers (never in code)
- ✅ Short TTL capability tokens with least-privilege
- ✅ Prompt templates versioned and anchored
- ✅ HSM/KMS for attestation signing
- ✅ Circuit-breakers for cost thresholds
- ✅ Two independent audits before production

---

## Contributing

Contributions welcome! Please:

1. Follow repo linting rules
2. Add unit tests
3. Update README for public API changes

```bash
git checkout -b feat/your-feature
npm test && npm run lint
git commit -m "feat: ..." && git push
```

---

## License

MIT © NullAudit / Lucy Low

---

<p align="center">
  <sub>Built with ❤️ using React, TypeScript, and Web3</sub>
</p>
