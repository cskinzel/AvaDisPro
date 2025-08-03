unit Gama;

{ Nota de Copyright
  -=-=-=-=-=-=-=-=-
 As funções incompleteGamma, incompleteGammaP, lnGamma fazem parte do
 projeto Pal 1.4, desenvolvidas originalmente em Java, estão sob licença LGPL. }

interface

uses
  Math, SysUtils, Distribuicao;

type
  TGama = class (TContinua)
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
    function incompleteGammaP (a, x: Extended): Extended;
    function lnGamma (alpha: Extended): Extended;
  protected
    function ParametrosValidos (x: Extended): Boolean; override;
  private
    a: Extended;
    b: Extended;

    function incompleteGamma (x, alpha, ln_gamma_alpha: Extended): Extended;
  end;

implementation

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TExponencial                       }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TGama.Create (_a, _b: Extended);
begin
  a := _a;
  b := _b;
end;

function TGama.FPA (x: Extended): Extended;
begin
  if ParametrosValidos (x) then
     Result := incompleteGammaP(a, x/b)
  else
    Result := 0;
end;

function TGama.FDP (x: Extended): Extended;
begin
  if ParametrosValidos (x) then
    Result := ( Power (b, -a) * Power (x, a-1) / Exp (x/b + lnGamma (a)) )
  else
    Result := 0;
end;

function TGama.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TGama.getNumPar: Byte;
begin
   Result := 2;
end;

function TGama.getNomePar1: String;
begin
   Result := 'Alfa';
end;

function TGama.getNomePar2: String;
begin
  Result := 'Beta';
end;

function TGama.getNomePar3: String;
begin
  Result := '';
end;

function TGama.getPar1: Extended;
begin
  Result := a;
end;

function TGama.getPar2: Extended;
begin
  Result := b;
end;

function TGama.getPar3: Extended;
begin
  Result := 0;
end;

function TGama.getNome: String;
begin
  Result := 'Gama';
end;

function TGama.ParametrosValidos (x: Extended): Boolean;
begin
  if x <= 0 then
    raise Exception.Create ('Gama: Probabilidade deve ser maior que zero')
  else if a <= 0 then
    raise Exception.Create ('Gama: Parâmetro alfa deve ser maior que zero')
  else if b <= 0 then
    raise Exception.Create ('Gama: Parâmetro beta deve ser maior que zero')
  else
    Result := True;
end;


{ DEFINIÇÃO DO MÉTODO PUBLIC incompleteGammaP - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: Calcula a função incompleteGammaP
 - ENTRADA....: a, x.
 - SAÍDA......: incompleteGammaP
 - MODIFICA...: -
 - DEPENDÊNCIA: incompleteGamma
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TGama.incompleteGammaP (a, x: Extended): Extended;
begin
	Result := incompleteGamma (x, a, lnGamma(a) );
end;


{ DEFINIÇÃO DO MÉTODO PRIVADO lnGamma - - - - - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: log Gamma function: ln(gamma(alpha)) for alpha>0, accurate to
                10 decimal places
 - ENTRADA....: alpha
 - SAÍDA......: lnGamma
 - MODIFICA...: -
 - DEPENDÊNCIA: -
 - REFERÊNCIA.: Pike MC & Hill ID (1966) Algorithm 291: Logarithm of the gamma
                function. Communications of the Association for Computing
                Machinery, 9:684
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TGama.lnGamma (alpha: Extended): Extended;
var
  x, z, f : Extended;
begin
  f := 0.0;
  x := alpha;

	if (x < 7) then
    begin
			f := 1;
			z := x-1;

      z := z + 1;
      while (z < 7 ) do
        begin
    	    f := f * z;
          z := z + 1;
        end;

	 	  x := z;
  	  f := -System.Ln(f);
		end;

 	z := 1/(x*x);

  Result := f + (x-0.5)*System.Ln(x) - x + 0.918938533204673 +
		    	  (((-0.000595238095238*z+0.000793650793651) *
			      z-0.002777777777778)*z + 0.083333333333333)/x;
end;


{ DEFINIÇÃO DO MÉTODO PRIVADO incompleteGamma - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: Returns the incomplete gamma ratio I(x,alpha) where x is the
                upper limit of the integration and alpha is the shape parameter.
 - ENTRADA....: x, alpha, ln_gamma_alpha
 - SAÍDA......: incompleteGamma
 - MODIFICA...: -
 - DEPENDÊNCIA: -
 - REFERÊNCIA.: RATNEST FORTRAN by
                Bhattacharjee GP (1970) The incomplete gamma integral.
                Applied Statistics, 19: 285-287 (AS32)
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TGama.incompleteGamma (x, alpha, ln_gamma_alpha: Extended): Extended;
const
  accurate = 1e-8;
  overflow = 1e30;
var
  p, g: Extended;
  factor, gin, rn, a, b, an, dif, term : Extended;
	pn0, pn1, pn2, pn3, pn4, pn5: Extended;

begin
  p := alpha;
  g := ln_gamma_alpha;

 if (x = 0.0) then begin
   Result := 0.0;
   Exit;
 end;

 if (x < 0.0) or (p <= 0.0) then
   raise EMathError.Create ('Arguments out of bounds');

 factor := System.Exp (p*System.Ln(x)-x-g);

	if (x > 1) and (x >= p) then
		begin
			// continued fraction
			a    := 1 - p;
			b    := a + x + 1;
			term := 0;
			pn0  := 1;
			pn1  := x;
			pn2  := x + 1;
			pn3  := x * b;
			gin  := pn2 / pn3;

	 		while (true) do
  			begin
          a := a + 1;
          b := b + 2;
				  term := term + 1;
 				  an := a * term;
				  pn4 := b * pn2 - an * pn0;
				  pn5 := b * pn3 - an * pn1;

				  if (pn5 <> 0) then
            begin
  					  rn := pn4 / pn5;
					    dif := System.Abs(gin - rn);
					    if (dif <= accurate) then
					      if (dif <= accurate * rn) then
  						  	break;
					    gin := rn;
				    end;

				  pn0 := pn2;
				  pn1 := pn3;
				  pn2 := pn4;
				  pn3 := pn5;
				  if ( System.Abs(pn4) >= overflow) then begin
					  pn0 := pn0 / overflow;
					  pn1 := pn1 / overflow;
					  pn2 := pn2 / overflow;
					  pn3 := pn3 / overflow;
				  end
			  end;
			gin := 1 - factor * gin;
		end
		else begin
			// series expansion
			gin := 1;
			term := 1;
			rn := p;
	 		while (term > accurate) do
			 begin
				rn := rn + 1;
				term := term * (x/rn);
				gin := gin + term;
			end;
			gin := gin * (factor/p);
		end;
	Result := gin;
end;

end.
