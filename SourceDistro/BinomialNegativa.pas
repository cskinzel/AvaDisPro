unit BinomialNegativa;

interface

uses
  Math, SysUtils, Distribuicao;

type
  TBinomialNegativa = class (TDiscreta)
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
  protected
    function ParametrosValidos (x: Integer): Boolean; override;
  private
    n: Integer;
    p: Extended;
  end;

implementation

uses
  Binomial;

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TBinomialNegativa                          }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TBinomialNegativa.Create (_n: Integer; _p: Extended);
begin
  n := _n;
  p := _p;
end;

function TBinomialNegativa.FPA (x: Integer): Extended;
var
  Soma: Extended;
  i: Integer;
  Binomial: TBinomial;
begin
  if ParametrosValidos (x) then begin
    Binomial := TBinomial.Create (0,0);

    Soma := 0;
    for i:=0 to Trunc(x) do
      Soma := Soma + Binomial.BinomialCoeff(n + i -1, i) * Power (p, n) * Power (1-p, i);
    Result := Soma;

    FreeAndNil(Binomial);
  end
  else
    Result := 0;
end;

function TBinomialNegativa.FDP(x: Integer): Extended;
var
  Binomial: TBinomial;
begin
  if ParametrosValidos (x) then begin
    Binomial := TBinomial.Create (0,0);

    Result := Binomial.BinomialCoeff (n + x -1, x) * Power (p, n) * Power (1 - p, x);

    FreeAndNil(Binomial);
  end
  else
    Result := 0;
end;

function TBinomialNegativa.ProbInter(inf, sup: Integer): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TBinomialNegativa.getNumPar: Byte;
begin
   Result := 2;
end;

function TBinomialNegativa.getNomePar1: String;
begin
   Result := 'n';
end;

function TBinomialNegativa.getNomePar2: String;
begin
  Result := 'p';
end;

function TBinomialNegativa.getNomePar3: String;
begin
  Result := '';
end;

function TBinomialNegativa.getPar1: Extended;
begin
  Result := n;
end;

function TBinomialNegativa.getPar2: Extended;
begin
  Result := p;
end;

function TBinomialNegativa.getPar3: Extended;
begin
  Result := 0;
end;

function TBinomialNegativa.getNome: String;
begin
  Result := 'Binomial Negativa';
end;

function TBinomialNegativa.ParametrosValidos (x: Integer): Boolean;
begin
  if x < 0 then
    raise Exception.Create ('Binomial Negativa: Probabilidade deve ser maior ou igual a zero')
  else if n <= 0 then
    raise Exception.Create ('Binomial Negativa: Parâmetro n deve ser maior que 0')
  else if p < 0 then
    raise Exception.Create ('Binomial Negativa: Parâmetro p deve ser maior ou igual que 0')
  else if (p < 0) or (p > 1) then
    raise Exception.Create ('Binomial Negativa: Parâmetro p deve estar entre 0 e 1')
  else
    Result := True;
end;

end.
