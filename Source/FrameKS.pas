unit FrameKS;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, KS;

type
  TFKS = class(TFrame)
  published
    PKS    : TPanel;
    LVKS   : TListView;
    LKS2   : TLabel;
    LKS    : TLabel;
    LDistro: TLabel;
  public
    procedure AtivaElementos (status: Boolean; NomeDistro: String);
    procedure InsereElementos (KS: TKS);
  end;

implementation

uses
  FrmPrincipal;

{$R *.xfm}


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FKS.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFKS.AtivaElementos (status: Boolean; NomeDistro: String);
begin
  with LVKS do
    if status then begin
      Color := clBase;
      LKS.Show;
      LKS2.Hide;
      LDistro.Caption := 'Distribuição ' + NomeDistro;
    end
    else
      begin
        Items.Clear;
        LKS.Hide;
        LKS2.Show;
        Color := clDisabledForeground;
        LDistro.Caption := '';
      end;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED InsereElementos - - - - - - - - - - - - - - - -
 Insere os elementos do teste K-S no componente ListView apropriado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFKS.InsereElementos (KS: TKS);
var
  Item : TListItem;
  i    : Integer;
begin
  LVKS.Items.Clear;

  with FormPrincipal do
    for i:=0 to Dados.getNumIntervalo-1 do begin
      Item := LVKS.Items.Add;
      with Item do begin
        Caption := IntToStr(i+1);
        SubItems.Add(FloatToStrF (KS.Matriz[0, i], ffNumber, 6, 4)); // ei
        SubItems.Add(FloatToStrF (KS.Matriz[1, i], ffNumber, 6, 4)); // Fo(x)
        SubItems.Add(FloatToStrF (KS.Matriz[2, i], ffNumber, 6, 4)); // Sn(x)
        SubItems.Add(FloatToStrF (KS.Matriz[3, i], ffNumber, 6, 4)); // D
      end;
    end;
end;

end.
