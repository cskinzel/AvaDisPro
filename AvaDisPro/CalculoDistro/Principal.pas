unit Principal;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QButtons, QComCtrls, QExtCtrls, QMask, Distribuicao;

const
  TOT_DISTRO = 12;
  MAX_PAR = 3;

type
  TFormPrincipal = class(TForm)
  published
    PCDistro: TPageControl;
      TSUniforme   : TTabSheet;
      TSExpo       : TTabSheet;
      TSNormal     : TTabSheet;
      TSGama       : TTabSheet;
      TSWeibull    : TTabSheet;
      TSTriangular : TTabSheet;
      TSLogLogistic: TTabSheet;
      TSBinomial   : TTabSheet;
      TSNBinomial  : TTabSheet;
      TSGeometrica : TTabSheet;
      TSUniformeDis: TTabSheet;
      TSPoisson    : TTabSheet;
      CBPercentual : TCheckBox;
      BBCalcular   : TBitBtn;
      BBLimpar     : TBitBtn;
      BBSair       : TBitBtn;
      SEPrecisao   : TSpinEdit;
    EX    : TEdit;
    EPar1 : TEdit;
    EPar2 : TEdit;
    EPar3 : TEdit;
    LPar1 : TLabel;
    LPar2 : TLabel;
    LPar3 : TLabel;
    LFDP  : TLabel;
    EFDP  : TEdit;
    EFPA  : TEdit;
    Panel : TPanel;
    procedure FormCreate (Sender: TObject);                                {01}
    procedure BBCalcularClick (Sender: TObject);                           {02}
    procedure BBLimparClick(Sender: TObject);                              {03}
    procedure BBSairClick(Sender: TObject);                                {04}
    procedure PCDistroChange (Sender: TObject);                            {05}
  private
    { Lista de par�metros em TEdit, recebe uma refer�ncia aos componentes
      nesta ordem: EPar1, EPar2, EPar3, EX, EFDP, EFPA }
    Parametros : array[1..6] of TEdit;

    { Matriz que guarda todos os valores de Parametros e DadosDistro de cada DP }
    MatrizDados: array[1..TOT_DISTRO, 1..6] of Real;

    { Lista de par�metros de uma DP em formato Real }
    ParReal    : array[1..MAX_PAR] of Extended;

    { Objeto Distribui��o }
    Distro     : TDistribuicao;

    procedure InicializaParReal;                                           {06}
    procedure AtualizaParametros;                                          {07}
    procedure AtualizaValores (Ordem: Byte; Salva: Boolean);               {08}
    procedure CriaDistro;                                                  {09}
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  Exponencial, Uniforme, Normal, Weibull, Gama, Triangular, LogLogistic,
  Binomial, BinomialNegativa, Geometrica, Poisson, UniformeDiscreta, Util;

var
  XUtil: TUtil;

{$R *.xfm}

{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementa��o de M�todos Published                     }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ IMPLEMENTA��O DO M�TODO PUBLISHED FormCreate - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  i, j: Word;
begin
  AtualizaParametros;
  PCDistroChange (FormPrincipal);
  InicializaParReal;

  for i:=1 to TOT_DISTRO do     // Inicializa matriz de par�metros
    for j:=1 to 5 do
      MatrizDados[i,j] := 0;
end;


{ IMPLEMENTA��O DO M�TODO PUBLISHED BBCalcularClick - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02 }
procedure TFormPrincipal.BBCalcularClick(Sender: TObject);
var
  i : Byte;
  X_Dis: Integer;
  X_Con, ResulFPA, ResulFDP: Real;
begin
  // Guarda em ParReal os par�metros duma DP ..................................
  for i:=1 to MAX_PAR do
    try
      ParReal[i] := StrToFloat ( (Parametros[i] as TEdit).Text )
    except
      if i = 1 then
        ActiveControl := EPar1
      else if i = 2 then
        ActiveControl := EPar2
      else if i = 3 then
        ActiveControl := EPar3;
      Raise Exception.Create('Um ou mais par�metros est�o inv�lidos');
    end;

  CriaDistro;

  // DP CONT�NUAS .............................................................
  if Distro.ClassParent = TContinua then begin
    try                                      // Tenta converter valor de X
      X_Con := StrToFloat (EX.Text);         // ... em formato Real
    except
      ActiveControl := EX;
      Raise Exception.Create ('O valor de X � inv�lido');
    end;

    ResulFPA := (Distro as TContinua).FPA (X_Con);    // Calcula FPA
    ResulFDP := (Distro as TContinua).FDP (X_Con);    // Calcula FDP
  end

  // DP DISCRETAS .............................................................
  else begin
    try
      X_Dis := StrToInt (EX.Text);    // Tenta converter valor de X
    except                            // ... em formato Inteiro
      ActiveControl := EX;
      Raise Exception.Create('O valor de X � inv�lido');
    end;

    ResulFPA := (Distro as TDiscreta).FPA (X_Dis);
    ResulFDP := (Distro as TDiscreta).FDP (X_Dis);
  end;

  FreeAndNil (Distro);

  if CBPercentual.Checked then begin  // Mostra Resultado do C�lculo
    EFPA.Text := FloatToStrF (ResulFPA * 100, ffFixed, 4, 2);
    EFDP.Text := FloatToStrF (ResulFDP * 100, FFFixed, 4, 2);
  end
  else begin
    EFPA.Text := FloatToStrF (ResulFPA, ffFixed, 16, SEPrecisao.Value);
    EFDP.Text := FloatToStrF (ResulFDP, ffFixed, 16, SEPrecisao.Value);
  end;

  // Adiciona valores corretos para os dados
  AtualizaValores (PCDistro.ActivePage.PageIndex+1, True);
end;


{ IMPLEMENTA��O DO M�TODO PUBLISHED BBLimparClick - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 03 }
procedure TFormPrincipal.BBLimparClick(Sender: TObject);
var
  i: Word;
begin
  with FormPrincipal do
    for i:=0 to ComponentCount-1 do
      if Components[i] is TEdit then
        (Components[i] as TEdit).Text := '0';

  // Adiciona valores corretos para os dados
  AtualizaValores (PCDistro.ActivePage.PageIndex+1, True);
end;


{ IMPLEMENTA��O DO M�TODO PUBLISHED BBSairClick - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 04 }
procedure TFormPrincipal.BBSairClick(Sender: TObject);
begin
  Application.Terminate;
end;


{ IMPLEMENTA��O DO M�TODO PUBLISHED PCContinuaChange - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 05 }
procedure TFormPrincipal.PCDistroChange(Sender: TObject);
var
  i : Byte;
begin
  InicializaParReal;                     // Zera par�metros reais

  if PCDistro.ActivePageIndex < 7 then   // Ajuste nome da f(x) ou p(x)
    LFDP.Caption := 'f(x): Densidade'
  else
    LFDP.Caption := 'f(x): Massa';

  for i:=0 to ComponentCount-1 do        // Esconde todos os componentes
    if Components[i].Tag = 1 then        // TLabel e TEdit dos par�metros
      (Components[i] as TControl).Hide;

  CriaDistro;                            // Cria objeto Distribuicao
  if Distro.getNumPar >= 1 then begin    // mostra 1 par�metros
    LPar1.Caption := Distro.getNomePar1;
    LPar1.Show;
    EPar1.Show;
  end;
  if Distro.getNumPar >= 2 then begin    // mostra 2 par�metros
    LPar2.Caption := Distro.getNomePar2;
    LPar2.Show;
    EPar2.Show;
  end;
  if Distro.getNumPar >= 3 then begin    // mostra 3 par�metros
    LPar3.Caption := Distro.getNomePar3;
    LPar3.Show;
    EPar3.Show;
  end;
  FreeAndNil(Distro);

  AtualizaValores (PCDistro.ActivePageIndex+1, False);
end;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementa��o de M�todos Privados                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ DEFINI��O DO M�TODO PRIVADO InicializaParReal - - - - - - - - - - - - - - - -

 - DESCRI��O..: Inicializa vetor ParReal.
 - ENTRADA....: -
 - SA�DA......: -
 - MODIFICA...: ParReal.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 06}
procedure TFormPrincipal.InicializaParReal;
var
  i: Byte;
begin
  for i:=1 to MAX_PAR do        // Atualiza vetor de par�metros reais
    ParReal[i] := 0;
end;


{ DEFINI��O DO M�TODO PRIVADO AtualizaParametros - - - - - - - - - - - - - - -

 - DESCRI��O..: Atribui 5 par�metros do componente do tipo TEdit para o vetor
                Parametros.
 - ENTRADA....: -
 - SA�DA......: -
 - MODIFICA...: Parametros.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 07}
procedure TFormPrincipal.AtualizaParametros;
begin
  Parametros[1] := EPar1;
  Parametros[2] := EPar2;
  Parametros[3] := EPar3;
  Parametros[4] := EX;
  Parametros[5] := EFDP;
  Parametros[6] := EFPA;
end;


{ DEFINI��O DO M�TODO PRIVADO AtualizaValores - - - - - - - - - - - - - - - - -

 - DESCRI��O..: Se Salva � True, ent�o salva os par�metros de cada distribui��o
                em MatrizDados. Caso contr�rio, restaura estes par�metros para
                o vetor Parametros.
 - ENTRADA....: Ordem (da Distribui��o) e Salva.
 - SA�DA......: -
 - MODIFICA...: MatrizDados, Parametros
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 08}
procedure TFormPrincipal.AtualizaValores (Ordem: Byte; Salva: Boolean);
var
  i: Byte;
begin
  for i:=1 to 6 do
    if Salva then       // Salva valores em MatrizDados
      MatrizDados[Ordem, i] := StrToFloat (Parametros[i].Text)
    else                // Restaura valores de Parametros[i]
      Parametros[i].Text := FloatToStr (MatrizDados[Ordem, i]);
end;


{ DEFINI��O DO M�TODO PRIVADO CriaDistro - - - - - - - - - - - - - - - - - - -

 - DESCRI��O..: De acordo com a posi��o de PCDistro, cria a DP apropriada.
 - ENTRADA....: -
 - SA�DA......: -
 - MODIFICA...: Distro
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 09}
procedure TFormPrincipal.CriaDistro;
var
  Sender : TTabSheet;
begin
  Sender := PCDistro.ActivePage;

  with XUtil do begin
    if Sender.Name = 'TSUniforme' then             // Uniforme
      Distro := TUniforme.Create (ParReal[1], ParReal[2])

    else if Sender.Name = 'TSExpo' then            // Exponencial
      Distro := TExponencial.Create (ParReal[1])

    else if Sender.Name = 'TSWeibull' then         // Weibull
      Distro := TWeibull.Create (ParReal[1], ParReal[2])

    else if Sender.Name = 'TSNormal' then          // Normal
      Distro := TNormal.Create (ParReal[1], ParReal[2])

    else if Sender.Name = 'TSGama' then            // Gama
      Distro := TGama.Create (ParReal[1], ParReal[2])

    else if Sender.Name = 'TSLogLogistic' then     // LogLogistic
      Distro := TLogLogistic.Create (ParReal[1], ParReal[2])

    else if Sender.Name = 'TSTriangular' then      // Triangular
      Distro := TTriangular.Create (ParReal[1], ParReal[2], ParReal[3])

    else if Sender.Name = 'TSBinomial' then        // Binomial
      Distro := TBinomial.Create(FloatToInt(ParReal[1]), ParReal[2])

    else if Sender.Name = 'TSNBinomial' then       // Binomial Negativa
      Distro := TBinomialNegativa.Create(FloatToInt(ParReal[1]), ParReal[2])

    else if Sender.Name = 'TSGeometrica' then      // Geom�trica
      Distro := TGeometrica.Create(ParReal[1])

    else if Sender.Name = 'TSUniformeDis' then     // Uniforme Discreta
      Distro := TUniformeDiscreta.Create(FloatToInt(ParReal[1]), Trunc(ParReal[2]))

    else if Sender.Name = 'TSPoisson' then         // Poisson
      Distro := TPoisson.Create(ParReal[1]);
  end;
end;

end.
