unit FrameResumo;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls;

type
  TFResumo = class(TFrame)
  published
    LVResumo: TListView;
    PResumo : TPanel;
    LResumo : TLabel;
    procedure AtivaElementos (status: Boolean);
    procedure GeraResumo;
  end;

implementation

{$R *.xfm}

uses
  FrmPrincipal,
  Util;

var
  XUtil: TUtil;


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FElementos.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResumo.AtivaElementos (status: Boolean);
begin
  with LVResumo do
    if status then
      Color := clBase
    else
      begin
        Items.Clear;
        Color := clDisabledForeground;
      end;
end;


{ DEFINIÇÃO DO MÉTODO PUBLISHED GeraResumo - - - - - - - - - - - - - - - - - -
 Gera um resumo com informações estatísticas (Total de Elementos, Mínimo e
 Máximo, Soma Total, Média e Desvio-Padrão) e coloca estas informações no
 componente TListView apropriado.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFResumo.GeraResumo;
const
  MAX_MEDIDAS = 7;
  NOMES_MEDIDAS : array [1..MAX_MEDIDAS] of String =
                  ('Elementos', 'Mínimo', 'Máximo', '', 'Soma Total',
                   'Média Aritmética', 'Desvio-Padrão');
var
  Item : TListItem;
  List : array[1..MAX_MEDIDAS] of String;
  i, CasasDec : Byte;
begin
  LVResumo.Items.Clear;

  with FormPrincipal do
    if MIDiscreto.Checked then
      CasasDec := XOp.CASA_DIS
    else
      CasasDec := XOp.DIGITOS;

  with FormPrincipal do
    try
      List[1] := IntToStr (Dados.getTotElementos);
      List[2] := FloatToStrF(Dados.getMinElemento, ffNumber, 6, XOp.DIGITOS);
      List[3] := FloatToStrF(Dados.getMaxElemento, ffNumber, 6, XOp.DIGITOS);
      List[4] := '';
      List[5] := FloatToStrF(Dados.getSomaDados, ffNumber, 6, XOp.DIGITOS);
      List[6] := FloatToStrF(Dados.getSomaDados / Dados.getTotElementos, ffNumber, 6, CasasDec);
      List[7] := FloatToStrF(Sqrt(XUtil.SampleVariance (Dados.DadosUser)), ffNumber, 6, CasasDec);
    except
 	  	raise Exception.Create ('Ocorreu um erro fatal na geração de informações de resumo.');
    end;

  { Adiciona medidas estatísticas em LVResumo }
  for i:=1 to MAX_MEDIDAS do
    begin
      Item := LVResumo.Items.Add;
      Item.Caption := NOMES_MEDIDAS[i];
      Item.SubItems.Add (List[i]);
    end;
end;

end.
