pragma solidity ^0.4.23;

contract Votacao {
   
    struct Voto { 
        uint uf;
        uint cmun;
        string idCandidato;
        uint256 voteCount; 
    } 
    
    struct Candidato {
        string id; 
        uint uf;
        uint cmun;
        uint256 voteCount;
    }
    
    struct BU {
        string id;
        Voto[] votos;
    }
     
    Candidato[] public candidatos ;
    mapping(string => BU) bus; 
  
    function vote(string pidBu, string pidCandidato, uint puf, uint pcmun, uint256 pvoteCount)
                                                                                     public  {

        if (strIsEmpty(bus[pidBu].id)){
            bus[pidBu].id = pidBu;
        }
        
        bool isJaFoiVotado = false;
        for (uint i = 0; i < bus[pidBu].votos.length; i++) {
            if (strCompare(bus[pidBu].votos[i].idCandidato,pidCandidato) == 0) {
                if (bus[pidBu].votos[i].uf == puf && bus[pidBu].votos[i].cmun == pcmun) {
                    isJaFoiVotado = true;
                    break;
                }
            }
        }
        
        require(!isJaFoiVotado, "Apenas um voto é permitido.");
        
        bus[pidBu].votos.push(Voto({uf:puf, cmun:pcmun, idCandidato:pidCandidato, voteCount:pvoteCount}));

        bool isCandidatoInserido = false;
        for (uint j = 0; j < candidatos.length; j++) {
            if (strCompare(candidatos[j].id,pidCandidato) == 0 
            && candidatos[j].uf == puf && candidatos[j].cmun == pcmun)
            {
                candidatos[j].voteCount += pvoteCount;
                isCandidatoInserido = true;
            }
        }
        
        if (!isCandidatoInserido) {
            candidatos.push(Candidato({id:pidCandidato, uf:puf, cmun:pcmun, voteCount:pvoteCount }));
        }
    }
  
    function getTotalVotosPorCandidato(string pidCandidato, uint puf, uint pcmun) public view returns (uint256 total )
    {
        bool isIgnoraMunicipio = pcmun <= 0;
        bool isIgnoraUf = puf <= 0;

        for (uint j = 0; j < candidatos.length; j++) {

            if (strCompare(candidatos[j].id, pidCandidato) == 0)
            {
                if ( (isIgnoraUf || candidatos[j].uf == puf) && (isIgnoraMunicipio || candidatos[j].cmun == pcmun))

                total += candidatos[j].voteCount;
            }
        }
    } 
  
    function getTotalCandidatos() public view returns (uint256 total)
    {
        return candidatos.length;
    }
    
    function strCompare(string _a, string _b) internal pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
        return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
     
    function strIsEmpty(string _a) internal pure returns (bool) {
        bytes memory a = bytes(_a);
        return (a.length == 0); 
    }
}