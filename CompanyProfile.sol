// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CompanyProfile {
    struct Company {
        string name;
        string description;
        string website;
        address owner;
    }

    uint256 private companyCounter = 0;
    mapping(uint256 => Company) private companies;

    event CompanyAdded(uint256 companyId, string name, address owner);

    // Add a new company
    function addCompany(string calldata _name, string calldata _description, string calldata _website) public {
        companies[companyCounter] = Company({
            name: _name,
            description: _description,
            website: _website,
            owner: msg.sender
        });

        emit CompanyAdded(companyCounter, _name, msg.sender);
        companyCounter++;
    }

    // Get company profile
    function getCompanyProfile(uint256 companyId) public view returns (string memory, string memory, string memory, address) {
        Company storage c = companies[companyId];
        return (c.name, c.description, c.website, c.owner);
    }

    // Check if a company exists
    function companyExists(uint256 companyId) public view returns (bool) {
        return companyId < companyCounter;
    }

    // Total number of companies
    function totalCompanies() public view returns (uint256) {
        return companyCounter;
    }
}
