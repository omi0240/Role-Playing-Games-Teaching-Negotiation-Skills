// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RPGNegotiationGame {
    struct Player {
        string username;
        address walletAddress;
        uint256 negotiationScore;
    }

    struct Session {
        uint256 sessionId;
        string scenario;
        address[] players;
        bool isActive;
    }

    mapping(address => Player) public players;
    mapping(uint256 => Session) public sessions;

    uint256 public sessionCounter;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier playerExists(address playerAddress) {
        require(players[playerAddress].walletAddress != address(0), "Player does not exist.");
        _;
    }

    constructor() {
        owner = msg.sender;
        sessionCounter = 0;
    }

    function registerPlayer(string memory username) public {
        require(players[msg.sender].walletAddress == address(0), "Player already registered.");

        players[msg.sender] = Player({
            username: username,
            walletAddress: msg.sender,
            negotiationScore: 0
        });
    }

    function createSession(string memory scenario) public onlyOwner {
        sessionCounter++;
        sessions[sessionCounter] = Session({
            sessionId: sessionCounter,
            scenario: scenario,
            players: new address[](0),
            isActive: true
        });
    }

    function joinSession(uint256 sessionId) public playerExists(msg.sender) {
        require(sessions[sessionId].isActive, "Session is not active.");

        sessions[sessionId].players.push(msg.sender);
    }

    function updateScore(address playerAddress, uint256 score) public onlyOwner playerExists(playerAddress) {
        players[playerAddress].negotiationScore += score;
    }

    function endSession(uint256 sessionId) public onlyOwner {
        require(sessions[sessionId].isActive, "Session is already ended.");

        sessions[sessionId].isActive = false;
    }

    function getSessionPlayers(uint256 sessionId) public view returns (address[] memory) {
        return sessions[sessionId].players;
    }

    function getPlayerDetails(address playerAddress) public view returns (Player memory) {
        return players[playerAddress];
    }
}


