unit FrameConjuntoDados;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QComCtrls, QStdCtrls, QExtCtrls;

type
  TFConjuntoDados = class(TFrame)
  published
    PConjunto: TPanel;
    LConjunto: TLabel;
    LVDados  : TListView;
    procedure LVDadosColumnClick(Sender: TObject; Column: TListColumn);
  public
    procedure AtivaElementos (status: Boolean);
    procedure InsereElementos;
  end;

implementation

uses
  FrmPrincipal;

{$R *.xfm}


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FConjuntoDados.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFConjuntoDados.AtivaElementos (status: Boolean);
begin
  with LVDados do
    if status then
      Color := clBase
    else
      begin
        with FormPrincipal do
        begin
          StatusBar.Panels[0].Text := 'Fechando arquivo. Por favor, aguarde...';
          Refresh;
        end;
        Items.Clear;
        Color := clDisabledForeground;
        FormPrincipal.StatusBar.Panels[0].Text := '';
      end;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED InsereElementos - - - - - - - - - - - - - - - -
 Insere os elementos de um conjunto de dados no componente ListView apropriado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFConjuntoDados.InsereElementos;
var
  Item : TListItem;
  i    : Integer;
begin
  LVDados.Items.Clear;
  with FormPrincipal do
    for i:=0 to Length(Dados.DadosUser)-1 do
      begin
        Item := LVDados.Items.Add;
        Item.Caption := IntToStr(i+1);
        Item.SubItems.Add(FloatToStrF (Dados.DadosUser[i], ffNumber, 6, XOp.DIGITOS));
      end;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED LVDadosColumnClick - - - - - - - - - - - - - - -
 Ativa ordenação de elementos do Conjunto de Dados.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFConjuntoDados.LVDadosColumnClick(Sender: TObject; Column: TListColumn);
begin
  LVDados.ShowColumnSortIndicators := True;
end;

end.
