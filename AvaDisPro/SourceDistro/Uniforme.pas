unit Uniforme;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TUniforme = class (TContinua)
  public
    constructor Create (_a, _b: Extended);
    function FPA (x: Extended): Extended; override;
    function FDP (x: Extended): Extended; override;
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

const
  Par1 = 'a';
  Par2 = 'b';
  Par3 = '';

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TUniforme                          }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TUniforme.Create (_a, _b: Extended);
begin
  a := _a;
  b := _b;
end;

function TUniforme.FPA(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := ( x - a ) / ( b - a )
  else
    Result := 0;
end;

function TUniforme.FDP(x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := 1 / ( b - a )
  else
    Result := 0;
end;

function TUniforme.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TUniforme.getNumPar: Byte;
begin
  Result := 2;
end;

function TUniforme.getNomePar1: String;
begin
  Result := Par1;
end;

function TUniforme.getNomePar2: String;
begin
  Result := Par2;
end;

function TUniforme.getNomePar3: String;
begin
  Result := Par3;
end;

function TUniforme.getPar1: Extended;
begin
  Result := a;
end;

function TUniforme.getPar2: Extended;
begin
  Result := b;
end;

function TUniforme.getPar3: Extended;
begin
  Result := 0;
end;

function TUniforme.getNome: String;
begin
  Result := 'Uniforme';
end;

function TUniforme.ParametrosValidos (x: Extended): Boolean;
begin
  if b <= a then
   	raise Exception.Create ('Uniforme: Parâmetro ' + Par1 + ' deve ser menor que ' + par2)
  else if (x < a) or (x > b) then
    raise Exception.Create ('Uniforme: Probabilidade deve estar entre ' + FloatToStr(a) +
                            ' e ' + FloatToStr(b))
  else
    Result := True;
end;

end.
