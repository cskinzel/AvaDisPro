unit Triangular;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TTriangular = class (TContinua)
  public
    constructor Create (_a, _b, _c: Extended);
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
    c: Extended;
  end;

implementation

const
  Par1 = 'a';
  Par2 = 'b';
  Par3 = 'c';

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TTriangular                       }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TTriangular.Create (_a, _b, _c: Extended);
begin
  a := _a;
  b := _b;
  c := _c;
end;

function TTriangular.FPA(x: Extended): Extended;
begin
  if ParametrosValidos (x) then begin
    if x < a then
      Result := 0
    else if (x >= a) and (x <= c) then
      Result := Sqr(x - a) / ( (b - a) * (c -a) )
    else if (x > c) and (x <= b) then
      Result := 1 - ( Sqr(b - x) / ((b - a) * (b - c)) )
    else if x > b then
      Result := 1
    else
      Result := 0
   end
  else
    Result := 0;
end;

function TTriangular.FDP(x: Extended): Extended;
begin
  if ParametrosValidos (x) then begin
    if (x >= a) and (x <= c) then
      Result := 2 * (x - a) / ( (b - a) * (c - a) )
    else if (x > c) and (x <= b) then
      Result := 2 * (b - x) / ( (b - a) * (b - c) )
    else
      Result := 0;
  end
  else
    Result := 0;
end;

function TTriangular.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TTriangular.getNumPar: Byte;
begin
   Result := 3;
end;

function TTriangular.getNomePar1: String;
begin
   Result := Par1;
end;

function TTriangular.getNomePar2: String;
begin
  Result := Par2;
end;

function TTriangular.getNomePar3: String;
begin
  Result := Par3;
end;

function TTriangular.getPar1: Extended;
begin
  Result := a;
end;

function TTriangular.getPar2: Extended;
begin
  Result := b;
end;

function TTriangular.getPar3: Extended;
begin
  Result := c;
end;

function TTriangular.getNome: String;
begin
  Result := 'Triangular';
end;

function TTriangular.ParametrosValidos (x: Extended): Boolean;
begin
  if a >= c then
    raise Exception.Create ('Triangular: Parâmetro ' + Par1 + ' deve ser menor que ' + Par3)
  else if c >= b then
    raise Exception.Create ('Triangular: Parâmetro ' + Par3 + ' deve ser menor que ' + Par2)
  else if a >= b then
    raise Exception.Create ('Triangular: Parâmetro ' + Par1 + ' deve ser menor que ' + Par2)
  else if (x < a) or (x > b) then
    raise Exception.Create ('Triangular: Probabilidade deve estar entre ' + FloatToStr(a) +
                            ' e ' + FloatToStr(b))
  else
    Result := True;
end;

end.
