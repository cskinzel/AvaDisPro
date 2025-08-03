unit Parametros;

interface

uses
  QDialogs;

const
  TOT_DISTRO = 12;         // Numero total de DP
  TOT_PAR = 3;             // Número máximo de parâmetros por DP

type
  TParametro = class (TObject)
  public
    constructor Cria;
    procedure setParam (IndDistro, NumPar: Byte; x: Extended);
    function getParam (IndDistro, NumPar: Byte): Extended;
  private
    MatrizPar: array[1..TOT_DISTRO, 1..TOT_PAR] of Extended;
  end;

implementation


{ IMPLEMENTAÇÃO DO CONSTRUTOR Cria - - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TParametro.Cria;
var
  i, j: Byte;
begin
  for i:=1 to TOT_DISTRO do
    for j:=1 to TOT_PAR do
      MatrizPar[i,j] := 0;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO setParam - - - - - - - - - - - - - - - - - -
 Ajusta o parâmetro NumPar, da distribuição IndDistro.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TParametro.setParam(IndDistro, NumPar: Byte; x: Extended);
begin
  try
    MatrizPar[IndDistro, NumPar] := x;
  except
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO getParametro - - - - - - - - - - - - - - - -
 Obtém o parâmetro NumPar, da distribuição IndDistro.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
function TParametro.getParam (IndDistro, NumPar: Byte): Extended;
begin
  try
    Result := MatrizPar[IndDistro, NumPar];
  except
    Result := 0;
  end;
end;

end.
