unit Binomial;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TBinomial = class (TDiscreta)
  public
    constructor Create (_n: Integer; _p: Extended);
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
    function BinomialCoeff (N, R: LongWord): Extended;
  protected
    function ParametrosValidos (x: Integer): Boolean; override;
  private
    n: Integer;
    p: Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TBinomial                          }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TBinomial.Create (_n: Integer; _p: Extended);
begin
  n := _n;
  p := _p;
end;

function TBinomial.FPA(x: Integer): Extended;
var
  Soma: Extended;
  i: Integer;
begin
  if ParametrosValidos (x) then begin
    Soma := 0;
    for i:=0 to Trunc(x) do
      Soma := Soma + BinomialCoeff(n, i) * Power (p, i) * Power (1-p, n-i);
    Result := Soma;
  end
  else
    Result := 0;
end;

function TBinomial.FDP (x: Integer): Extended;
begin
  if ParametrosValidos (x) then
    Result := BinomialCoeff (n, x) * Power (p, x) * Power (1 - p, n - x)
  else
    Result := 0;
end;

function TBinomial.ProbInter(inf, sup: Integer): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TBinomial.getNumPar: Byte;
begin
   Result := 2;
end;

function TBinomial.getNomePar1: String;
begin
   Result := 'n';
end;

function TBinomial.getNomePar2: String;
begin
  Result := 'p';
end;

function TBinomial.getNomePar3: String;
begin
  Result := '';
end;

function TBinomial.getPar1: Extended;
begin
  Result := n;
end;

function TBinomial.getPar2: Extended;
begin
  Result := p;
end;

function TBinomial.getPar3: Extended;
begin
  Result := 0;
end;

function TBinomial.getNome: String;
begin
  Result := 'Binomial';
end;

function TBinomial.ParametrosValidos (x: Integer): Boolean;
begin
  if x < 0 then
    raise Exception.Create ('Binomial: Probabilidade deve ser maior ou igual a zero')
  else if n <= 0 then
    raise Exception.Create ('Binomial: Parâmetro n deve ser maior que 0')
  else if p < 0 then
    raise Exception.Create ('Binomial: Parâmetro p deve ser maior ou igual que 0')
  else if (p < 0) or (p > 1) then
    raise Exception.Create ('Binomial: Parâmetro p deve estar entre 0 e 1')
  else
    Result := True;
end;

{ DEFINIÇÃO DO MÉTODO PÚBLICO BinomialCoeff - - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: Returns nCr i.e Combination of r objects from n.
                These are also known as the Binomial Coefficients
              	Only values of N up to 1754 are handled	returns 0 if larger
	              If R > N  then 0 is returned
 - ENTRADA....: N, R
 - SAÍDA......: BinomialCoeff
 - MODIFICA...: -
 - DEPENDÊNCIA: -
 - REFERÊNCIA.: ESBMaths for Cross Platform Development -
                contains useful Mathematical routines for Delphi 6 & Kylix.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TBinomial.BinomialCoeff (N, R: LongWord): Extended;
var
	I: Integer;
	K: LongWord;
begin
	if (N = 0) or (R > N) or (N > 1754) then
	begin
		Result := 0.0;
		Exit;
	end;
	Result := 1.0;
	if (R = 0) or (R = N) then
		Exit;
	if R > N div 2 then
		R := N - R;
	K := 2;
	try
		for I := N - R + 1 to N do
		begin
			Result := Result * I;
			if K <= R then
			begin
				Result := Result / K;
				Inc (K);
			end;
		end;
		Result := Int (Result + 0.5);
	except
		Result := -1.0
	end;
end;

end.
