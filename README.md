# Election Smart contract

### Tecnologia utilizada:
- Solidity


## Smart contract explicado:

estrutura de um candidato:

 - id (identificador unico)
 - idade
 - nome completo
 - votos recebidos
 
```
struct CandidateInfo {
        uint id;
        uint age;
        string fullName;
        uint votes;
  }
```
    
    
    
 definindo a pessoa responsável por administrar a criação de um candidato:
 
 o msg.sender (nesse caso) é a pessoa que fez o deploy (enviou o smart contract para a blockchain).
```
  address public manager = msg.sender; 
```

criando um dicionário onde um número irá apontar para um candidato.

```
mapping(uint => CandidateInfo) candidates;
```


iniciando um array de candidatos.
```
CandidateInfo[] public candidatesVotes;
```

criando um dicionário, onde um endereço(sua identificação na blockchain) irá apontar para um booleano (já votou = true, não votou = false).
```
mapping(address => bool) voters;
```


criando uma função para permitir apenas que o administrador faça a criação dos candidatos.
```
modifier restricted {
        require(msg.sender == manager);
        _;
    }
```


funçao responsável por criar um novo candidato com as informnações e adicionar ele ao array de candidatos.

obs: apenas o administrador pode utilizar essa função.
```
function registerCandidate( uint _age, string memory _fullName) public restricted {
        uint id = candidatesVotes.length + 1;
        CandidateInfo storage newCandidate = candidates[id];
        newCandidate.id = id;
        newCandidate.age = _age;
        newCandidate.fullName = _fullName;
        newCandidate.votes = 0;
        candidatesVotes.push(newCandidate);
        
    }
```



função de votar. apenas candidatos que não votaram conseguirão votar!

obs: qualquer um pode chamar essa função.
```
function vote(uint _id) public {
        require(voters[msg.sender] == false, "The voter already voted.");
        uint id = _id - 1;
        candidatesVotes[id].votes += 1;
        voters[msg.sender] = true;
        
    }
```



função para calcular o vencedor e retorná-lo.

irá percorrer o array de candidatos e verificar a quantidade de votos que cada um recebeu. 
O que receber mais votos será armazenado na variável winner e no final o nome dele será retornado.

```
function showWinner() public restricted view returns(string memory)  {
        uint winner = 0;
        for(uint i = 0; i < candidatesVotes.length; i++) {
            uint winningVoteCount = 0;
            if(candidatesVotes[i].votes < winningVoteCount) {
                winningVoteCount = candidatesVotes[i].votes;
                winner = i;
            }
        }
        return candidatesVotes[winner].fullName;
    }
```









