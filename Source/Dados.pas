unit Dados;

interface

uses
  SysUtils, FrmJanelaEspera;

type
  TDados = class
  public
    { VETORES DIN�MICOS - VISIBILIDADE P�BLICA ------------------------------ }
    DadosUser : array of Extended; { Vetor de dados do usu�rio reais }
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
    { CONJUNTO DE DADOS - INFORMA��ES DE DADOS BRUTOS DO USU�RIO ------------- }
    TotElementos : Integer;           { Total de elementos do conjunto de dados}
    MinElemento  : Real;              { Elemento com valor m�nimo }
    MaxElemento  : Real;              { Elemento com valor m�ximo }
    SomaDados    : Extended;          { Soma dos elementos }

    { AGRUPAMENTO - DEFINI��O DE CLASSES E ATRIBUTOS ------------------------- }
    NumIntervalo : Integer;           { N�mero total de intervalos }
    MinElemAgrup : Real;              { Vl. inicial do primeiro intervalo }
    MaxElemAgrup : Real;              { Vl. final do �ltimo intervalo }

    JanelaEsp    : TFormJanelaEspera;
    function EstimaProgressBar (const x: TextFile): Integer;
  end;

implementation

{ IMPLEMENTA��O DO CONSTRUTOR Constructor - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
constructor TDados.Create;
begin
  DadosUser := nil;
  InterIni := nil;
  InterFin := nil;
  QtdElemento := nil;
  DadosUser := nil;
end;


{ IMPLEMENTA��O DO DESTRUTOR Destructor - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
destructor TDados.Destroy;
begin
  Finalize(DadosUser);
  Finalize(InterIni);
  Finalize(InterFin);
  Finalize(QtdElemento);
end;


{ IMPLEMENTA��O DO M�TODO EstimaProgressBar - - - - - - - - - - - - - - - - - -
 Le um arquivo j� aberto e retorna a quantidade de linhas existentes nele.
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


{ IMPLEMENTA��O DE M�TODOS Get e Set - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TDados.getTotElementos: Integer; // Total de Elementos de Dados Brutos
begin
  Result := TotElementos;
end;


function TDados.getMinElemento: Real;     // Elemento M�nimo de Dados Brutos
begin
  Result := MinElemento;
end;


function TDados.getMaxElemento: Real;     // Elemento M�ximo de Dados Brutos
begin
  Result := MaxElemento;
end;


function TDados.getSomaDados: Extended;   // Soma de Elementos de Dados Brutos
begin
  Result := SomaDados;
end;


function TDados.getNumIntervalo: Integer; // N�mero de Intervalos do Agrupamento
begin
  Result := NumIntervalo;
end;

function TDados.getMinElemAgrup: Real;    // Elemento M�nimo do Agrupamento
begin
  Result := MinElemAgrup;
end;

function TDados.getMaxElemAgrup: Real;    // Elemento M�ximo do Agrupamento
begin
  Result := MaxElemAgrup;
end;

function TDados.getAmplitude: Real;        // Amplitude do Agrupamento
begin
  Result := (MaxElemAgrup - MinElemAgrup) / NumIntervalo;
end;

function TDados.getMedia: Extended;       // M�dia (Agrupamento)
var
  i     : Byte;
  somafx: Extended;
begin
  somafx := 0;

  for i:=Low(InterIni) to High(InterIni) do
    somafx := somafx + ( (InterIni[i] + InterFin[i]) / 2 * QtdElemento[i] );

  Result := somafx / TotElementos;
end;


function TDados.getDP: Extended;          // Desvio Padr�o (Agrupamento)
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
