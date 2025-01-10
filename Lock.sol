// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstateToken is ERC20, Ownable {
    // Structure for Property
    struct Property {
        string propertyId;
        string location;
        uint256 totalValue;
        uint256 totalTokens;
        bool isTokenized;
        address owner;
        uint256 availableTokens;
        string propertyDetails;
    }

    // Mappings
    mapping(string => Property) public properties;
    mapping(address => bool) public verifiedInvestors;
    mapping(string => mapping(address => uint256)) public investorTokens;

    // Events
    event PropertyTokenized(string propertyId, uint256 totalValue, uint256 totalTokens);
    event InvestorVerified(address investor);
    event Investment(string propertyId, address investor, uint256 amount);
    event PropertyDetailsUpdated(string propertyId, string newDetails);

    // Constructor
    constructor() ERC20("Real Estate Token", "RET") Ownable(msg.sender) {}

    // Modifiers
    modifier onlyVerifiedInvestor() {
        require(verifiedInvestors[msg.sender], "Not a verified investor");
        _;
    }

    modifier propertyExists(string memory propertyId) {
        require(properties[propertyId].isTokenized, "Property does not exist");
        _;
    }

    // Admin Functions
    function verifyInvestor(address investor) external onlyOwner {
        verifiedInvestors[investor] = true;
        emit InvestorVerified(investor);
    }

    function tokenizeProperty(
        string memory propertyId,
        string memory location,
        uint256 totalValue,
        uint256 totalTokens,
        string memory propertyDetails
    ) external onlyOwner {
        require(!properties[propertyId].isTokenized, "Property already tokenized");
        require(totalValue > 0, "Invalid property value");
        require(totalTokens > 0, "Invalid token amount");

        properties[propertyId] = Property({
            propertyId: propertyId,
            location: location,
            totalValue: totalValue,
            totalTokens: totalTokens,
            isTokenized: true,
            owner: msg.sender,
            availableTokens: totalTokens,
            propertyDetails: propertyDetails
        });

        emit PropertyTokenized(propertyId, totalValue, totalTokens);
    }

    function updatePropertyDetails(string memory propertyId, string memory newDetails) 
        external 
        onlyOwner 
        propertyExists(propertyId) 
    {
        properties[propertyId].propertyDetails = newDetails;
        emit PropertyDetailsUpdated(propertyId, newDetails);
    }

    // Investment Functions
    function investInProperty(string memory propertyId, uint256 tokenAmount) 
        external 
        onlyVerifiedInvestor 
        propertyExists(propertyId) 
    {
        Property storage property = properties[propertyId];
        require(tokenAmount > 0, "Invalid investment amount");
        require(tokenAmount <= property.availableTokens, "Exceeds available tokens");

        property.availableTokens -= tokenAmount;
        investorTokens[propertyId][msg.sender] += tokenAmount;
        _mint(msg.sender, tokenAmount);
        
        emit Investment(propertyId, msg.sender, tokenAmount);
    }

    // View Functions
    function getPropertyDetails(string memory propertyId) 
        external 
        view 
        propertyExists(propertyId) 
        returns (Property memory) 
    {
        return properties[propertyId];
    }

    function getInvestorTokens(string memory propertyId, address investor) 
        external 
        view 
        returns (uint256) 
    {
        return investorTokens[propertyId][investor];
    }

    function isInvestorVerified(address investor) 
        external 
        view 
        returns (bool) 
    {
        return verifiedInvestors[investor];
    }
}