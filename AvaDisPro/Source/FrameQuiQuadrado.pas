unit FrameQuiQuadrado;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, QuiQuadrado;

type
  TFQuiQuadrado = class(TFrame)
  published
    PQuiQuadrado : TPanel;
    LVQuiQuadrado: TListView;
    LQuiQuadrado2: TLabel;
    LQuiQuadrado : TLabel;
    LDistro      : TLabel;
  public
    procedure AtivaElementos (status: Boolean; NomeDistro: String);
    procedure InsereElementos (QuiQuad: TQuiQuadrado);
  end;

implementation

uses
  FrmPrincipal;

{$R *.xfm}


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FQuiQuadrado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFQuiQuadrado.AtivaElementos (status: Boolean; NomeDistro: String);
begin
  with LVQuiQuadrado do
    if status then begin
      Color := clBase;
      LQuiQuadrado.Show;
      LQuiQuadrado2.Hide;
      LDistro.Caption := 'Distribuição ' + NomeDistro;
    end
    else
      begin
        Items.Clear;
        LQuiQuadrado.Hide;
        LQuiQuadrado2.Show;
        Color := clDisabledForeground;
        LDistro.Caption := '';
      end;
end;
                      

{ DEFINIÇÃO DO MÉTODO PUBLISHED InsereElementos - - - - - - - - - - - - - - - -
 Insere os elementos do teste qui-quadrado no componente ListView apropriado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFQuiQuadrado.InsereElementos (QuiQuad: TQuiQuadrado);
var
  Item : TListItem;
  i    : Integer;
begin
  LVQuiQuadrado.Items.Clear;

  with FormPrincipal do
    for i:=0 to Dados.getNumIntervalo-1 do begin
      Item := LVQuiQuadrado.Items.Add;
      with Item do begin
        Caption := IntToStr(i+1);
        SubItems.Add(FloatToStrF (QuiQuad.Matriz[0, i], ffNumber, 6, 2)); // ei%
        SubItems.Add(FloatToStrF (QuiQuad.Matriz[1, i], ffNumber, 6, 2)); // ei
        SubItems.Add(FloatToStrF (QuiQuad.Matriz[2, i], ffNumber, 6, 2)); // oi%
        SubItems.Add(FloatToStrF (QuiQuad.Matriz[3, i], ffNumber, 6, 0)); // oi
      end;
    end;
end;

end.
