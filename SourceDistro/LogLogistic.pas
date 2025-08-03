unit LogLogistic;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TLogLogistic = class (TContinua)
  public
    constructor Create (_a, _b: Extended);
    function FPA(x: Extended): Extended; override;
    function FDP(x: Extended): Extended; override;
    function ProbInter (inf, sup: Extended): Extended; override;
    function getNumPar: Byte; override;
    function getNomePar1: String; override;
    function getNomePar2: String; override;
    function getNomePar3: String; override;
    function getPar1: Extended; override;
    function getPar2: Extended; override;
    function getPar3: Extended; override;
    function getNome: String; override;
  protected
    function ParametrosValidos (x: Extended): Boolean; override;
  private
    a: Extended;
    b: Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TWeibull                           }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TLogLogistic.Create (_a, _b: Extended);
begin
  a := _a;
  b := _b;
end;

function TLogLogistic.FPA(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := 1 / (1 + Power(x/b, -a))
  else
    Result := 0;
end;

function TLogLogistic.FDP(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := ( a * Power(x/b, a-1) ) / ( b * Sqr (1 + Power(x/b, a) ) )
  else
    Result := 0;
end;

function TLogLogistic.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TLogLogistic.getNumPar: Byte;
begin
   Result := 2;
end;

function TLogLogistic.getNomePar1: String;
begin
   Result := 'Alfa';
end;

function TLogLogistic.getNomePar2: String;
begin
  Result := 'Beta';
end;

function TLogLogistic.getNomePar3: String;
begin
  Result := '';
end;

function TLogLogistic.getPar1: Extended;
begin
  Result := a;
end;

function TLogLogistic.getPar2: Extended;
begin
  Result := b;
end;

function TLogLogistic.getPar3: Extended;
begin
  Result := 0;
end;

function TLogLogistic.getNome: String;
begin
  Result := 'Log-logistic';
end;

function TLogLogistic.ParametrosValidos (x: Extended): Boolean;
begin
  if x <= 0 then
    raise Exception.Create ('Log-logistic: Probabilidade deve ser maior que zero')
  else if a <= 0 then
    raise Exception.Create ('Log-logistic: Parâmetro alfa deve ser maior que zero')
  else if b <= 0 then
    raise Exception.Create ('Log-logistic: Parâmetro beta deve ser maior que zero')
  else
    Result := True;
end;

end.
