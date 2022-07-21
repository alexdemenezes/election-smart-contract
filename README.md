# Election Smart contract

Praticamente todos os acordos que são feitos hoje em dia necessitam de um terceiro para garantir que ambos os lados cumpram suas obrigações!
Imagine a seguinte situação: Você acabou de se mudar para o Brasil e precisa comprar muitas coisas porém, você não tem todo esse dinheiro. A sua única saída seria apelar para um cartão de crédito pois é praticamente a única forma de comprar parcelado. 
Mas para ter esse cartão você terá que abrir uma conta em um banco, e para isso terá que  enviar muitas documentações, esperar eles aprovarem sua conta e depois aguardar um tempo até que eles julguem que você tem o perfil para ter um cartão de crédito. No fim, depois de muito tempo você conseguiu o cartão, mas o limite de crédito aprovado foi muito baixo devido ao motivo da sua conta ser recente.

Você consegue perceber que uma transação entre duas partes (você e a loja) acaba se tornando algo muito mais demorado pelo motivo de ter que envolver um terceiro para garantir o cumprimento de ambos os lados?

Os smart contracts surgiram para resolver esse problema! :)

com ele, você não depende de um terceiro para garantir que ambos os lados cumpram o combinado e sim de algoritmos baseados em lógica e matemática!

São muitos os benefícios então não irei citar todos para o texto não ficar muito longo, porém os principais são:
- Você não precisa de um terceiro para garantir que ambos os lados cumpram um acordo.
- Sem precisar de um terceiro, o processo se torna muito mais rápido.
- Sem precisar de um terceiro, você economiza dinheiro (imagina vender uma casa sem precisar de uma corretora).
- Não é possível alterar nada após o smart contract ser lançado. (então terá que ser cumprido o que foi acordado).
e por ai vai...

Foi desenvolvido como exemplo esse pequeno smart contract simulando um sistema de votação: 


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









