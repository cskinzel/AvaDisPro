unit Normal;

{ Nota de Copyright
  -=-=-=-=-=-=-=-=-
 A função efr faz parte do projeto Pal 1.4, desenvolvida originalmente em Java,
 está sob licença LGPL. }

interface

uses
  Math, SysUtils, Distribuicao;

type
  TNormal = class (TContinua)
  public
    constructor Create (_media, _dp: Extended);
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
    media: Extended;
    dp   : Extended;
    function erf (x: Extended): Extended;
  end;

implementation

uses
  Gama;

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
{                   Implementação da classe TNormal                            }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TNormal.Create (_media, _dp: Extended);
begin
  media := _media;
  dp := _dp;
end;

function TNormal.FPA (x: Extended): Extended;
var
  Y : Extended;
begin
  if ParametrosValidos (x) then
    begin
		  Y := (x - media)/( Sqrt(2.0) * DP);
  		Result := 0.5 * (1.0 + erf (Y) );
    end
  else
    Result := 0;
end;

function TNormal.FDP (x: Extended): Extended;
var
  Y: Extended;
begin
  if ParametrosValidos (x) then
    begin
      Y := ( - Sqr (x - media) / (2 * Sqr(DP) ) );
      Result := 1 / ( DP * Sqrt (2 * PI) ) * Power( e, Y );
    end
  else
    Result := 0;
end;

function TNormal.ProbInter(inf, sup: Extended): Extended;
begin
  Result := FPA(sup) - FPA(inf);
end;

function TNormal.getNumPar: Byte;
begin
   Result := 2;
end;

function TNormal.getNomePar1: String;
begin
   Result := 'Média';
end;

function TNormal.getNomePar2: String;
begin
  Result := 'Desvio Padrão';
end;

function TNormal.getNomePar3: String;
begin
  Result := '';
end;

function TNormal.getPar1: Extended;
begin
  Result := Media;
end;

function TNormal.getPar2: Extended;
begin
  Result := dp;
end;

function TNormal.getPar3: Extended;
begin
  Result := 0;
end;

function TNormal.getNome: String;
begin
  Result := 'Normal';
end;

function TNormal.ParametrosValidos (x: Extended): Boolean;
begin
 if dp <= 0 then
    raise Exception.Create ('Normal: Parâmetro desvio padrão deve ser maior que zero')
  else
    Result := True;
end;


{ DEFINIÇÃO DO MÉTODO PRIVADO efr - - - - - - - - - - - - - - - - - - - - - - -

 - DESCRIÇÃO..: error function and related stuff.
 - ENTRADA....: x
 - SAÍDA......: erf
 - MODIFICA...: -
 - DEPENDÊNCIA: incompleteGammaP
 - REFERÊNCIA.: version $Id: ErrorFunction.java,v 1.2 2001/07/13 14:39:13
                korbinian Exp. Author: Korbinian Strimmer.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TNormal.erf (x: Extended): Extended;
var
  Gama : TGama;
begin
  Gama := TGama.Create(0,0);

  if (x > 0.0) then
    Result := Gama.incompleteGammaP(0.5, x*x)
  else if (x < 0.0) then
		Result := - Gama.incompleteGammaP(0.5, x*x)
	else
  	Result := 0.0;

  FreeAndNil (Gama);
end;

end.
