unit Weibull;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TWeibull = class (TContinua)
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
constructor TWeibull.Create (_a, _b: Extended);
begin
  a := _a;
  b := _b;
end;

function TWeibull.FPA(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := 1 - Power (e, - Power ( x / b, a ) )
  else
    Result := 0;
end;

function TWeibull.FDP(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := a * Power (b, -a) * Power (x, a-1) * Power (e, - Power ((x/b), a) )
  else
    Result := 0;
end;

function TWeibull.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TWeibull.getNumPar: Byte;
begin
   Result := 2;
end;

function TWeibull.getNomePar1: String;
begin
   Result := 'Alfa';
end;

function TWeibull.getNomePar2: String;
begin
  Result := 'Beta';
end;

function TWeibull.getPar1: Extended;
begin
  Result := a;
end;

function TWeibull.getPar2: Extended;
begin
  Result := b;
end;

function TWeibull.getPar3: Extended;
begin
  Result := 0;
end;

function TWeibull.getNomePar3: String;
begin
  Result := '';
end;

function TWeibull.getNome: String;
begin
  Result := 'Weibull';
end;

function TWeibull.ParametrosValidos (x: Extended): Boolean;
begin
  if x <= 0 then
    raise Exception.Create ('Weibull: Probabilidade deve ser maior que zero')
  else if a <= 0 then
    raise Exception.Create ('Weibull: Parâmetro alfa deve ser maior que zero')
  else if b <= 0 then
    raise Exception.Create ('Weibull: Parâmetro beta deve ser maior que zero')
  else
    Result := True;
end;

end.
