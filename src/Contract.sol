
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {
    // ====================
    // Week 2: Struct & Storage
    // ====================
    struct Campaign {
        address payable owner;
        string title;
        string description;
        uint256 goal;
        uint256 deadline;
        uint256 amountRaised;
        bool paidOut;
    }

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;

    mapping(uint256 => mapping(address => uint256)) public contributions;
    mapping(uint256 => address[]) public contributorsList;

    // ====================
    // Week 5: Events
    // ====================
    event CampaignCreated(
        uint256 indexed id,
        address indexed owner,
        string title,
        uint256 goal,
        uint256 deadline
    );

    event ContributionMade(
        uint256 indexed id,
        address indexed contributor,
        uint256 amount
    );

    event FundsWithdrawn(uint256 indexed id);
    event RefundIssued(uint256 indexed id, address indexed contributor, uint256 amount);

    // ====================
    // Week 2: Campaign Creation
    // ====================
    function createCampaign(
        string calldata _title,
        string calldata _description,
        uint256 _goal,
        uint256 _durationInDays
    ) external {
        require(_goal > 0, "Goal must be > 0");
        require(_durationInDays > 0, "Duration must be > 0");

        campaignCount++;
        uint256 deadline = block.timestamp + (_durationInDays * 1 days);

        campaigns[campaignCount] = Campaign({
            owner: payable(msg.sender),
            title: _title,
            description: _description,
            goal: _goal,
            deadline: deadline,
            amountRaised: 0,
            paidOut: false
        });

        emit CampaignCreated(campaignCount, msg.sender, _title, _goal, deadline);
    }

    // ====================
    // Week 3: Contribution Logic
    // ====================
    function contribute(uint256 _campaignId) external payable {
        Campaign storage camp = campaigns[_campaignId];
        require(block.timestamp < camp.deadline, "Campaign has ended");
        require(msg.value > 0, "Must send ETH");

        if (contributions[_campaignId][msg.sender] == 0) {
            contributorsList[_campaignId].push(msg.sender);
        }
        contributions[_campaignId][msg.sender] += msg.value;
        camp.amountRaised += msg.value;

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    // ====================
    // Week 4: Funding & Refund Logic
    // ====================
    modifier onlyOwner(uint256 _campaignId) {
        require(msg.sender == campaigns[_campaignId].owner, "Not campaign owner");
        _;
    }

    function withdrawFunds(uint256 _campaignId) external nonReentrant onlyOwner(_campaignId) {
        Campaign storage camp = campaigns[_campaignId];
        require(block.timestamp >= camp.deadline, "Campaign not ended");
        require(camp.amountRaised >= camp.goal, "Goal not met");
        require(!camp.paidOut, "Already withdrawn");

        camp.paidOut = true;
        uint256 amount = camp.amountRaised;
        (bool sent,) = camp.owner.call{value: amount}("");
        require(sent, "Transfer failed");

        emit FundsWithdrawn(_campaignId);
    }

    function refund(uint256 _campaignId) external nonReentrant {
        Campaign storage camp = campaigns[_campaignId];
        require(block.timestamp >= camp.deadline, "Campaign not ended");
        require(camp.amountRaised < camp.goal, "Goal was met");

        uint256 contributed = contributions[_campaignId][msg.sender];
        require(contributed > 0, "No contributions");

        contributions[_campaignId][msg.sender] = 0;
        (bool sent,) = payable(msg.sender).call{value: contributed}("");
        require(sent, "Refund failed");

        emit RefundIssued(_campaignId, msg.sender, contributed);
    }

    // ====================
    // Helpers
    // ====================
    function getContributors(uint256 _campaignId) external view returns (address[] memory) {
        return contributorsList[_campaignId];
    }

    function getContribution(uint256 _campaignId, address _contributor) external view returns (uint256) {
        return contributions[_campaignId][_contributor];
    }
}

