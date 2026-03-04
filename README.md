# Blockchain-Based-Identity-Verification-for-IT-companies



This project is a **blockchain-based employee profile and document verification system** built using **Solidity** and deployed on the **Sepolia Test Network** using **Remix IDE**.

It allows employees to create profiles, add education and work experience, upload documents, and get them verified by **HR or Universities**. Once a document is verified, the employee profile is **locked to prevent further changes**, ensuring trust and authenticity.

---

# Technologies Used

* Solidity
* Remix IDE
* Ethereum Blockchain
* Sepolia Test Network
* SHA256 (for hashing concept)
* Smart Contracts

---

# Smart Contracts

## 1. CompanyProfile Contract

This contract manages company information.

### Features

* Add new company
* Store company name, description, website
* Track company owner
* Retrieve company profile
* Check if a company exists

### Functions

**addCompany()**
Adds a new company to the blockchain.

**getCompanyProfile()**
Returns company details.

**companyExists()**
Checks whether a company exists.

**totalCompanies()**
Returns total registered companies.

---

## 2. EmployeeProfile Contract

This contract manages employee profiles and document verification.

### Features

* Create employee profile
* Add education history
* Add work experience
* Upload multiple documents
* Document verification by HR
* Document verification by Universities
* Lock profile after verification

---

# Employee Profile Structure

Each employee profile contains:

* Employee ID
* Name
* Employee wallet address
* Education details
* Work experience
* Documents
* Profile lock status

---

# Document Structure

Each document contains:

* Document name
* Company ID
* University ID
* Verification status

Documents can be verified by:

* Company HR
* Registered Universities

---

# Workflow

1. Employee creates a profile.
2. Employee adds education details.
3. Employee adds work experience.
4. Employee uploads documents.
5. HR or University verifies documents.
6. Once verified, the employee profile becomes **locked**.

---

# University Registration

Default universities are registered during contract deployment:

* University 1 – VTU
* University 2 – RV
* University 3 – SIT

The contract owner can add more universities using:

```
setUniversity()
```

---

# HR Management

The contract owner can assign HR for companies using:

```
setCompanyHR(companyId, hrAddress)
```

HR can verify documents related to their company.

---

# Deployment

The smart contracts were deployed using:

* Remix IDE
* Solidity Compiler (0.8.x)
* Injected Provider(metamask)
* Sepolia Test Network

---

# Events

The system emits events for tracking actions:

* EmployeeCreated
* EducationAdded
* WorkExperienceAdded
* DocumentsAdded
* DocumentVerified
* UniversityVerified
* ProfileLocked
* CompanyHRSet
* UniversityRegistered

---

# Security Features

* Access control using modifiers
* Only employee can modify their profile
* Only HR or owner can verify company documents
* Only authorized universities can verify university documents
* Profile locking after verification

---

# Future Improvements

* IPFS integration for document storage
* Frontend DApp using React
* Wallet authentication using MetaMask
* Better UI for companies and universities
* Multi-signature verification

# Team Members

- Member 1 – Amith A N
- Member 2 – Jaisurya N
- Member 3 – Mithun M
- Member 4 – Paartha K


