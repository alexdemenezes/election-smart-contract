// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Election {
  struct CandidateInfo {
    uint id;
    uint age;
    string fullName;
    uint votes;
  }

  address public manager = msg.sender;

  mapping(uint => CandidateInfo) candidates;

  CandidateInfo[] public candidatesVotes;

  mapping(address => bool) voters;

  modifier restricted {
    require(msg.sender == manager);
    _;
  }

  function registerCandidate(uint _age, string memory _fullName) public restricted {
    uint id = candidatesVotes.length + 1;
    CandidateInfo storage newCandidate = candidates[id];
    newCandidate.id = id;
    newCandidate.age = _age;
    newCandidate.fullName = _fullName;
    newCandidate.votes = 0;
    candidatesVotes.push(newCandidate);
  }

  function vote(uint _id) public {
    require(voters[msg.sender] == false, "you already voted.");
    uint id = _id - 1;
    candidatesVotes[id].votes += 1;
    voters[msg.sender] == true;
  }

  function showWinner() public restricted view returns(string memory) {
    uint winner = 0;
    for(uint i = 0; i < candidatesVotes.length; i++) {
      uint winningVoteCount = 0;
      if (candidatesVotes[i].votes < winningVoteCount) {
        winningVoteCount = candidatesVotes[i].votes;
        winner = i;
      }
      return candidatesVotes[winner].fullName;
    }
  } 

}