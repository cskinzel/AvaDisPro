unit FrmDetalhes;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TFormDetalhes = class(TForm)
  published
    MDetalhes: TMemo;
  end;

var
  FormDetalhes: TFormDetalhes;

implementation

{$R *.xfm}

end.
