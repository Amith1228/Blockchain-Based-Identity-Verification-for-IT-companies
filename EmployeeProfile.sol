// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeProfile {
    address public owner;

    constructor() {
        owner = msg.sender;

        // Register default universities at deployment (dummy addresses for now)
        universities[1] = 0x1111111111111111111111111111111111111111; // VTU
        universities[2] = 0x2222222222222222222222222222222222222222; // RV
        universities[3] = 0x3333333333333333333333333333333333333333; // SIT

        emit UniversityRegistered(1, universities[1]);
        emit UniversityRegistered(2, universities[2]);
        emit UniversityRegistered(3, universities[3]);
    }

    // ==============================
    // Events
    // ==============================
    event EmployeeCreated(uint256 indexed employeeId, string name, address employeeAddress);
    event EducationAdded(uint256 indexed employeeId, string institution, string degree);
    event WorkExperienceAdded(uint256 indexed employeeId, string company, string role);
    event DocumentsAdded(uint256 indexed employeeId, string[] documentNames);
    event DocumentVerified(uint256 indexed employeeId, uint256 indexed docIndex, bool status);
    event UniversityVerified(uint256 indexed empId, uint256 indexed docIndex, bool status);
    event ProfileLocked(uint256 indexed employeeId);
    event CompanyHRSet(uint256 indexed companyId, address hrAddress);
    event UniversityRegistered(uint256 indexed universityId, address universityAddress);

    // ==============================
    // Structs
    // ==============================
    struct Education {
        string institutionName;
        string degree;
        uint256 startYear;
        uint256 endYear;
    }

    struct WorkExperience {
        string companyName;
        string role;
        uint256 startYear;
        uint256 endYear;
    }

    struct Document {
        string documentName;
        uint256 companyId;
        uint256 universityId; // ✅ university assigned
        bool isVerified;
    }

    struct Employee {
        uint256 employeeId;
        string name;
        Education[] educationProfiles;
        WorkExperience[] workExperiences;
        Document[] documents;
        address employeeAddress;
        bool isLocked;
    }

    // ==============================
    // Storage
    // ==============================
    mapping(uint256 => Employee) private employees;
    uint256[] private employeeIndex;

    mapping(uint256 => address) private companyHR;
    mapping(uint256 => address) private universities; // ✅ universities mapping

    // ==============================
    // Modifiers
    // ==============================
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyEmployee(uint256 empId) {
        require(msg.sender == employees[empId].employeeAddress, "Not employee");
        _;
    }

    modifier onlyHRorOwner(uint256 empId, uint256 docIndex) {
        uint256 companyId = employees[empId].documents[docIndex].companyId;
        require(
            msg.sender == owner || msg.sender == companyHR[companyId],
            "Not HR/Owner"
        );
        _;
    }

    modifier onlyUniversity(uint256 empId, uint256 docIndex) {
        uint256 universityId = employees[empId].documents[docIndex].universityId;
        require(msg.sender == universities[universityId], "Not authorized university");
        _;
    }

    modifier notLocked(uint256 empId) {
        require(!employees[empId].isLocked, "Profile locked by HR/University");
        _;
    }

    // ==============================
    // Employee Creation
    // ==============================
    function createEmployee(uint256 empId, string calldata name) external {
        require(bytes(employees[empId].name).length == 0, "Employee exists");

        Employee storage emp = employees[empId];
        emp.employeeId = empId;
        emp.name = name;
        emp.employeeAddress = msg.sender;
        emp.isLocked = false;

        employeeIndex.push(empId);

        emit EmployeeCreated(empId, name, msg.sender);
    }

    // ==============================
    // Getter Functions
    // ==============================
    function getEmployeeId(uint256 empId) external view returns (uint256, string memory) {
        Employee storage emp = employees[empId];
        require(bytes(emp.name).length > 0, "Employee not found");
        return (emp.employeeId, emp.name);
    }

    function getTotalEmployees() external view returns (uint256) {
        return employeeIndex.length;
    }

    function getAllEmployees() external view onlyOwner returns (uint256[] memory, string[] memory) {
        uint256 total = employeeIndex.length;
        uint256[] memory ids = new uint256[](total);
        string[] memory names = new string[](total);

        for (uint256 i = 0; i < total; i++) {
            uint256 empId = employeeIndex[i];
            ids[i] = empId;
            names[i] = employees[empId].name;
        }
        return (ids, names);
    }

    // ==============================
    // University Controls
    // ==============================
    function setUniversity(uint256 universityId, address universityAddress) external onlyOwner {
        universities[universityId] = universityAddress;
        emit UniversityRegistered(universityId, universityAddress);
    }

    function getUniversity(uint256 universityId) external view returns (address) {
        return universities[universityId];
    }

    // ==============================
    // Education
    // ==============================
    function addEducation(
        uint256 empId,
        string calldata institutionName,
        string calldata degree,
        uint256 startYear,
        uint256 endYear
    ) external onlyEmployee(empId) notLocked(empId) {
        employees[empId].educationProfiles.push(
            Education(institutionName, degree, startYear, endYear)
        );

        emit EducationAdded(empId, institutionName, degree);
    }

    // ==============================
    // Work Experience
    // ==============================
    function addWorkExperience(
        uint256 empId,
        string calldata companyName,
        string calldata role,
        uint256 startYear,
        uint256 endYear
    ) external onlyEmployee(empId) notLocked(empId) {
        employees[empId].workExperiences.push(
            WorkExperience(companyName, role, startYear, endYear)
        );

        emit WorkExperienceAdded(empId, companyName, role);
    }

    // ==============================
    // Documents
    // ==============================
    function addMultipleDocuments(
        uint256 empId,
        string[] calldata docNames,
        uint256[] calldata companyIds,
        uint256[] calldata universityIds
    ) external onlyEmployee(empId) notLocked(empId) {
        require(
            docNames.length == companyIds.length && docNames.length == universityIds.length,
            "Array length mismatch"
        );

        for (uint256 i = 0; i < docNames.length; i++) {
            employees[empId].documents.push(
                Document(docNames[i], companyIds[i], universityIds[i], false)
            );
        }

        emit DocumentsAdded(empId, docNames);
    }

    function verifyDocument(uint256 empId, uint256 docIndex, bool status) external onlyHRorOwner(empId, docIndex) {
        require(docIndex < employees[empId].documents.length, "Invalid index");

        employees[empId].documents[docIndex].isVerified = status;

        emit DocumentVerified(empId, docIndex, status);

        if (!employees[empId].isLocked) {
            employees[empId].isLocked = true;
            emit ProfileLocked(empId);
        }
    }

    function verifyUniversityDocument(uint256 empId, uint256 docIndex, bool status) 
        external 
        onlyUniversity(empId, docIndex) 
    {
        require(docIndex < employees[empId].documents.length, "Invalid index");

        employees[empId].documents[docIndex].isVerified = status;

        emit UniversityVerified(empId, docIndex, status);

        if (!employees[empId].isLocked) {
            employees[empId].isLocked = true;
            emit ProfileLocked(empId);
        }
    }

    // ==============================
    // Document Verification Check
    // ==============================
    function isDocumentVerified(uint256 empId, uint256 docIndex) external view returns (bool) {
        require(docIndex < employees[empId].documents.length, "Invalid index");
        return employees[empId].documents[docIndex].isVerified;
    }

    function getAllDocumentsStatus(uint256 empId)
        external
        view
        returns (string[] memory docNames, bool[] memory statuses)
    {
        Employee storage emp = employees[empId];
        uint256 docLen = emp.documents.length;

        docNames = new string[](docLen);
        statuses = new bool[](docLen);

        for (uint256 i = 0; i < docLen; i++) {
            docNames[i] = emp.documents[i].documentName;
            statuses[i] = emp.documents[i].isVerified;
        }
    }

    // ==============================
    // HR Controls
    // ==============================
    function setCompanyHR(uint256 companyId, address hr) external onlyOwner {
        companyHR[companyId] = hr;
        emit CompanyHRSet(companyId, hr);
    }

    function getCompanyHR(uint256 companyId) external view returns (address) {
        return companyHR[companyId];
    }
}
