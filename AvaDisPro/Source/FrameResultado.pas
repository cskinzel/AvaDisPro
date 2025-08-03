unit FrameResultado;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QExtCtrls, QStdCtrls, Distribuicao, QuiQuadrado, KS;

type
  TFResultado = class(TFrame)
  published
    LResultado  : TLabel;
    PQuiQuadrado: TPanel;
    MResultado  : TMemo;
    BDetalhes   : TButton;
    BLimpar     : TButton;
    procedure BDetalhesClick (Sender: TObject);
    procedure BLimparClick (Sender: TObject);
  public
    procedure AtivaElementos (status: Boolean);
    procedure InsereElementos (QuiQuad: TQuiQuadrado; KS: TKS; Distro: TDistribuicao);
  end;

implementation

uses
  FrmDetalhes, FrmPrincipal;

{$R *.xfm}


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FResultado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResultado.AtivaElementos (status: Boolean);
begin
  with MResultado do
    if status then
      Color := clBase
    else
      begin
        Lines.Clear;
        Color := clDisabledForeground;
      end;
  BDetalhes.Enabled := status;
  BLimpar.Enabled := status;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED InsereElementos - - - - - - - - - - - - - - - -
 Insere os elementos do resultado no componente Memo apropriado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResultado.InsereElementos (QuiQuad: TQuiQuadrado; KS: TKS; Distro: TDistribuicao);
var
  arq: TextFile;
  Lin: String;
  TesteHip: Real;
  n: Integer;

  // Imprime QUI-QUADRADO OU K-S ----------------------------------------------
  // Tipo: 1 para Qui-Quadrado; 2, K-S.
  procedure ImprimeTeste (Tipo: Byte);
  var
    i, j, PosIni: Integer;
    aux: String;
  begin
    if Tipo = 1 then begin
      WriteLn(arq, ' TABELA DO TESTE QUI-QUADRADO');
      WriteLn(arq, ' Id  Vl.Ini.  Vl.Fin.      ei%       ei      oi%       oi')
    end
    else begin
      WriteLn(arq, ' TABELA DO TESTE K-S');
      WriteLn(arq, ' Id  Vl.Ini.  Vl.Fin.       ei    Fo(x)    Sn(x)        D');
    end;

    with FormPrincipal.Dados do
      for i:=0 to getNumIntervalo-1 do begin
        PosIni := 13;
        Lin := ' ' + IntToStr(i+1) + '                               ';

        Aux := FloatToStrF (InterIni[i], ffNumber, 6, 2);
        Insert(Aux, Lin, PosIni-Length(Aux));   // Intervalo Inicial
        Inc(PosIni, 9);

        Aux := FloatToStrF (InterFin[i], ffNumber, 6, 2);
        Insert(Aux, Lin, PosIni-Length(Aux));   // Intervalo Final
        Inc(PosIni, 9);

        for j:=0 to 3 do begin      // Tabela Qui-Quadrado ou K-S
          if Tipo = 1 then
            Aux := FloatToStrF (QuiQuad.Matriz[j, i], ffNumber, 6, 2)
          else
            Aux := FloatToStrF (KS.Matriz[j, i], ffNumber, 6, 4);
          Insert(Aux, Lin, PosIni-Length(Aux));
          Inc(PosIni, 9);
        end;
        for j:=Length(Lin) downto 1 do
          if Lin[j] = ' ' then
            SetLength(Lin, Length(Lin)-1)
          else
            break;
        WriteLn(arq, lin);
      end;
    WriteLn(arq, '');
  end;
  // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

begin
  // Abre arquivo de saída e joga informações nele --------------------------
  AssignFile(arq, ExtractFilePath(Application.ExeName) + NOME_ARQ);
  try
    ReWrite(arq);
  except
  	raise Exception.Create ('Arquivo de saída de dados não pôde ser criado!');
  end;

  // Mostra Nome e Parâmetros da Distribuição ---------------------------------
  Lin := ' ' + UpperCase(Distro.getNome) + ' (' + Distro.getNomePar1 + ': ' +
               FloatToStrF(Distro.getPar1, ffNumber, 6, 2);

  if Distro.getNumPar >= 2 then             // 2 parâmetros
    Lin := Lin + ', ' + Distro.getNomePar2 + ': ' +
           FloatToStrF(Distro.getPar2, ffNumber, 6, 2);

  if Distro.getNumPar = 3 then             // 3 parâmetros
     Lin := Lin + ', ' + Distro.getNomePar3 + ': ' +
            FloatToStrF(Distro.getPar3, ffNumber, 6, 2);

  WriteLn(arq, '');
  WriteLn(arq, ' Distribuição' + Lin + ')');

  MResultado.Lines.Add('Distribuição ' + UpperCase(Distro.getNome));

  WriteLn(arq, '');
  MResultado.Lines.Add('');

  // Mostra Aviso sobre tamanho da amostra ------------------------------------
  n := FormPrincipal.Dados.getTotElementos;
  if n <= 30 then begin
    WriteLn(arq, ' AVISO');
    WriteLn(arq, ' Tamanho da amostra menor ou igual a 30 '+'[n = '+IntToStr(n)+'].');
    WriteLn(arq, ' É recomendado ignorar o teste Qui-Quadrado.');
    WriteLn(arq, '');
  end;

  ImprimeTeste(1);       // Imprime tabela teste Qui-Quadrado

  // Qui-Quadrado -------------------------------------------------------------
  Lin := 'Teste Qui-Quadrado: ' + FloatToStrF(QuiQuad.QuiQuadrado, ffNumber, 6, 3);
  WriteLn(arq, ' ' + Lin);
  MResultado.Lines.Add(Lin);

  WriteLn(arq, ' Qui-Quadrado ( 1%): ' + FloatToStr(QuiQuad.DistroQuiQuad(1)));
  WriteLn(arq, ' Qui-Quadrado ( 5%): ' + FloatToStr(QuiQuad.DistroQuiQuad(5)));
  WriteLn(arq, ' Qui-Quadrado (10%): ' + FloatToStr(QuiQuad.DistroQuiQuad(10)));
  WriteLn(arq, ' Qui-Quadrado (25%): ' + FloatToStr(QuiQuad.DistroQuiQuad(25)));
  WriteLn(arq, ' Qui-Quadrado (50%): ' + FloatToStr(QuiQuad.DistroQuiQuad(50)));
  WriteLn(arq, '');

  TesteHip := QuiQuad.TesteHipotese;

  if TesteHip = 0 then
    Lin :='Não há evidências que a variável segue essa distribuição'
  else if TesteHip > 25 then
    Lin :='A 50% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip > 10 then
    Lin :='A 25% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip > 5 then
    Lin := 'A 10% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip > 1 then
    Lin := 'A 5% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip = 1 then
    Lin := 'A 1% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome;

  with MResultado.Lines do
    Add(Lin + '.');

  WriteLn(arq, ' ' + Lin + '.');
  WriteLn(arq, '');

  // K-S ----------------------------------------------------------------------

  ImprimeTeste(2);       // Imprime tabela teste K-S

  Lin := 'Teste K-S: ' + FloatToStrF(KS.KS, ffNumber, 6, 3);
  WriteLn(arq, ' ' + Lin);
  MResultado.Lines.Add(Lin);

  WriteLn(arq, ' K-S ( 1%): ' + FloatToStr(KS.DistroKS(1)));
  WriteLn(arq, ' K-S ( 5%): ' + FloatToStr(KS.DistroKS(5)));
  WriteLn(arq, ' K-S (20%): ' + FloatToStr(KS.DistroKS(20)));
  WriteLn(arq, '');

  TesteHip := KS.TesteHipotese;
  if TesteHip = 0 then
    Lin := 'Não há evidências que a variável segue essa distribuição'
  else if TesteHip > 5 then
    Lin := 'A 20% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip > 1 then
    Lin := 'A 5% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome
  else if TesteHip = 1 then
    Lin := 'A 1% de significância pode-se afirmar que a variável segue a distribuição ' + Distro.getNome;

  with MResultado.Lines do begin
    Add(Lin + '.');
    Add('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
    Add('');
  end;

  WriteLn(arq, ' ' + Lin + '.');

  CloseFile(arq);
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED BDetalhesClick - - - - - - - - - - - - - - - -
 Cria um form para apresentar os detalhes dos testes qui-quadrado e K-S.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResultado.BDetalhesClick(Sender: TObject);
begin
  with TFormDetalhes.Create(Self) do
    try
      try
        MDetalhes.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + NOME_ARQ);
      except
        Raise Exception.Create('Não foi possível abrir arquivo output.txt');
      end;
      ShowModal;
    finally
      Free;
    end;
  SetFocus;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED BLimparClick - - - - - - - - - - - - - - - - -
 Limpa as linhas do componente MResultado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResultado.BLimparClick(Sender: TObject);
begin
  MResultado.Lines.Clear;
end;

end.
