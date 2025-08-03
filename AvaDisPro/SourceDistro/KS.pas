unit KS;

interface

uses
  SysUtils, QDialogs, Dados, Parametros, Distribuicao;

type
  TKS = class
    public
      matriz: array of array of Real;
      constructor Create (_Dados: TDados; _Distro: TDistribuicao);
      destructor Destroy; override;
      function KS: Real;
      function DistroKS (NivelConfianca: Integer): Real;
      function TesteHipotese: Real;
    private
      Distro  : TDistribuicao;           // Objeto Distribuição
      Dados   : TDados;                  // Objeto Dados
      QtdInter: Integer;                 // Qtd. de Intervalos do Agrupamento
      procedure MontaMatriz;
  end;

implementation

const
  MAX_N = 30;
  MAX_ALFA = 3;

  MatrizKS: array[1..MAX_N, 1..MAX_ALFA] of Real =
  // 0.2   0.05   0.01
  ( (0.900, 0.975, 0.995),  // n=1
    (0.684, 0.842, 0.929),  // n=2
    (0.565, 0.708, 0.829),  // n=3
    (0.493, 0.624, 0.734),  // 4
    (0.447, 0.563, 0.669),  // 5
    (0.410, 0.519, 0.617),  // 6
    (0.381, 0.483, 0.576),  // 7
    (0.358, 0.454, 0.542),  // 8
    (0.339, 0.430, 0.513),  // 9
    (0.323, 0.409, 0.489),  // 10
    (0.308, 0.391, 0.468),  // 11
    (0.296, 0.375, 0.449),  // 12
    (0.285, 0.361, 0.432),  // 13
    (0.275, 0.349, 0.418),  // 14
    (0.266, 0.338, 0.404),  // 15
    (0.258, 0.327, 0.392),  // 16
    (0.250, 0.318, 0.381),  // 17
    (0.244, 0.309, 0.371),  // 18
    (0.237, 0.301, 0.361),  // 19
    (0.232, 0.294, 0.352),  // 20
    (0.226, 0.287, 0.344),  // 21
    (0.221, 0.281, 0.337),  // 22
    (0.216, 0.275, 0.330),  // 23
    (0.212, 0.269, 0.323),  // 24
    (0.208, 0.264, 0.317),  // 25
    (0.204, 0.259, 0.311),  // 26
    (0.200, 0.254, 0.305),  // 27
    (0.197, 0.250, 0.300),  // 28
    (0.193, 0.246, 0.295),  // 29
    (0.190, 0.242, 0.290)); // 30


{ IMPLEMENTAÇÃO DO CONSTRUTOR Create - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TKS.Create (_Dados: TDados; _Distro: TDistribuicao);
begin
  Dados := _Dados;
  Distro := _Distro;

  QtdInter := Dados.getNumIntervalo;

  MontaMatriz;
end;


{ IMPLEMENTAÇÃO DO DESTRUTOR Destroy - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
destructor TKS.Destroy;
begin
  Finalize (Matriz);
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO KS - - - - - - - - - - - - - - - - - - - - -
 Aplica o teste K-S e retorna o seu valor.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TKS.KS: Real;
var
  i    : Word;
  Maior: Real;
begin
  Maior := Matriz[3,0];

  for i:=1 to QtdInter-1 do
    if Maior < Matriz[3,i] then
      Maior := Matriz[3,i];

  Result := Maior;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO DistroK-S - - - - - - - - - - - - - - - - - -
 Retorna o valor crítico da tabela K-S.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TKS.DistroKS(NivelConfianca: Integer): Real;
var
  n, Pos : Word;
begin
  n := Dados.getTotElementos;
  Pos := 0;

  if NivelConfianca = 1 then
    Pos := 3
  else if NivelConfianca = 5 then
    Pos := 2
  else if NivelConfianca = 20 then
    Pos := 1;

  if n <= Max_N then
    Result := MatrizKS [n, Pos]
  else if NivelConfianca = 1 then
    Result := StrToFloat (FormatFloat ('0.000', 1.63/sqrt(n)))
  else if NivelConfianca = 5 then
    Result := StrToFloat (FormatFloat ('0.000', 1.38/sqrt(n)))
  else if NivelConfianca = 20 then
    Result := StrToFloat (FormatFloat ('0.000', 1.07/sqrt(n)))
  else
    Result := 0
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO TesteHipótese - - - - - - - - - - - - - - - -
 Retorna o valor de aceitação do teste K-S. Se rejeitou, retorna 0.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TKS.TesteHipotese: Real;
var
  MyKS : Real;
begin
  MyKS := KS;

  if MyKS <= DistroKS (20) then
    Result := 20
  else if MyKS <= DistroKS (5) then
    Result := 5
  else if MyKS <= DistroKS (1) then
    Result := 1
  else
    Result := 0;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PRIVADO MontaMatriz - - - - - - - - - - - - - - - - -
 Monta a matriz do teste K-S (ei, Fo(x), Sn(x), D).
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TKS.MontaMatriz;
var
  i: Word;
  TotElem, AcumN: Integer;

begin
  TotElem := Dados.getTotElementos;      // Obtém o total de elementos

  SetLength(Matriz, 4);                  // Ajusta tamanho da matriz (4 linhas)
  for i:=0 to 3 do                       // Ajusta tamanho das linhas
    SetLength(Matriz[i], QtdInter);

 for i:=0 to QtdInter-1 do begin      // 1ª linha (ei - valor esperado / 100)
    if Distro.ClassParent = TContinua then
      // DISTRIBUIÇÃO CONTÍNUA ................................................
      if i = 0 then
        Matriz[0, i] := (Distro as TContinua).FPA (Dados.InterFin[i])
      else if i = QtdInter-1 then
        Matriz[0, i] := 1 - (Distro as TContinua).FPA (Dados.InterIni[i])
      else
        Matriz[0, i] := (Distro as TContinua).ProbInter (Dados.InterIni[i], Dados.InterFin[i])
    else
      // DISTRIBUIÇÃO DISCRETA ................................................
      if i = 0 then
        Matriz[0, i] := (Distro as TDiscreta).FPA (Trunc(Dados.InterFin[i]))
      else if i = QtdInter-1 then
        Matriz[0, i] := 1 - (Distro as TDiscreta).FPA (Trunc(Dados.InterIni[i]))
      else
        Matriz[0, i] := (Distro as TDiscreta).ProbInter (Trunc(Dados.InterIni[i]),
                                                         Trunc(Dados.InterFin[i]));
  end;

  for i:=0 to QtdInter-1 do            // 2ª linha (Fo(x) -> acumulador)
    if i=0 then
      Matriz[1,i] := Matriz[0,i]
    else
      Matriz[1,i] := Matriz[0,i] + Matriz[1, i-1];

  AcumN := 0;
  for i:=0 to QtdInter-1 do begin      // 3ª linha (Sn(x) -> observado)
    AcumN := AcumN + Dados.QtdElemento[i];
    Matriz[2,i] := AcumN / TotElem;
  end;

  for i:=0 to QtdInter-1 do            // 4ª linha (D -> K-S)
    Matriz[3,i] := Abs(Matriz[1,i] - Matriz[2,i]);
end;

end.
