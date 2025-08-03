unit FrmDistribuicao;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, Distribuicao, Parametros;

type
  TFormDistro = class(TForm)
  published
    LPar1  : TLabel;
    EPar1  : TEdit;
    LPar2  : TLabel;
    EPar2  : TEdit;
    LPar3  : TLabel;
    EPar3  : TEdit;
    BOK    : TButton;
    BTestar: TButton;
    procedure BotaoClick(Sender: TObject);
  public
    constructor Cria (_Distro: TDistribuicao; _Parametro: TParametro; _IdDis: Byte);
  private
    Parametro: TParametro;
    Distro   : TDistribuicao;      // Ponteiro para o objeto Distro
    IdDis    : Byte;               // Identifica��o da DP
    NumPar   : Byte;               // N�mero de Par�metros
    procedure InicializaDistro;
  end;

var
  FormDistro: TFormDistro;

implementation

{$R *.xfm}


{ IMPLEMENTA��O DO CONSTRUTOR Cria - - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
constructor TFormDistro.Cria (_Distro: TDistribuicao; _Parametro: TParametro;
                             _IdDis: Byte);
begin
  inherited Create (Owner);

  Parametro := _Parametro;
  IdDis := _IdDis;
  Distro := _Distro;

  InicializaDistro;
end;


{ IMPLEMENTA��O DO M�TODO PUBLISHED BotaoClick  - - - - - - - - - - - - - - - -
 Salva os par�metros editados pelo usu�rio e, caso este clique no bot�o Testar,
 retorna Tag = 1.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TFormDistro.BotaoClick(Sender: TObject);
begin
  with Parametro do begin       // Ajusta par�metros
    try
      setParam (IdDis, 1, StrToFloat(EPar1.Text));
    except
      raise Exception.Create('Par�metro ' + LPar1.Caption + ' inv�lido');
    end;
    try
      setParam (IdDis, 2, StrToFloat(EPar2.Text));
    except
      raise Exception.Create('Par�metro ' + LPar2.Caption + ' inv�lido');
    end;
    try
      setParam (IdDis, 3, StrToFloat(EPar3.Text));
    except
      raise Exception.Create('Par�metro ' + LPar3.Caption + ' inv�lido');
    end;
  end;

  ModalResult := mrOk;

  if Sender = BTestar then
    Tag := 1;
end;


{ IMPLEMENTA��O DO M�TODO PRIVADO InicializaDistro - - - - - - - - - - - - - -
 Executa procedimentos de ajuste de DP.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- }
procedure TFormDistro.InicializaDistro;
begin
  NumPar := Distro.getNumPar;                     // Obt�m total de par�metros

  Caption := 'Distribui��o ' + Distro.getNome;    // Muda t�tulo do form

  if NumPar < 3 then begin                        // Esconde controles
    LPar3.Hide;
    EPar3.Hide;
  end;
  if NumPar < 2 then begin                        // Esconde controles
    LPar2.Hide;
    EPar2.Hide;
  end;

  LPar1.Caption := Distro.getNomePar1;            // Atualiza nomes dos
  LPar2.Caption := Distro.getNomePar2;            // par�metros
  LPar3.Caption := Distro.getNomePar3;

  with Parametro do begin
    EPar1.Text := FloatToStrF (getParam (IdDis, 1), ffNumber, 6, 8 );
    EPar2.Text := FloatToStrF (getParam (IdDis, 2), ffNumber, 6, 8 );
    EPar3.Text := FloatToStrF (getParam (IdDis, 3), ffNumber, 6, 8 );
  end;
end;

end.
