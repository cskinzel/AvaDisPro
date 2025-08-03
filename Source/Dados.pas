unit Dados;

interface

uses
  SysUtils, FrmJanelaEspera;

type
  TDados = class
  public
    { VETORES DINÂMICOS - VISIBILIDADE PÚBLICA ------------------------------ }
    DadosUser : array of Extended; { Vetor de dados do usuário reais }
    InterIni  : array of Extended; { Vetor com o primeiro elemento dos intervalos }
    InterFin  : array of Extended; { Vetor com o segundo elemento dos intervalos }

    QtdElemento: array of Integer;  { Vetor com a qtd. de elementos }

    constructor Create;
    destructor Destroy; override;

    function getTotElementos: Integer;
    function getMinElemento: Real;
    function getMaxElemento: Real;
    function getSomaDados: Extended;

    function getNumIntervalo: Integer;
    function getMinElemAgrup: Real;
    function getMaxElemAgrup: Real;
    function getAmplitude: Real;
    function getMedia: Extended;
    function getDP: Extended;

    procedure setNumIntervalo (_NumIntervalo: Integer);
    procedure setMinElemAgrup (_MinElemAgrup: Real);
    procedure setMaxElemAgrup (_MaxElemAgrup: Real);

    procedure LeArquivo (PathFile: String; CharComent: Char); virtual; abstract;
    procedure AgrupaClasses; virtual; abstract;

  protected
    { CONJUNTO DE DADOS - INFORMAÇÕES DE DADOS BRUTOS DO USUÁRIO ------------- }
    TotElementos : Integer;           { Total de elementos do conjunto de dados}
    MinElemento  : Real;              { Elemento com valor mínimo }
    MaxElemento  : Real;              { Elemento com valor máximo }
    SomaDados    : Extended;          { Soma dos elementos }

    { AGRUPAMENTO - DEFINIÇÃO DE CLASSES E ATRIBUTOS ------------------------- }
    NumIntervalo : Integer;           { Número total de intervalos }
    MinElemAgrup : Real;              { Vl. inicial do primeiro intervalo }
    MaxElemAgrup : Real;              { Vl. final do último intervalo }

    JanelaEsp    : TFormJanelaEspera;
    function EstimaProgressBar (const x: TextFile): Integer;
  end;

implementation

{ IMPLEMENTAÇÃO DO CONSTRUTOR Constructor - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
constructor TDados.Create;
begin
  DadosUser := nil;
  InterIni := nil;
  InterFin := nil;
  QtdElemento := nil;
  DadosUser := nil;
end;


{ IMPLEMENTAÇÃO DO DESTRUTOR Destructor - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
destructor TDados.Destroy;
begin
  Finalize(DadosUser);
  Finalize(InterIni);
  Finalize(InterFin);
  Finalize(QtdElemento);
end;


{ IMPLEMENTAÇÃO DO MÉTODO EstimaProgressBar - - - - - - - - - - - - - - - - - -
 Le um arquivo já aberto e retorna a quantidade de linhas existentes nele.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TDados.EstimaProgressBar (const x: TextFile): Integer;
var
  Cont: Integer;
  temp: String;
begin
  Cont := 0;
  while not EOF(x) do
    begin
      ReadLn (x, temp);
      Cont := Cont + 1;
    end;
  Reset(x);
  Result := Cont;
end;


{ IMPLEMENTAÇÃO DE MÉTODOS Get e Set - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TDados.getTotElementos: Integer; // Total de Elementos de Dados Brutos
begin
  Result := TotElementos;
end;


function TDados.getMinElemento: Real;     // Elemento Mínimo de Dados Brutos
begin
  Result := MinElemento;
end;


function TDados.getMaxElemento: Real;     // Elemento Máximo de Dados Brutos
begin
  Result := MaxElemento;
end;


function TDados.getSomaDados: Extended;   // Soma de Elementos de Dados Brutos
begin
  Result := SomaDados;
end;


function TDados.getNumIntervalo: Integer; // Número de Intervalos do Agrupamento
begin
  Result := NumIntervalo;
end;

function TDados.getMinElemAgrup: Real;    // Elemento Mínimo do Agrupamento
begin
  Result := MinElemAgrup;
end;

function TDados.getMaxElemAgrup: Real;    // Elemento Máximo do Agrupamento
begin
  Result := MaxElemAgrup;
end;

function TDados.getAmplitude: Real;        // Amplitude do Agrupamento
begin
  Result := (MaxElemAgrup - MinElemAgrup) / NumIntervalo;
end;

function TDados.getMedia: Extended;       // Média (Agrupamento)
var
  i     : Byte;
  somafx: Extended;
begin
  somafx := 0;

  for i:=Low(InterIni) to High(InterIni) do
    somafx := somafx + ( (InterIni[i] + InterFin[i]) / 2 * QtdElemento[i] );

  Result := somafx / TotElementos;
end;


function TDados.getDP: Extended;          // Desvio Padrão (Agrupamento)
var
  i      : Byte;
  n      : Integer;
  somafx2: Extended;
begin
  somafx2 := 0;

  for i:=Low(InterIni) to High(InterIni) do
    somafx2 := somafx2 + ( sqr((InterIni[i] + InterFin[i]) / 2) * QtdElemento[i] );

  n := getTotElementos;
  Result := sqrt ( ( somafx2 -n * sqr(getMedia) ) / (n-1) );
end;


procedure TDados.setNumIntervalo (_NumIntervalo: Integer);
begin
  NumIntervalo := _NumIntervalo;
end;


procedure TDados.setMinElemAgrup (_MinElemAgrup: Real);
begin
  MinElemAgrup := _MinElemAgrup;
end;


procedure TDados.setMaxElemAgrup (_MaxElemAgrup: Real);
begin
  MaxElemAgrup := _MaxElemAgrup;
end;

end.
