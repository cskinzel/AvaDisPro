unit Geometrica;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TGeometrica = class (TDiscreta)
  public
    constructor Create (_p: Extended);
    function FPA (x: Integer): Extended; override;
    function FDP (x: Integer): Extended; override;
    function ProbInter (inf, sup: Integer): Extended; override;
    function getNumPar: Byte; override;
    function getNomePar1: String; override;
    function getNomePar2: String; override;
    function getNomePar3: String; override;
    function getPar1: Extended; override;
    function getPar2: Extended; override;
    function getPar3: Extended; override;
    function getNome: String; override;
  protected
    function ParametrosValidos (x: Integer): Boolean; override;
  private
    p: Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TGeometrica                        }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TGeometrica.Create (_p: Extended);
begin
  p := _p;
end;

function TGeometrica.FPA (x: Integer): Extended;
begin
  if ParametrosValidos (x) then
     Result := 1 - Power (1 - p, x + 1)
  else
    Result := 0;
end;

function TGeometrica.FDP (x: Integer): Extended;
begin
  if ParametrosValidos (x) then
    Result := p * Power (1 - p, x)
  else
    Result := 0;
end;

function TGeometrica.ProbInter(inf, sup: Integer): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TGeometrica.getNumPar: Byte;
begin
   Result := 1;
end;

function TGeometrica.getNomePar1: String;
begin
   Result := 'p';
end;

function TGeometrica.getNomePar2: String;
begin
  Result := '';
end;

function TGeometrica.getNomePar3: String;
begin
  Result := '';
end;

function TGeometrica.getPar1: Extended;
begin
  Result := p;
end;

function TGeometrica.getPar2: Extended;
begin
  Result := 0;
end;

function TGeometrica.getPar3: Extended;
begin
  Result := 0;
end;

function TGeometrica.getNome: String;
begin
  Result := 'Geométrica';
end;

function TGeometrica.ParametrosValidos (x: Integer): Boolean;
begin
  if x < 0 then
    raise Exception.Create ('Geométrica: Probabilidade deve ser maior ou igual a zero')
  else if (p < 0) or (p > 1) then
    raise Exception.Create ('Geométrica: Parâmetro p deve estar entre 0 e 1')
  else
    Result := True;
end;

end.
