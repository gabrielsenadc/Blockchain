//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This is the main building block for smart contracts.
contract Turing is ERC20 {
    string public professora = 'roberta';
    bool public voting = true;

    address public owner;

    mapping(string => address) public users;
    mapping(address => string) public codinomeOf;
    mapping(address => mapping(address => bool)) public alreadyVote;
    mapping(address => uint256) public qtdVotos;

    constructor() ERC20("Turing", "TTK") {
        owner = msg.sender;
        
        _setUser('roberta', 0x502542668aF09fa7aea52174b9965A7799343Df7);
        _setUser('nome1', 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        _setUser('nome2', 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        _setUser('nome3', 0x90F79bf6EB2c4f870365E785982E1f101E93b906);
        _setUser('nome4', 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        _setUser('nome5', 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    }

    // 1 Turing = 1 unidade (sem casas decimais)
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    modifier onlyOwner {
        require(msg.sender == users[professora] || msg.sender == owner, "Voce nao eh o dono ou a Roberta");
        _;
    }

    function _setUser(string memory codinome, address addr) internal {
        require(addr != address(0), "Endereco invalido");

        // libera o endereco antigo deste codinome
        address old = users[codinome];
        if (old != address(0)) delete codinomeOf[old];

        // se o novo endereco ja tinha outro codinome, remove o vinculo antigo
        string memory prev = codinomeOf[addr];
        if (bytes(prev).length > 0) delete users[prev];

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

    function votingOff() onlyOwner external {
        voting = false;
    }

    function issueToken(string memory codinome , uint256 qtde_de_Turings) onlyOwner external {
        require(users[codinome] != address(0), "Codinome inexistente");
        _mint(users[codinome], qtde_de_Turings);
    }

    function vote(string memory codinome, uint256 qtde_de_Turings) external {
        require(voting, 'Votacao nao esta ativa');
        require(users[codinome] != address(0), "Codinome inexistente");
        require(bytes(codinomeOf[msg.sender]).length > 0, "Voce nao eh autorizado");
        require(users[codinome] != msg.sender, "Voce nao pode votar em si mesmo");
        require(qtde_de_Turings > 0 && qtde_de_Turings <= 2, "Voce so pode mandar 1 ou 2 Turings");
        require(!alreadyVote[msg.sender][users[codinome]], 'Voce ja votou nessa pessoa');
    
        alreadyVote[msg.sender][users[codinome]] = true;
        qtdVotos[msg.sender] += 1;
        _mint(users[codinome], qtde_de_Turings);

        if (qtdVotos[msg.sender] % 10 == 0) {
            _mint(msg.sender, 1); 
        }
    }   

}
