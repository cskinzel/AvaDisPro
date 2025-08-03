unit Exponencial;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TExponencial = class (TContinua)
  public
    constructor Create (_media: Extended);
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
    function ParametrosValidos(x: Extended): Boolean; override;
  private
    media: Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TExponencial                       }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TExponencial.Create (_media: Extended);
begin
  media := _media;
end;

function TExponencial.FPA (x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := 1 - Math.Power (e, (-1 / media * x))
  else
    Result := 0;
end;

function TExponencial.FDP (x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := ( 1 / media ) * Math.Power (e, (-x / media))
  else
    Result := 0;
end;

function TExponencial.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TExponencial.getNumPar: Byte;
begin
   Result := 1;
end;

function TExponencial.getNomePar1: String;
begin
   Result := 'Média';
end;

function TExponencial.getNomePar2: String;
begin
  Result := '';
end;

function TExponencial.getNomePar3: String;
begin
  Result := '';
end;

function TExponencial.getPar1: Extended;
begin
  Result := Media;
end;

function TExponencial.getPar2: Extended;
begin
  Result := 0;
end;

function TExponencial.getPar3: Extended;
begin
  Result := 0;
end;

function TExponencial.getNome: String;
begin
  Result := 'Exponencial';
end;

function TExponencial.ParametrosValidos (x: Extended): Boolean;
begin
  if x <= 0 then
    raise Exception.Create ('Exponencial: Probabilidade deve ser maior que zero')
  else if media <= 0 then
    raise Exception.Create ('Exponencial: Parâmetro média deve ser maior que zero')
  else
    Result := True;
end;

end.
