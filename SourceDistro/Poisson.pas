unit Poisson;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TPoisson = class (TDiscreta)
  public
    constructor Create (_media: Extended);
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
    media: Extended;
    function FactorialX (A: LongWord): Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TPoisson                        }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TPoisson.Create (_media: Extended);
begin
  media := _media;
end;

function TPoisson.FPA(x: Integer): Extended;
var
  Soma: Extended;
  i: Integer;
begin
  if ParametrosValidos (x) then begin
    Soma := 0;
    for i:=0 to x do
      Soma := Soma + Power (media, i) / FactorialX(i);

    Result := Power(e, -media) * Soma;
  end
  else
    Result := 0;
end;

function TPoisson.FDP(x: Integer): Extended;
begin
  if ParametrosValidos (x) then
    Result := Power (e, -media) * Power (media, x) / FactorialX (x)
  else
    Result := 0;
end;

function TPoisson.ProbInter(inf, sup: Integer): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TPoisson.getNumPar: Byte;
begin
   Result := 1;
end;

function TPoisson.getNomePar1: String;
begin
   Result := 'Média';
end;

function TPoisson.getNomePar2: String;
begin
  Result := '';
end;

function TPoisson.getNomePar3: String;
begin
  Result := '';
end;

function TPoisson.getPar1: Extended;
begin
  Result := Media;
end;

function TPoisson.getPar2: Extended;
begin
  Result := 0;
end;

function TPoisson.getPar3: Extended;
begin
  Result := 0;
end;

function TPoisson.getNome: String;
begin
  Result := 'Poisson';
end;

function TPoisson.ParametrosValidos (x: Integer): Boolean;
begin
  if x < 0 then
    raise Exception.Create ('Poisson: Probabilidade deve ser maior ou igual a zero')
  else if media <= 0 then
    raise Exception.Create ('Poisson: Parâmetro média deve ser maior que 0')
  else
    Result := True;
end;

{ DEFINIÇÃO DO MÉTODO PRIVADO FactorialX - - - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: Returns A! i.e Factorial of A - only values up to 1754 are
                handled returns 0 if larger
 - ENTRADA....: A
 - SAÍDA......: FactorialX
 - MODIFICA...: -
 - DEPENDÊNCIA: -
 - REFERÊNCIA.: ESBMaths for Cross Platform Development -
                contains useful Mathematical routines for Delphi 6 & Kylix.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TPoisson.FactorialX (A: LongWord): Extended;
var
	I: Integer;
begin
	if A  > 1754 then
	begin
		Result := 0.0;
		Exit;
	end;
	Result := 1.0;
	for I := 2 to A do
		Result := Result * I;
end;

end.
