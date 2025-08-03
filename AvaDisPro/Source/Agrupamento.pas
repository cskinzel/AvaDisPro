unit Agrupamento;

interface

uses
  SysUtils, Dados, FrmJanelaEspera;

type
  TAgrupamento = class (TDados)
  public
    procedure LeArquivo (PathFile: String; CharComent: Char); override;
    procedure AgrupaClasses; override;
    function ValidaAgrupamento: Boolean;
  end;

implementation

{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO LeArquivo - - - - - - - - - - - - - - - - - -
 Le um arquivo de dados tabulados do usuário e atualiza os seguintes atributos:
 InterIni, InterFin e QtdElemento.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TAgrupamento.LeArquivo(PathFile: String; CharComent: Char);
var
  arq                : TextFile;
  i, j, QtdIntervalos: Integer;
  linha, Elemento    : String;
  LinhaDado          : array [1..3] of String;
  ContElemento       : Integer;
  XSomaDados         : Extended;
begin
  AssignFile(arq, PathFile);
  try
    Reset(arq);
  except
		raise Exception.Create ('Arquivo não pôde ser aberto!');
  end;

  QtdIntervalos := 0;
  ContElemento := 0;
  XSomaDados := 0;

  // Cria objeto JanelaEsp p/ mostrar barra de progresso
  JanelaEsp := TFormJanelaEspera.Criar('Abrindo arquivo. Aguarde...');
  with JanelaEsp do begin
    Show;
    Update;
    IniciaBarra(0, EstimaProgressBar (arq), 0);
  end;

  while not EOF(arq) do begin
    JanelaEsp.AtualizaBarra (1);

    ReadLn (arq, linha);
    Elemento := '';
    try
      j := 1;
      if not (Linha[1] = CharComent) then begin
        for i:=1 to Length(Linha)+1 do    // Percorre todo string em busca de elementos
          if Linha[i] in ['0','1','2','3','4','5','6','7','8','9',',','.'] then
            begin
              if Linha[i] = '.' then      // Ajusta Separador de Decimais
                Elemento := Elemento + ','
              else
                Elemento := Elemento + Linha[i]
            end
          else
            try
              StrToFloat(Elemento);
              LinhaDado[j] := Elemento;
              if j = 3 then begin
                Inc(QtdIntervalos);

                SetLength(InterIni, QtdIntervalos);
                SetLength(InterFin, QtdIntervalos);
                SetLength(QtdElemento, QtdIntervalos);

                InterIni[QtdIntervalos-1] := StrToFloat(LinhaDado[1]);
                InterFin[QtdIntervalos-1] := StrToFloat(LinhaDado[2]);
                QtdElemento[QtdIntervalos-1] := StrToInt(LinhaDado[3]);

                ContElemento := ContElemento + QtdElemento[QtdIntervalos-1];
                XSomaDados := XSomaDados + (InterFin[QtdIntervalos-1] +
                              InterIni[QtdIntervalos-1])/2 * QtdElemento[QtdIntervalos-1];

                Break;
              end;
              Elemento := '';
              Inc(j);
            except
            end;
        end;
    except
    end;
  end;
  NumIntervalo := QtdIntervalos;  // Atualiza total de intervalos
  TotElementos := ContElemento;   // Atualiza total de elementos
  SomaDados    := XSomaDados;     // Atualiza soma de dados

  FreeAndNil (JanelaEsp);
  CloseFile(arq);
end;


procedure TAgrupamento.AgrupaClasses;
begin
  // Sem implementação.
end;


function TAgrupamento.ValidaAgrupamento: Boolean;
var
  Erro: Boolean;
  i: Byte;
begin
  Erro := False;

  if (InterIni = Nil) or (InterFin = Nil) then
    Erro := True;

  if not Erro then
    for i:=Low(InterIni) to High(InterIni) do
      if InterIni[i] >= InterFin[i] then begin
        Erro := True;
        Break;
      end;

  Result := not Erro;
end;

end.
