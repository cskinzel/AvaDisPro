unit UniformeDiscreta;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TUniformeDiscreta = class (TDiscreta)
  public
    constructor Create (_i, _j: Integer);
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
    i: Integer;
    j: Integer;
  end;

implementation

const
  Par1 = 'i';
  Par2 = 'j';
  Par3 = '';

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TUniformeDiscreta                  }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TUniformeDiscreta.Create (_i, _j: Integer);
begin
  i := _i;
  j := _j;
end;

function TUniformeDiscreta.FPA (x: Integer): Extended;
begin
  if ParametrosValidos (x) then begin
    if x < i then
      Result := 0
    else if (x >= i) and (x <= j) then
      Result := (x - i + 1) / (j - i + 1)
    else if j < x then
      Result := 1
    else
      Result := -1
  end
  else
    Result := 0;
end;

function TUniformeDiscreta.FDP (x: Integer): Extended;
begin
  if ParametrosValidos (x) then
    Result := 1 / (j - i + 1)
  else
    Result := 0;
end;

function TUniformeDiscreta.ProbInter(inf, sup: Integer): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TUniformeDiscreta.getNumPar: Byte;
begin
   Result := 2;
end;

function TUniformeDiscreta.getNomePar1: String;
begin
  Result := Par1;
end;

function TUniformeDiscreta.getNomePar2: String;
begin
  Result := Par2;
end;

function TUniformeDiscreta.getNomePar3: String;
begin
  Result := Par3;
end;

function TUniformeDiscreta.getPar1: Extended;
begin
  Result := i;
end;

function TUniformeDiscreta.getPar2: Extended;
begin
  Result := j;
end;

function TUniformeDiscreta.getPar3: Extended;
begin
  Result := 0;
end;

function TUniformeDiscreta.getNome: String;
begin
  Result := 'Uniforme Discreta';
end;

function TUniformeDiscreta.ParametrosValidos (x: Integer): Boolean;
begin
  if j <= i then
   	raise Exception.Create ('Uniforme Discreta: Parâmetro ' + Par1 + ' deve ser menor que ' + par2)
  else if (x < i) or (x > j) then
    raise Exception.Create ('Uniforme Discreta: Probabilidade deve estar entre ' + FloatToStr(i) +
                            ' e ' + FloatToStr(j))
  else
    Result := True;
end;

end.
