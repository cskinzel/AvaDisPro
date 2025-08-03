unit FrmLicenca;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QExtCtrls;

type
  TFormLicenca = class(TForm)
  published
    Panel1: TPanel;
    Label1: TLabel;
    OKButton: TBitBtn;
    MLicenca: TMemo;
  end;

var
  FormLicenca: TFormLicenca;

implementation

{$R *.xfm}

end.
