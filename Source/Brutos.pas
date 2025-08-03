unit Brutos;

interface

uses
  SysUtils, Dados, FrmJanelaEspera;

type
  TBrutos = class (TDados)
  public
    procedure LeArquivo (PathFile: String; CharComent: Char); override;
    procedure AgrupaClasses; override;
  end;

implementation


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO LeArquivo - - - - - - - - - - - - - - - - - -
 Le um arquivo de dados brutos do usuário e atualiza os seguintes atributos:
 DadosUser, MinElemento, MaxElemento, SomaDados.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TBrutos.LeArquivo(PathFile: String; CharComent: Char);
var
  arq            : TextFile;
  i, ContElemento: Integer;
  linha, Elemento: String;
  ElementoReal   : Extended;
begin
  AssignFile(arq, PathFile);
  try
    Reset(arq);
  except
		raise Exception.Create ('Arquivo não pôde ser aberto!');
  end;

  ContElemento := 0;

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
      if not (Linha[1] = CharComent) then  // Se caractere não for comentário...
        for i:=1 to Length(Linha)+1 do     // Percorre todo string em busca de elementos
          if Linha[i] in ['0','1','2','3','4','5','6','7','8','9',',','.'] then
            begin
              if Linha[i] = '.' then       // Ajusta Separador de Decimais
                Elemento := Elemento + ','
              else
                Elemento := Elemento + Linha[i]
            end
          else
            { Insere Elemento na Matriz de Dados e Info. Estatísticas .... }
            { ------------------------------------------------------------ }
            try
              ElementoReal := StrToFloat(Elemento);

              SetLength (DadosUser, ContElemento+1);   // Aloca tamanho p/ vetor
              DadosUser[ContElemento] := ElementoReal;

              if ContElemento = 0 then
                begin
                  MinElemento := ElementoReal;
                  MaxElemento := ElementoReal;
                end;

              if ElementoReal < MinElemento then       // Atualiza Maior e Menor
                MinElemento := ElementoReal            // valores do conjunto
              else if ElementoReal > MaxElemento then
                MaxElemento := ElementoReal;

              SomaDados := SomaDados + ElementoReal;   // Atualiza SomaTotal

              Inc (ContElemento);      // Atualiza contador e variável
              Elemento := '';
            except
            end;
    except;
    end;
  end;
  TotElementos := ContElemento;        // Atualiza Total de Elementos
  FreeAndNil (JanelaEsp);
  CloseFile(arq);
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO LeArquivo - - - - - - - - - - - - - - - - - -
 Agrupa as classes (InterIni, InterFin e QtdElemento) de acordo com o número
 de intervalos especificados anteriormente.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TBrutos.AgrupaClasses;

  { Calcula a quantidade de elementos dado um limite inferior e superior }
  function CalculaQtd (LimInf, LimSup : Real; Ult: Boolean): Integer;
  var
    Qtd, i : Integer;
  begin
    Qtd := 0;

    for i:=Low(DadosUser) to High(DadosUser) do
      if not Ult then
        begin
          if (DadosUser[i] >= LimInf) and (DadosUser[i] < LimSup) then
            Inc(Qtd);
        end
      else if (DadosUser[i] >= LimInf) and (DadosUser[i] <= LimSup) then
        Inc(Qtd);

    CalculaQtd := Qtd;
  end;

const
  CORRECAO = 0.2;  // fator de correção para valores extremos (mínimo e máximo)
var
  i    : Byte;
  Lista: array of Real;
  TotClasse: Integer;

begin
  Finalize (InterIni);
  Finalize (InterFin);
  Finalize (QtdElemento);

  SetLength(Lista, NumIntervalo);        // ajusta tamanho de Lista
  SetLength(InterIni, NumIntervalo);     // ajusta tamanho de InterIni
  SetLength(InterFin, NumIntervalo);     // ajusta tamanho de InterFin
  SetLength(QtdElemento, NumIntervalo);  // ajusta tamanho de QtdElemento

  for i:=0 to NumIntervalo-1 do
    begin
      if i <> 0 then
        Lista[i] := Lista[i-1] + getAmplitude
      else
        Lista[0] := MinElemAgrup;        // salva primeiro intervalo da classe

      if i = 0 then
        TotClasse := CalculaQtd (Lista[i]-CORRECAO, Lista[i] + getAmplitude, False)
      else if i <> NumIntervalo-1 then
        TotClasse := CalculaQtd (Lista[i], Lista[i] + getAmplitude, False)
      else
        TotClasse := CalculaQtd (Lista[i], Lista[i] + getAmplitude + CORRECAO, True);

      InterIni[i] := Lista[i];                // Salva intervalo inicial
      InterFin[i] := Lista[i] + getAmplitude; // Salva intervalo final
      QtdElemento[i] := TotClasse;            // Salva qtd. elementos por intervalo
    end;

  Finalize(Lista);
end;

end.
