unit QuiQuadrado;

interface

uses
  SysUtils, QDialogs, Dados, Parametros, Distribuicao;

type
  TQuiQuadrado = class
    public
      matriz: array of array of Real;
      constructor Create (_Dados: TDados; _Distro: TDistribuicao);
      destructor Destroy; override;
      function QuiQuadrado: Real;
      function DistroQuiQuad (NivelConfianca: Integer): Real;
      function TesteHipotese: Real;
    private
      Distro  : TDistribuicao;           // Objeto Distribuição
      Dados   : TDados;                  // Objeto Dados
      QtdInter: Integer;                 // Qtd. de Intervalos do Agrupamento
      procedure MontaMatriz;
  end;

implementation

const
  MAX_GL = 30;
  MAX_ALFA = 5;

  Distrok2: array[1..MAX_GL, 1..MAX_ALFA] of Real =
  // 50    25    10    5     1
  ( (0.45, 1.32, 2.71, 3.84, 6.63),
    (1.39, 2.77, 4.61, 5.99, 9.21),
    (2.37, 4.11, 6.25, 7.81, 11.3),
    (3.36, 5.39, 7.78, 9.49, 13.3),
    (4.35, 6.63, 9.24, 11.1, 15.1),
    (5.35, 7.84, 10.6, 12.6, 16.8),
    (6.35, 9.04, 12.0, 14.1, 18.5),
    (7.34, 10.2, 13.4, 15.5, 20.1),
    (8.34, 11.4, 14.7, 16.9, 21.7),
    (9.34, 12.5, 16.0, 18.3, 23.2),
    (10.3, 13.7, 17.3, 19.7, 24.7),
    (11.3, 14.8, 18.5, 21.0, 26.2),
    (12.3, 16.0, 19.8, 22.4, 27.7),
    (13.3, 17.1, 21.1, 23.7, 29.1),
    (14.3, 18.2, 22.3, 25.0, 30.6),
    (15.3, 19.4, 23.5, 26.3, 32.0),
    (16.3, 20.5, 24.8, 27.6, 33.4),
    (17.3, 21.6, 26.0, 28.9, 34.8),
    (18.3, 22.7, 27.2, 30.1, 36.2),
    (19.3, 23.8, 28.4, 31.4, 37.6),
    (20.3, 24.9, 29.6, 32.7, 38.9),
    (21.3, 26.0, 30.8, 33.9, 40.5),
    (22.3, 27.1, 32.0, 35.2, 41.6),
    (23.3, 28.2, 33.1, 36.4, 43.0),
    (24.3, 29.3, 34.4, 37.7, 44.3),
    (25.3, 30.4, 35.6, 38.9, 45.6),
    (26.3, 31.5, 36.7, 40.1, 47.0),
    (27.3, 32.6, 37.9, 41.3, 48.3),
    (28.3, 33.7, 39.1, 42.6, 49.6),
    (29.3, 34.8, 40.3, 43.8, 50.9));


{ IMPLEMENTAÇÃO DO CONSTRUTOR Create - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TQuiQuadrado.Create (_Dados: TDados; _Distro: TDistribuicao);
begin
  Dados := _Dados;
  Distro := _Distro;

  QtdInter := Dados.getNumIntervalo;

  MontaMatriz;
end;


{ IMPLEMENTAÇÃO DO DESTRUTOR Destroy - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
destructor TQuiQuadrado.Destroy;
begin
  Finalize (Matriz);
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO QuiQuadrado - - - - - - - - - - - - - - - - -
 Aplica o teste qui-quadrado e retorna o seu valor.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TQuiQuadrado.QuiQuadrado: Real;
var
  i: Word;
  Soma: Real;
begin
  Soma := 0;

  for i:=0 to QtdInter-1 do
    try
      Soma := Soma + sqr(Matriz[3,i] - Matriz[1,i]) / Matriz[1,i];
    except
    end;

  Result := Soma;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO DistroQuiQuad - - - - - - - - - - - - - - - -
 Retorna o valor da distribuição k2.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TQuiQuadrado.DistroQuiQuad(NivelConfianca: Integer): Real;
var
  gl, Pos : Word;
begin
  gl := QtdInter - 1 - Distro.getNumPar;      // Graus de Liberdade

  if gl <= 0 then                             // Não permite gl inválido
    gl := 1;

  Pos := 0;

  if NivelConfianca = 1 then
    Pos := 5
  else if NivelConfianca = 5 then
    Pos := 4
  else if NivelConfianca = 10 then
    Pos := 3
  else if NivelConfianca = 25 then
    Pos := 2
  else if NivelConfianca = 50 then
    Pos := 1;

  try
    Result := Distrok2 [gl, Pos];
  except
    Result := 0;
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO TesteHipótese - - - - - - - - - - - - - - - -
 Retorna o valor de aceitação do teste Qui-Quadrado. Se rejeitou, retorna 0.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TQuiQuadrado.TesteHipotese: Real;
var
  QuiQuad : Real;
begin
  QuiQuad := QuiQuadrado;

  if QuiQuad <= DistroQuiQuad (50) then
    Result := 50
  else if QuiQuad <= DistroQuiQuad (25) then
    Result := 25
  else if QuiQuad <= DistroQuiQuad (10) then
    Result := 10
  else if QuiQuad <= DistroQuiQuad (5) then
    Result := 5
  else if QuiQuad <= DistroQuiQuad (1) then
    Result := 1
  else
    Result := 0;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PRIVADO MontaMatriz - - - - - - - - - - - - - - - - -
 Monta a matriz do teste Qui-Quadrado (ei%, ei, oi%, oi).
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TQuiQuadrado.MontaMatriz;
var
  i      : Word;
  TotElem: Integer;
begin
  TotElem := Dados.getTotElementos;      // Obtém o total de elementos

  SetLength(Matriz, 4);                  // Ajusta tamanho da matriz (4 linhas)
  for i:=0 to 3 do                       // Ajusta tamanho das linhas
    SetLength(Matriz[i], QtdInter);

  for i:=0 to QtdInter-1 do begin      // 1ª linha (ei% - valor esperado em %)
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

    Matriz[0, i] := Matriz[0, i] * 100;
  end;

  for i:=0 to QtdInter-1 do            // 2ª linha (ei - valor esperado)
    Matriz[1,i] := TotElem * Matriz[0, i] / 100;

  for i:=0 to QtdInter-1 do            // 3ª linha (oi% - valor observado em %)
    Matriz[2,i] := Dados.QtdElemento[i] / TotElem * 100;

  for i:=0 to QtdInter-1 do            // 4ª linha (oi - valor observado)
    Matriz[3,i] := Dados.QtdElemento[i];
end;


end.
