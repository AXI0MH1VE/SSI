# Finance Vertical API Integration Kit

## Overview

This integration kit provides developers with comprehensive guidance for integrating the Finance SSI vertical into financial services applications. The kit includes authentication setup, credential operations, verification workflows, and compliance reporting.

---

## Authentication

### API Key Setup

1. Obtain your API key from the SSI Portal
2. Store securely in environment variables or secrets manager
3. Include in all API requests via `Authorization` header

```bash
export SSI_API_KEY="your-api-key-here"
export SSI_ENDPOINT="https://api.ssi.axiomhive.com/v1/finance"
```

### Authentication Example

```bash
curl -X GET "$SSI_ENDPOINT/health" \
  -H "Authorization: Bearer $SSI_API_KEY" \
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "vertical": "finance",
  "timestamp": "2025-10-11T03:59:00Z"
}
```

---

## Credential Issuance

### Issue Customer Identity Credential

**Endpoint:** `POST /credentials/issue`

**Request Body:**
```json
{
  "credentialType": "CustomerIdentity",
  "subject": {
    "did": "did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK",
    "personalInfo": {
      "legalName": {
        "firstName": "Jane",
        "lastName": "Smith"
      },
      "dateOfBirth": "1985-03-15",
      "address": {
        "streetAddress": "123 Main St",
        "city": "New York",
        "state": "NY",
        "postalCode": "10001",
        "country": "US"
      },
      "contactInfo": {
        "email": "jane.smith@example.com",
        "phoneNumber": "+12125551234"
      }
    },
    "verificationStatus": {
      "kycStatus": "verified",
      "amlStatus": "cleared",
      "verificationLevel": "enhanced",
      "verifiedAt": "2025-10-11T03:45:00Z",
      "riskRating": "low"
    }
  },
  "issuer": {
    "institutionName": "Acme Bank",
    "institutionDID": "did:web:acmebank.com",
    "institutionType": "bank"
  }
}
```

**cURL Example:**
```bash
curl -X POST "$SSI_ENDPOINT/credentials/issue" \
  -H "Authorization: Bearer $SSI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @customer-identity.json
```

**Response:**
```json
{
  "credentialId": "urn:uuid:12345678-1234-5678-1234-567812345678",
  "status": "issued",
  "credential": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://schemas.axiomhive.com/ssi/finance/v1"
    ],
    "type": ["VerifiableCredential", "FinancialIdentityCredential"],
    "issuer": "did:web:acmebank.com",
    "issuanceDate": "2025-10-11T03:59:00Z",
    "credentialSubject": { ... },
    "proof": {
      "type": "Ed25519Signature2020",
      "created": "2025-10-11T03:59:00Z",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:web:acmebank.com#key-1",
      "jws": "eyJhbGciOiJFZERTQSIsImI2NCI6ZmFsc2UsImNyaXQiOlsiYjY0Il19..."
    }
  }
}
```

---

## Credential Verification

### Verify Credential

**Endpoint:** `POST /credentials/verify`

**Request:**
```json
{
  "credential": {
    "@context": [...],
    "type": ["VerifiableCredential", "FinancialIdentityCredential"],
    "issuer": "did:web:acmebank.com",
    "credentialSubject": { ... },
    "proof": { ... }
  },
  "verificationOptions": {
    "checkRevocation": true,
    "checkExpiration": true,
    "trustedIssuers": ["did:web:acmebank.com"]
  }
}
```

**cURL Example:**
```bash
curl -X POST "$SSI_ENDPOINT/credentials/verify" \
  -H "Authorization: Bearer $SSI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @verify-request.json
```

**Response:**
```json
{
  "verified": true,
  "checks": {
    "signatureValid": true,
    "notRevoked": true,
    "notExpired": true,
    "issuerTrusted": true
  },
  "details": {
    "verificationLevel": "enhanced",
    "kycStatus": "verified",
    "amlStatus": "cleared",
    "riskRating": "low"
  },
  "timestamp": "2025-10-11T04:00:00Z"
}
```

---

## Credential Revocation

### Revoke Credential

**Endpoint:** `POST /credentials/revoke`

**Request:**
```json
{
  "credentialId": "urn:uuid:12345678-1234-5678-1234-567812345678",
  "reason": "account_closed",
  "effectiveDate": "2025-10-11T04:00:00Z"
}
```

**cURL Example:**
```bash
curl -X POST "$SSI_ENDPOINT/credentials/revoke" \
  -H "Authorization: Bearer $SSI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"credentialId": "urn:uuid:12345678...", "reason": "account_closed"}'
```

**Response:**
```json
{
  "revoked": true,
  "credentialId": "urn:uuid:12345678-1234-5678-1234-567812345678",
  "revokedAt": "2025-10-11T04:00:00Z",
  "reason": "account_closed"
}
```

---

## Compliance Reporting

### Generate Audit Report

**Endpoint:** `GET /compliance/audit-report`

**Query Parameters:**
- `startDate`: ISO 8601 date (e.g., `2025-10-01`)
- `endDate`: ISO 8601 date (e.g., `2025-10-11`)
- `format`: `json` or `csv`

**cURL Example:**
```bash
curl -X GET "$SSI_ENDPOINT/compliance/audit-report?startDate=2025-10-01&endDate=2025-10-11&format=json" \
  -H "Authorization: Bearer $SSI_API_KEY"
```

**Response:**
```json
{
  "reportId": "audit-2025-10-11",
  "period": {
    "start": "2025-10-01T00:00:00Z",
    "end": "2025-10-11T23:59:59Z"
  },
  "summary": {
    "credentialsIssued": 1247,
    "credentialsVerified": 8932,
    "credentialsRevoked": 23,
    "failedVerifications": 15
  },
  "complianceMetrics": {
    "kycVerifications": 1247,
    "amlScreenings": 1247,
    "highRiskFlags": 3
  }
}
```

---

## Error Handling

### Standard Error Response

```json
{
  "error": {
    "code": "INVALID_CREDENTIAL",
    "message": "Credential signature verification failed",
    "details": {
      "field": "proof.jws",
      "reason": "Invalid signature format"
    },
    "timestamp": "2025-10-11T04:00:00Z",
    "requestId": "req-12345678"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `INVALID_API_KEY` | 401 | API key is missing or invalid |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INVALID_CREDENTIAL` | 400 | Credential format or content is invalid |
| `ISSUER_NOT_TRUSTED` | 403 | Issuer is not in trusted list |
| `CREDENTIAL_REVOKED` | 410 | Credential has been revoked |
| `INTERNAL_ERROR` | 500 | Server-side error |

---

## SDK Support

### JavaScript/TypeScript

```typescript
import { FinanceSSIClient } from '@axiomhive/ssi-finance-sdk';

const client = new FinanceSSIClient({
  apiKey: process.env.SSI_API_KEY,
  endpoint: 'https://api.ssi.axiomhive.com/v1/finance'
});

// Issue credential
const credential = await client.credentials.issue({
  credentialType: 'CustomerIdentity',
  subject: { ... }
});

// Verify credential
const result = await client.credentials.verify(credential);
```

### Python

```python
from axiomhive_ssi import FinanceSSIClient

client = FinanceSSIClient(
    api_key=os.environ['SSI_API_KEY'],
    endpoint='https://api.ssi.axiomhive.com/v1/finance'
)

# Issue credential
credential = client.credentials.issue(
    credential_type='CustomerIdentity',
    subject={...}
)

# Verify credential
result = client.credentials.verify(credential)
```

---

## Rate Limits

| Tier | Requests/Minute | Concurrent Requests |
|------|-----------------|---------------------|
| Standard | 100 | 10 |
| Premium | 1,000 | 50 |
| Enterprise | Unlimited | Unlimited |

---

## Support

- **API Documentation**: https://docs.axiomhive.com/ssi/finance/api
- **Technical Support**: support@axiomhive.com
- **Status Page**: https://status.axiomhive.com
- **GitHub Issues**: https://github.com/AXI0MH1VE/SSI/issues

---

## Change Log

### Version 1.0.0 (2025-10-11)
- Initial production release
- Customer Identity credential support
- Account Holder credential support
- Accredited Investor credential support
- Transaction Authorization credential support
- Full compliance reporting suite
