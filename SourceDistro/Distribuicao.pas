unit Distribuicao;

interface

uses
  Math, SysUtils;

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                Definição da classe abstrata Distribuicao                     }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
type
  TDistribuicao = class (TObject)
  public
    { Retorna a quantidade de parâmetros necessários para a distribuição }
    function getNumPar: Byte; virtual; abstract;

    { Retorna o nome dos parâmetros de uma DP }
    function getNomePar1: String; virtual; abstract;
    function getNomePar2: String; virtual; abstract;
    function getNomePar3: String; virtual; abstract;

    { Retorna os parâmetros de uma DP }
    function getPar1: Extended; virtual; abstract;
    function getPar2: Extended; virtual; abstract;
    function getPar3: Extended; virtual; abstract;

    { Retorna o nome da distribuição }
    function getNome: String; virtual; abstract;
  end;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{              Definição da classe abstrata Distribuicao Continua              }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
type
  TContinua = class(TDistribuicao)
  public
    { Calcula a FPA (Função de Probabilidade Acumulada) de uma DP Continua }
    function FPA (x: Extended): Extended; virtual; abstract;

    { Calcula a FDP (Função Densidade de Probabilidade) de uma DP Continua }
    function FDP (x: Extended): Extended; virtual; abstract;

    { Calcula a probabilidade de um intervalo; dado um limite inferior e um
    limite superior, calcula a diferença de probabilidades entre eles }
    function ProbInter (_inf, _sup: Extended): Extended; virtual; abstract;

  protected
    { Método utilizado para validar os parâmetros de uma DP Contínua }
    function ParametrosValidos (x: Extended): Boolean; virtual; abstract;
  end;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{              Definição da classe abstrata Distribuicao Discreta              }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
type
  TDiscreta = class(TDistribuicao)
  public
    { Calcula a FPA (Função de Probabilidade Acumulada) de uma DP Discreta }
    function FPA (x: Integer): Extended; virtual; abstract;

    { Calcula a FMP (Função Massa de Probabilidade) de uma DP Discreta }
    function FDP (x: Integer): Extended; virtual; abstract;

    { Calcula a probabilidade de um intervalo; dado um limite inferior e um
    limite superior, calcula a diferença de probabilidades entre eles }
    function ProbInter (_inf, _sup: Integer): Extended; virtual; abstract;

  protected
    { Método utilizado para validar os parâmetros de uma DP Discreta }
    function ParametrosValidos (x: Integer): Boolean; virtual; abstract;
  end;


const
  e = 2.7182818284590452354;                           { Logaritmo de Euller }


implementation

end.
