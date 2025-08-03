unit FrmPrincipal;

interface

{$IFDEF LINUX}
uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QMenus, QTypes, QButtons, Math,
  FrameConjuntoDados, FrameResumo, FrameAgrupamento, FrameQuiQuadrado, FrameKS,
  Opcoes, Dados, Parametros, Distribuicao, FrmGrafico, FrameResultado;
{$ENDIF}

{$IFDEF MSWINDOWS}
uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QMenus, QTypes, QButtons, Math, ShellApi, Windows, 
  FrameConjuntoDados, FrameResumo, FrameAgrupamento, FrameQuiQuadrado, FrameKS,
  Opcoes, Dados, Parametros, Distribuicao, FrmGrafico, FrameResultado;
{$ENDIF}

type
  TFormPrincipal = class(TForm)
  published
    ODDados       : TOpenDialog;
    StatusBar     : TStatusBar;
    { Menu }
    MainMenu      : TMainMenu;
    N1            : TMenuItem;
    N2            : TMenuItem;
    N3            : TMenuItem;
    N4            : TMenuItem;
    MArquivo      : TMenuItem;
    MIAbrirDados: TMenuItem;
    MIAbrirDadosBrutos: TMenuItem;
      MIFechar    : TMenuItem;
      MISair      : TMenuItem;
    { Menu Ver }
    MVer          : TMenuItem;
      MIVisualizar: TMenuItem;
      MIGrafico   : TMenuItem;
    { Menu Opções }
    MOpcoes       : TMenuItem;
      MCasasDecimais: TMenuItem;
        MI1 : TMenuItem;
        MI2 : TMenuItem;
        MI3 : TMenuItem;
        MI4 : TMenuItem;
        MI5 : TMenuItem;
        MI6 : TMenuItem;
        MI7 : TMenuItem;
        MI8 : TMenuItem;
        MI9 : TMenuItem;
        MI10: TMenuItem;
        MI11: TMenuItem;
        MI12: TMenuItem;
        MI13: TMenuItem;
        MI14: TMenuItem;
    MExecAuto     : TMenuItem;
      MIExecutarK2: TMenuItem;
      MIExecutarKS: TMenuItem;
    MTipoDado     : TMenuItem;
      MIDiscreto  : TMenuItem;
      MIContinuo  : TMenuItem;
    { Menu Distribuições }
    MDistribuicao  : TMenuItem;
    MContinuas     : TMenuItem;
      MINormal     : TMenuItem;
      MIExponencial: TMenuItem;
      MILoglogistic: TMenuItem;
      MIGama       : TMenuItem;
      MIUniforme   : TMenuItem;
      MITriangular : TMenuItem;
      MIWeibull    : TMenuItem;
    MDiscretas     : TMenuItem;
      MIPoisson    : TMenuItem;
      MIBinomial   : TMenuItem;
      MIBinomialN  : TMenuItem;
      MIUniformeD  : TMenuItem;
      MIGeometrica : TMenuItem;
      MICPAvaDisPro: TMenuItem;
    { Menu Testes }
    MTestes        : TMenuItem;
      MIQuiQuadrado: TMenuItem;
      MIKS         : TMenuItem;
    { Menu Ajuda }
    MAjuda        : TMenuItem;
      IMConteudo  : TMenuItem;
      IMLicenca   : TMenuItem;
      IMSobre     : TMenuItem;
    FConjuntoDados: TFConjuntoDados;
    FResumo       : TFResumo;
    FAgrup        : TFAgrup;
    FResul        : TFResultado;
    FQuiQuad      : TFQuiQuadrado;
    FKS           : TFKS;

    procedure FormCreate (Sender: TObject);                                {01}
    procedure FormDestroy (Sender: TObject);                               {02}
    procedure MIAbrirDadosClick(Sender: TObject);                          {03}
    procedure MIFecharClick (Sender: TObject);                             {04}
    procedure MISairClick (Sender: TObject);                               {05}
    procedure MIVisualizarClick (Sender: TObject);                         {06}
    procedure MIGraficoClick (Sender: TObject);                            {07}
    procedure MITipoDadoClick(Sender: TObject);                            {08}
    procedure MIExecutarTestesClick(Sender: TObject);                      {09}
    procedure MIDistroClick (Sender: TObject);                             {10}
    procedure MICPAvaDisProClick(Sender: TObject);                         {11}
    procedure MIQuiQuadradoClick(Sender: TObject);                         {12}
    procedure IMSobreClick(Sender: TObject);                               {13}
    procedure MontaHint (Sender: TObject);                                 {14}
    procedure CriaObjetoDistro(Sender: TMenuItem);                         {15}
    procedure EstimaParametros;                                            {16}
    procedure AtivaElementosTeste;                                         {17}

  public
    { ATRIBUTOS GERAIS ------------------------------------------------------- }
    ArqAberto     : Boolean;        { Controla se arq. dados está aberto }
    NomeArq       : String;         { Caminho completo do arquivo de dados }
    ArqDadosBrutos: Boolean;        { True, se Dados Brutos; False, se não }
    XOp           : TOpcoes;        { Objeto de Opções gerais do sistema }
    Dados         : TDados;         { Objeto de Dados do sistema }
    Parametro     : TParametro;     { Objecto de Parametros de DP }
    Distro        : TDistribuicao;  { Objeto para DP }
    OldCasaDec    : TMenuItem;      { Opção Menu (Número de casas decimais) }
    DistroAtiva   : TMenuItem;      { Distribuição Ativa no sistema }
    XFormGrafico  : TFormGrafico;   { Objeto para FormGrafico }
    QuiKSTeste    : Boolean;        { True, se executa ambos testes juntos }

  private
    procedure HabilitaDesabilitaControles (status: Boolean; x, y: Integer);{01}
    procedure HabilitaDistros;                                             {02}
  end;

const
  NOME_ARQ = 'output.txt';            // Nome do arquivo de saída.
  NOME_EXE_CP_AVADISPRO = 'CalculoDistro.exe';

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  FrmArqUser, FrmDistribuicao, FrmSobre,
  Brutos, Agrupamento,
  Exponencial, Normal, Gama, LogLogistic, Triangular, Uniforme, Weibull,
  Binomial, BinomialNegativa, Geometrica, Poisson, UniformeDiscreta,
  QuiQuadrado, KS, Util, FrmLicenca;

const
  MIN_COD_TAG_ENABLED = 21;           // Valor mínimo de elem. menu
  MAX_COD_TAG_ENABLED = 50;           // Valor máximo de elem. menu
  DIF = 20;                           // Diferença para fazer DP iniciar em 1
  MIN_VL_TAG = 1;                     // Mínimo valor de casas dec.
  MAX_VL_TAG = 14;                    // Máximo valor de casas dec.

var
  XFormArqUser: TFormArqUser;
  XUtil       : TUtil;

{$R *.xfm}

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementação de Métodos Published                     }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED FormCreate - - - - - - - - - - - - - - - -
 Realiza definições iniciais do AvaDisPro.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
procedure TFormPrincipal.FormCreate(Sender: TObject);

  function DescobreCompCasasDec (x: Byte): TMenuItem;
  var
    i: Byte;
    PtrComp: TMenuItem;
  begin
    PtrComp := nil;
    for i:=0 to ComponentCount-1 do
      if (Components[i].Tag) = x then
        begin
          PtrComp := Components[i] as TMenuItem;
          Break;
        end;
      Result := PtrComp;
  end;

begin
  ArqDadosBrutos := True;            // Valor Inicial para ArqDadosBrutos
  XOp := TOpcoes.Cria;               // Cria objeto para pegar opções padrão
  XOp.LeOpcoes;                      // Le Opcoes padrão do AvaDisPro.ini

  FAgrup.SEIntervalo.Value := XOp.NINTERVALO;          // Ajusta definições

  if XOp.DIGITOS > 0 then begin
    OldCasaDec := DescobreCompCasasDec (XOp.DIGITOS);  // iniciais do usuário
    MITipoDadoClick (OldCasaDec);
  end
  else
    MITipoDadoClick (MI2);

  if XOp.TIPODADO = 1 then           // Dados Contínuos
    MITipoDadoClick (MIContinuo)
  else
    MITipoDadoClick (MIDiscreto);    // Dados Discretos

  if XOp.SALVAR_Q2 = 1 then
    MIExecutarK2.Checked := True;    // Executar automaticamente qui-quadrado

  if XOp.SALVAR_KS = 1 then
    MIExecutarKS.Checked := True;    // Executar automaticamente K-S

  Application.OnHint := MontaHint;

  MIFecharClick (Sender);
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED FormDestroy - - - - - - - - - - - - - - - -
 Salva as configurações do usuário.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02 }
procedure TFormPrincipal.FormDestroy(Sender: TObject);
var
  Ops : array of Integer;
begin
  SetLength(Ops, 4);

  Ops[0] := FAgrup.SEIntervalo.Value;  // Qtd. Intervalos
  if MIContinuo.Checked then
    Ops[1] := 1                        // Tipo de Dado
  else
    Ops[1] := 0;
  if MIExecutarK2.Checked then         // Executar automaticamente qui-quadrado
    Ops[2] := 1
  else
    Ops[2] := 0;
  if MIExecutarKS.Checked then         // Executar automaticamente K-S
    Ops[3] := 1
  else
    Ops[3] := 0;

  XOp.GravaOpcoes(Ops);

  Finalize(Ops);
  FreeAndNil(XOp);
  FreeAndNil(Dados);
end;


{ IMPLEMENTAÇÃO DO MÉTODO MIAbrirDadosClick - - - - - - - - - - - - - - - - - -
 Abre um arquivo de dados do usuário.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 03 }
procedure TFormPrincipal.MIAbrirDadosClick(Sender: TObject);
begin
  if Sender = MIAbrirDados then
    ODDados.Title := 'Abrir Conjunto de Dados Tabulados'
  else
    ODDados.Title := 'Abrir Conjunto de Dados Brutos';

  if ODDados.Execute then begin               // abertura de arquivo com sucesso
    if ArqAberto then
      MIFecharClick(Sender);

    ArqAberto := True;
    ArqDadosBrutos := False;
    NomeArq := ODDados.FileName;

    if Sender = MIAbrirDados then             // Cria objeto de dados...
      Dados := TAgrupamento.Create            // Dados Agrupados
    else begin
      Dados := TBrutos.Create;                // Dados Brutos
      ArqDadosBrutos := True;
    end;

    Dados.LeArquivo(NomeArq, XOp.COMENT);     // Le Arquivo de Dados

    HabilitaDesabilitaControles (True, MIN_COD_TAG_ENABLED, MAX_COD_TAG_ENABLED);
    HabilitaDistros;

    if Sender = MIAbrirDadosBrutos then begin
      FConjuntoDados.AtivaElementos(True);    // Ativa elementos Conjunto Dados
      FConjuntoDados.InsereElementos;         // Insere elementos em LVDados
      FResumo.AtivaElementos(True);           // Ativa elementos Resumo
      FResumo.GeraResumo;                     // Gera resumo estatístico
    end
    else                                      // Valida arquivo do usuário
      if not (Dados as TAgrupamento).ValidaAgrupamento then begin
        MIFecharClick(Self);
        Raise Exception.Create('Erro ao ler arquivo: possível má formação de classes.');
      end;

    FAgrup.AtivaElementos(True, False);       // Ativa elementos Agrupamento
    FAgrup.DefineAgrupamentoPadrao;           // Insere elementos em LVAgrupamento

    Caption := Caption + ' - ' +  NomeArq;    // Muda Título do Form

    Parametro := TParametro.Cria;             // Cria objeto de Parametros de DP
    EstimaParametros;                         // Define parâmetros iniciais para DP

    if MIExecutarK2.Checked and MIExecutarKS.Checked then
      QuiKSTeste := True
    else
      QuiKSTeste := False;

    if MIExecutarK2.Checked then              // Executa automaticamente Qui-Quad
      MIQuiQuadradoClick(MIQuiQuadrado);

    if MIExecutarKS.Checked then               // Executa automaticamente K-S
      MIQuiQuadradoClick(MIKS);

    SetFocus;
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIFecharClick - - - - - - - - - - - - - - -
 Fecha o arquivo do usuário, desativa controles e encerra seção do software.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 04 }
procedure TFormPrincipal.MIFecharClick(Sender: TObject);
var
  arq : TextFile;
begin
  FreeAndNil (Dados);                         // Destroi objeto Dados
  FreeAndNil (Parametro);                     // Destroi objeto Parametro

  HabilitaDesabilitaControles (False, MIN_COD_TAG_ENABLED, MAX_COD_TAG_ENABLED);

  ArqAberto := False;
  DistroAtiva := nil;

  if XUtil.FormAtivo (XFormGrafico) then      // Se Grafico Aberto...
    FreeAndNil (XFormGrafico);                // destroi form do Grafico

  if XUtil.FormAtivo (XFormArqUser) then      // Se FormArqUser Aberto...
    FreeAndNil (XFormArqUser);                // destroi form ArqUser

  Caption := 'AvaDisPro 1.0';

  // Desativa elementos de cada Frame
  FConjuntoDados.AtivaElementos (False);      // Desativa elementos dos frames
  FAgrup.AtivaElementos (False, False);
  FResumo.AtivaElementos (False);
  FQuiQuad.AtivaElementos (False, '');
  FKS.AtivaElementos(False, '');
  FResul.AtivaElementos(False);

  // Apagar conteúdo de arquivo output.txt
  try
    AssignFile(arq, ExtractFilePath(Application.ExeName) + NOME_ARQ);
    ReWrite(arq);
    CloseFile(arq);
  except
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MISairClick - - - - - - - - - - - - - - - -
 Finaliza a aplicação.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 05 }
procedure TFormPrincipal.MISairClick(Sender: TObject);
begin
  Application.Terminate;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIVisualizarClick - - - - - - - - - - - - -
 Abre um form para visualizar o arquivo de dados do usuário.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 06 }
procedure TFormPrincipal.MIVisualizarClick(Sender: TObject);
begin
  if not XUtil.FormAtivo (XFormArqUser) then
    begin
      if XFormArqUser <> nil then
        FreeAndNil (XFormArqUser);

      XFormArqUser := TFormArqUser.Cria(NomeArq);
      XFormArqUser.Show;
    end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIGraficoClick - - - - - - - - - - - - - -
 Abre um form para visualizar o gráfico do agrupamento de dados.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 07 }
procedure TFormPrincipal.MIGraficoClick(Sender: TObject);
begin
  if not XUtil.FormAtivo (XFormGrafico) then
    begin
      if XFormGrafico <> nil then
        FreeAndNil (XFormGrafico);

      XFormGrafico := TFormGrafico.Create(Self);

      XFormGrafico.PlotaGrafico(StrToFloat(FAgrup.EVlInicial.Text),
                                StrToFloat(FAgrup.EVlFinal.Text),
                                Dados.QtdElemento, Dados.InterIni,
                                FAgrup.SEIntervalo.Value );
      XFormGrafico.Show;
    end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MITipoDadoClick - - - - - - - - - - - - - -
 Define execução do sistema se Tipo de Dado (contínuo ou discreto) ou
 Casas Decimais (1 a 14) é clicado. Também habilita ou desabilita DP contínuas
 (21..26) ou DP discretas (27..31).
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 08 }
procedure TFormPrincipal.MITipoDadoClick(Sender: TObject);
begin
  // Se opção de clique é para Dados Discretos ................................
  if (Sender as TMenuItem) = MIDiscreto then begin
    MIContinuo.Checked := False;
    HabilitaDesabilitaControles (False, MIN_VL_TAG, MAX_VL_TAG); // Casas Dec.
    XOp.DIGITOS := 0;
  end

  // Se opção de clique é para Dados Contínuos ................................
  else if (Sender as TMenuItem) = MIContinuo then begin
    MIDiscreto.Checked := False;
    HabilitaDesabilitaControles (True, MIN_VL_TAG, MAX_VL_TAG); // Casas Dec.
    try
      XOp.DIGITOS := OldCasaDec.Tag;
    except
    end
  end

  // Se opção de clique é para Casas Decimais .................................
  else begin
    if OldCasaDec <> nil then
      OldCasaDec.Checked := False;            // Desmarca opção de menu anterior
    XOp.DIGITOS := (Sender as TMenuItem).Tag; // Opções recebe novo valor de casas

    OldCasaDec := Sender as TMenuItem;        // OldCasaDec recebe opção atual
  end;

  (Sender as TMenuItem).Checked := True;      // Nova opção de menu é checada

  if ArqAberto then begin                     // se arquivo aberto, executa
    if ArqDadosBrutos then begin
      FConjuntoDados.InsereElementos;         // procedimentos de atualização
      FResumo.GeraResumo;                     // de dados.
      FAgrup.DefineAgrupamentoUsuario;
    end
    else
      FAgrup.DefineAgrupamentoPadrao;

    HabilitaDistros;                          // Habilita controles de DP
    SetFocus;
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIExecutarTestesClick - - - - - - - - - - -
 Marca (ou desmarca) opção para executar automaticamente testes K2 e K-S.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 09 }
procedure TFormPrincipal.MIExecutarTestesClick(Sender: TObject);
begin
  if (Sender as TMenuItem) = MIExecutarK2 then
    if MIExecutarK2.Checked then
      MIExecutarK2.Checked := False
    else
      MIExecutarK2.Checked := True
  else
    if MIExecutarKS.Checked then
      MIExecutarKS.Checked := False
    else
      MIExecutarKS.Checked := True;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIDistroClick - - - - - - - - - - - - - -
 Abre um form com os parâmetros das DP. Se usuário selecionar Teste, executa
 os testes qui-quadrado e K-S.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 10 }
procedure TFormPrincipal.MIDistroClick(Sender: TObject);
begin
  CriaObjetoDistro(Sender as TMenuItem);    // Cria objeto de acordo com a DP escolhida.

  with TFormDistro.Cria(Distro, Parametro, (Sender as TMenuItem).Tag-DIF) do
    try
      ShowModal;
      if Tag = 1 then begin
        CriaObjetoDistro(Sender as TMenuItem); // Recria objeto com parametros atualizados.
        AtivaElementosTeste;                   // Executa Teste x2 (Botão Testar)
        DistroAtiva := Sender as TMenuItem;    // Define DP ativa
      end
    finally
      Free;
    end;

  SetFocus;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MICPAvaDisProClick - - - - - - - - - - - -
 Executa o módulo CP-AvaDisPro
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 11 }
procedure TFormPrincipal.MICPAvaDisProClick(Sender: TObject);
var
  PathFile: String;
begin
  PathFile := ExtractFilePath (Application.ExeName) + NOME_EXE_CP_AVADISPRO;

  XUtil.ExecutaProgramaExterno (PChar(PathFile));
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MIQuiQuadradoClick - - - - - - - - - - - -
 Executa o teste Qui-Quadrado ou o K-S
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 12 }
procedure TFormPrincipal.MIQuiQuadradoClick(Sender: TObject);
var
  i,j,k   : Byte;
  QuiQuad : TQuiQuadrado;
  KS      : TKS;
  Result  : array[1..12] of Extended;
  ResultTH: array[1..12] of Real;
  DistroRe: array[1..12] of String;
  MIDistro: array[1..12] of TMenuItem;
  Aceitou : Boolean;
  arq     : TextFile;
  lin     : String;
  Erro    : Boolean;

  // Tenta abrir o arquivo de destino -----------------------------------------
  procedure AbreArquivo;
  begin
    AssignFile(arq, ExtractFilePath(Application.ExeName) + NOME_ARQ);
    try
      if (QuiKSTeste) and (Sender = MIKS) then begin
        QuiKSTeste := False;
        Append(arq);
        WriteLn(arq, '');
      end
      else
        ReWrite(arq);
    except
  	  raise Exception.Create ('Arquivo de saída de dados não pôde ser criado!');
    end;
  end;
  // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

begin
  MIDistro[1] := MIExponencial;
  MIDistro[2] := MILogLogistic;
  MIDistro[3] := MIGama;
  MIDistro[4] := MINormal;
  MIDistro[5] := MITriangular;
  MIDistro[6] := MIUniforme;
  MIDistro[7] := MIWeibull;
  MIDistro[8] := MIBinomial;
  MIDistro[9] := MIBinomialN;
  MIDistro[10]:= MIGeometrica;
  MIDistro[11]:= MIPoisson;
  MIDistro[12]:= MIUniformeD;

  Erro := False;
  FResul.AtivaElementos(True);               // Ativa Elem. em FResultado

  FQuiQuad.AtivaElementos(False, '');        // Desativa Elem. em FQuiQuad
  FKS.AtivaElementos(False, '');             // Desativa Elem. em FKS

  if MIContinuo.Checked then begin
    j:=1;  k:=7;                             // Intervalo Distr. Contínuas
  end
  else begin
    j:=8;  k:=12;                            // Intevalo Distr. Discretas
  end;

  // Abre arquivo de saída e joga informações nele ----------------------------
  AbreArquivo;

  if Sender = MIQuiQuadrado then begin
    WriteLn(arq, ' SUMÁRIO PARA O TESTE QUI-QUADRADO');
    WriteLn(arq, ' ------- ---- - ----- ------------')
  end
  else begin
    WriteLn(arq, ' SUMÁRIO PARA O TESTE K-S');
    WriteLn(arq, ' ------- ---- - ----- ---')
  end;

  Aceitou := False;
  // Testa cada distribuição com qui-quadrado e K-S ---------------------------
  try
    for i:=j to k do begin                     // aplica Q2 ou K-S para todas DP
      CriaObjetoDistro(MIDistro[i]);

      if Sender = MIQuiQuadrado then begin
        QuiQuad := TQuiQuadrado.Create (Dados, Distro);
        Result[i] := QuiQuad.QuiQuadrado;        // Resultado Qui-Quadrado
        ResultTH[i] := QuiQuad.TesteHipotese;    // Resultado Teste Hipótese
        FreeAndNil(QuiQuad)
      end
      else begin
        KS := TKS.Create(Dados, Distro);
        Result[i] := KS.KS;                      // Resultado K-S
        ResultTH[I] := KS.TesteHipotese;         // Resultado Teste Hipótese
        FreeAndNil(KS);
      end;

      FResul.MResultado.Lines.Add('Testando ' + Distro.getNome +  '...');

      Lin := ' ' + UpperCase(Distro.getNome) + ' (' + Distro.getNomePar1 + ': ' +
             FloatToStrF(Distro.getPar1, ffNumber, 6, 2);

      if Distro.getNumPar >= 2 then             // 2 parâmetros
        Lin := Lin + ', ' + Distro.getNomePar2 + ': ' +
               FloatToStrF(Distro.getPar2, ffNumber, 6, 2);

      if Distro.getNumPar = 3 then             // 3 parâmetros
        Lin := Lin + ', ' + Distro.getNomePar3 + ': ' +
               FloatToStrF(Distro.getPar3, ffNumber, 6, 2);

      WriteLn(arq, Lin + ')');

      if Sender = MIQuiQuadrado then
        Lin := ' Qui-Quadrado: ' + FloatToStrF(Result[i], ffNumber, 6, 3)
      else
        Lin := ' K-S: ' + FloatToStrF(Result[i], ffNumber, 6, 3);

      if ResultTH[i] <> 0 then begin
        WriteLn(arq, Lin + ' -> Aceita a ' + FloatToStr(ResultTH[i]) + '% de significância');
        DistroRe[i] := Distro.getNome;
        Aceitou := True;
      end
      else
        WriteLn(arq, Lin + ' -> Rejeitada');

      WriteLn(arq, '');
    end;

    if Sender = MIQuiQuadrado then
      WriteLn(arq, ' Distribuições Recomendadas' + ' (Qui-Quadrado)')
    else
      WriteLn(arq, ' Distribuições Recomendadas' + ' (K-S)');
    WriteLn(arq, ' ------------- ------------');

    for i:=j to k do begin
      if ResultTH[i] <> 0 then
        WriteLn(arq, ' ' + DistroRe[i]);
    end;
    if not Aceitou then
      WriteLn(arq, ' Nenhuma distribuição foi aceita');
  except
    if Sender = MIQuiQuadrado then
      WriteLn(arq, ' Erro ao aplicar Qui-Quadrado na distribuição '+Distro.getNome + '.')
    else
      WriteLn(arq, ' Erro ao aplicar K-S na distribuição '+Distro.getNome + '.');
    WriteLn(arq, ' Por favor, verifique os parâmetros desta distribuição e');
    WriteLn(arq, ' tente utilizar este teste novamente depois.');
    Erro := True;
  end;

  CloseFile(arq); // --------------------------------------------------------

  with FResul.MResultado.Lines do begin
    Add('');
    if Erro then
      Add ('Ocorreu um erro ao testar uma distribuição.')
    else
      Add('Testes concluídos com sucesso!');
    Add('Clique em Detalhes para ver os resultados.');
    Add('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
    Add('');
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED IMSobreClick - - - - - - - - - - - - - - - -
 Abre um form com a janela Sobre...
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 13 }
procedure TFormPrincipal.IMSobreClick(Sender: TObject);
var
 URL : String;
 Resul: Byte;
begin
  if Sender = IMSobre then
    with TFormSobre.Create(Self) do
      try
        ShowModal;
      finally
        Free;
      end
  else if Sender = IMLicenca then
     with TFormLicenca.Create(Self) do
      try
        ShowModal;
      finally
        Free;
      end
  else if Sender = IMConteudo then begin
    URL := ExtractFilePath(Application.ExeName) + '\Ajuda\index.htm';
    {$IFDEF MSWINDOWS}
    Resul := ShellExecute (0, nil, pChar(URL), '', '', SW_SHOW);

    if (Resul = ERROR_FILE_NOT_FOUND) or (Resul = ERROR_PATH_NOT_FOUND)	then
      Raise Exception.Create('Não foi possível localizar o índice de ajuda.'+#10+
                             'Reinstale o AvaDisPro se o problema persistir.');
    {$ENDIF}                         
  end;
  SetFocus;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED MontaHint - - - - - - - - - - - - - - - -
 Adiciona em StatusBar as dicas de cada item de menu.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 14 }
procedure TFormPrincipal.MontaHint(Sender: TObject);
begin
  StatusBar.Panels[0].Text := Application.Hint;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED CriaObjetoDistro - - - - - - - - - - - - -
 Cria o objeto Distro, de acordo com o item Sender.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 15 }
procedure TFormPrincipal.CriaObjetoDistro(Sender: TMenuItem);
begin
  FreeAndNil (Distro);

  with Parametro do
    if Sender = MIExponencial then
      Distro := TExponencial.Create(getParam(Sender.Tag-DIF, 1))

    else if Sender = MIGama then
      Distro := TGama.Create(getParam(Sender.Tag-DIF, 1),
                             getParam(Sender.Tag-DIF, 2) )

    else if Sender = MILoglogistic then
      Distro := TLogLogistic.Create(getParam(Sender.Tag-DIF, 1),
                                    getParam(Sender.Tag-DIF, 2) )

    else if Sender = MINormal then
      Distro := TNormal.Create(getParam(Sender.Tag-DIF, 1),
                               getParam(Sender.Tag-DIF, 2) )

    else if Sender = MITriangular then
      Distro := TTriangular.Create(getParam(Sender.Tag-DIF, 1),
                                   getParam(Sender.Tag-DIF, 2),
                                   getParam(Sender.Tag-DIF, 3) )

    else if Sender = MIUniforme then
      Distro := TUniforme.Create(getParam(Sender.Tag-DIF, 1),
                                 getParam(Sender.Tag-DIF, 2) )

    else if Sender = MIWeibull then
      Distro := TWeibull.Create(getParam(Sender.Tag-DIF, 1),
                                getParam(Sender.Tag-DIF, 2) )

    else if Sender = MIBinomial then
      Distro := TBinomial.Create(Trunc(getParam(Sender.Tag-DIF, 1)),
                                 getParam(Sender.Tag-DIF, 2) )

    else if Sender = MIBinomialN then
      Distro := TBinomialNegativa.Create(Trunc(getParam(Sender.Tag-DIF, 1)),
                                         getParam(Sender.Tag-DIF, 2) )

    else if Sender = MIGeometrica then
      Distro := TGeometrica.Create(getParam(Sender.Tag-DIF, 1))

    else if Sender = MIPoisson then
      Distro := TPoisson.Create(getParam(Sender.Tag-DIF, 1) )

    else if Sender = MIUniformeD then
      Distro := TUniformeDiscreta.Create(Trunc (getParam(Sender.Tag-DIF, 1)),
                                         Trunc (getParam(Sender.Tag-DIF, 2)));
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED EstimaParametros - - - - - - - - - - - - - - -
 Estima os parâmetros das distribuições de probabilidade do sistema.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 16}
procedure TFormPrincipal.EstimaParametros;
var
  Media, DP, Min, Max: Real;
  n: Integer;
begin
  Media := Dados.getMedia;
  DP := Dados.getDP;
  Min := Dados.InterIni[0];
  Max := Dados.InterFin[High(Dados.InterFin)];
  n := Dados.getTotElementos;

  with Parametro do begin
    // Distribuição Exponencial
    setParam (MIExponencial.Tag-DIF, 1, Media);

    // Distribuição Gamma
    setParam (MIGama.Tag-DIF, 2, Sqr(Media / DP));
    setParam (MIGama.Tag-DIF, 1, Sqr(DP) / Media);

    // Distribuição Log-Logistic
    setParam (MILogLogistic.Tag-DIF, 1, abs(cosecant(pi/DP)));
    setParam (MILogLogistic.Tag-DIF, 2, 1/3*sqr(pi*abs(cosecant(pi/DP))));

    // Distribuição Normal
    setParam (MINormal.Tag-DIF, 1, Media);
    setParam (MINormal.Tag-DIF, 2, DP);

    // Distribuição Triangular
    setParam (MITriangular.Tag-DIF, 1, Min);
    if Max > Abs(Media * 3 - Min - Max) then begin
      setParam (MITriangular.Tag-DIF, 2, Max);
      setParam (MITriangular.Tag-DIF, 3, Abs(Media * 3 - Min - Max))
    end
    else begin
      setParam (MITriangular.Tag-DIF, 3, Max);
      setParam (MITriangular.Tag-DIF, 2, Abs(Media * 3 - Min - Max));
    end;

    // Distribuição Uniforme
    setParam (MIUniforme.Tag-DIF, 1, Min);
    setParam (MIUniforme.Tag-DIF, 2, Max);

     // Distribuição Weibull
    setParam (MIWeibull.Tag-DIF, 1, 1/n*Dados.getSomaDados);
    setParam (MIWeibull.Tag-DIF, 2, Sqr(DP) / Media);

    // Distribuição Binomial
    setParam (MIBinomial.Tag-DIF, 1, n);
    setParam (MIBinomial.Tag-DIF, 2, Media/n);

    // Distribuição Binomial Negativa
    setParam (MIBinomialN.Tag-DIF, 1, n);
    setParam (MIBinomialN.Tag-DIF, 2, n/(Media+n));

    // Distribuição Geométrica
    setParam (MIGeometrica.Tag-DIF, 1, 1/(Media+1));

    // Distribuição Poisson
    setParam (MIPoisson.Tag-DIF, 1, Media);

    // Distribuição Uniforme Discreta
    setParam (MIUniformeD.Tag-DIF, 1, Min);
    setParam (MIUniformeD.Tag-DIF, 2, Max);
  end;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED AtivaElementosTeste - - - - - - - - - - - -
 Ativa os Elementos do testes qui-quadrado e K-S.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 17 }
procedure TFormPrincipal.AtivaElementosTeste;
var
  QuiQuad: TQuiQuadrado;
  KS     : TKS;
begin
  QuiQuad := TQuiQuadrado.Create(Dados, Distro);
  KS := TKS.Create(Dados, Distro);

  FQuiQuad.AtivaElementos(True, Distro.getNome);   // Ativa Elem. FQuiQuadrado
  FQuiQuad.InsereElementos(QuiQuad);               // Insere Elem. em FQuiQuadrado

  FKS.AtivaElementos(True, Distro.getNome);        // Ativa Elm. FKS
  FKS.InsereElementos(KS);                         // Insere Elem. em FKS

  FResul.AtivaElementos(True);                     // Ativa Elem. em FResultado
  FResul.InsereElementos(QuiQuad, KS, Distro);     // Insere Eleem. em FResultado

  FreeAndNil(QuiQuad);                             // Destroi objeto
  FreeAndNil(KS);
end;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementação de Métodos Privados                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ DEFINIÇÃO DO MÉTODO PRIVADO HabilitaDesabilitaControles - - - - - - - - - - -
  Habilita ou Desabilita determinados controles de acordo com o valor de Tag.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01}
procedure TFormPrincipal.HabilitaDesabilitaControles (status: Boolean; x, y: Integer);
var
  i: Byte;
begin
  for i:=0 to ComponentCount-1 do
   if Components[i] is TMenuItem then
     if ((Components[i] as TMenuItem).Tag >= x) and
        ((Components[i] as TMenuItem).Tag <= y) then
       (Components[i] as TMenuItem).Enabled := status;
end;


{ DEFINIÇÃO DO MÉTODO PRIVADO HabilitaDesabilitaControles - - - - - - - - - - -
  Habilita ou Desabilita determinados controles de acordo com o valor de Tag.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02}
procedure TFormPrincipal.HabilitaDistros;
var
  Discreta : Boolean;
begin
  if ArqAberto then begin
    Discreta := False;

    if MIDiscreto.Checked then
      Discreta := True;

    HabilitaDesabilitaControles (Discreta, 28, 32);     // Habil/Desab Discretas
    HabilitaDesabilitaControles (not Discreta, 21, 27); // Habil/Desab Contínuas
  end;
end;

end.
