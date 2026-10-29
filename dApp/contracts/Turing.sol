//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

// This is the main building block for smart contracts.
contract Turing {
    string public name = "Turing";
    string public symbol = "TTK";
    string public professora = 'roberta';
    bool public voting = true;

    address public owner;

    mapping(address => uint256) balances;
    mapping(string => address) users;
    mapping(address => string) codinomeOf;
    mapping(address => mapping(address => bool)) alreadyVote;
    mapping(address => uint256) qtdVotos;

    constructor() {
        owner = msg.sender;
        users['roberta'] = 0x502542668aF09fa7aea52174b9965A7799343Df7;
        users['nome1'] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        users['nome2'] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        users['nome3'] = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
        users['nome4'] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
        users['nome5'] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;

        codinomeOf[0x502542668aF09fa7aea52174b9965A7799343Df7] = 'roberta';
        codinomeOf[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 'nome1';
        codinomeOf[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = 'nome2';
        codinomeOf[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 'nome3';
        codinomeOf[0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65] = 'nome4';
        codinomeOf[0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc] = 'nome5';

        qtdVotos[0x502542668aF09fa7aea52174b9965A7799343Df7] = 0;
        qtdVotos[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 0;
        qtdVotos[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = 0;
        qtdVotos[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 0;
        qtdVotos[0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65] = 0;
        qtdVotos[0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc] = 0;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    modifier onlyOwner {
        require(msg.sender == users[professora] || msg.sender == owner, "Voce nao eh o dono ou a Roberta");
        _;
    }

    function _setUser(string memory codinome, address addr) internal {
        address old = users[codinome];
        if (old != address(0)) delete codinomeOf[old];
        users[codinome] = addr;
        codinomeOf[addr] = codinome;
    }

    function updateUser(string memory codinome, address user_addr) onlyOwner external {
        require(bytes(codinome).length > 0, "Codinome nao pode ser vazio");

        _setUser(codinome, user_addr);
    }

    function votingOn() onlyOwner external {
        voting = true;
    }

    function votinOff() onlyOwner external {
        voting = false;
    }

    function issueToken(string memory codinome , uint256 qtde_de_Turings) onlyOwner external {
        balances[users[codinome]] = balances[users[codinome]] + qtde_de_Turings;
    }

    function vote(string memory codinome, uint256 qtde_de_Turings) external {
        require(voting, 'Votacao nao esta ativa');
        require(bytes(codinomeOf[msg.sender]).length > 0, "Voce nao eh autorizado");
        require(users[codinome] != msg.sender, "Voce nao pode votar em si mesmo");
        require(qtde_de_Turings > 0 || qtde_de_Turings <= 2, "Voce so pode mandar 1 ou 2 Turings");
        require(!alreadyVote[msg.sender][users[codinome]], 'Voce ja votou nessa pessoa');
    
        alreadyVote[msg.sender][users[codinome]] = true;
        qtdVotos[msg.sender] += 1;
        balances[users[codinome]] += qtde_de_Turings;

        if (qtdVotos[msg.sender] % 10 == 0) {
            balances[msg.sender] += 1; 
        }
    }   

}
