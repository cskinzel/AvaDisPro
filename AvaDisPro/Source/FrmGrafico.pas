unit FrmGrafico;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, Math, PlotPanel;

type
  TFormGrafico = class(TForm)
  published
    PlotPanel: TPlotPanel;
  public
    procedure PlotaGrafico (xVlMin, xVlMax: Extended; xQtdElemento:
                            array of Integer; xDIntervalo: array of Extended;
                            xQtdInter: Byte);
  end;

var
  FormGrafico: TFormGrafico;

implementation

{$R *.xfm}

{ DEFINI��O DO M�TODO P�BLICOS PlotaGrafico - - - - - - - - - - - - - - - - - -

 - DESCRI��O..: Gera um gr�fico com os dados do usu�rio.
 - ENTRADA....: xVlMin, xVlMax (M�nimo e M�ximo elementos), xQtdElemento
                (Qtd. de elementos por intervalo), xDIntervalo (valor dos inter-
                 valos iniciais), xQtdInter (quantidade de classes).
 - SA�DA......: -
 - MODIFICA...: PlotPanel.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02}
procedure TFormGrafico.PlotaGrafico (xVlMin, xVlMax: Extended; xQtdElemento:
                                     array of Integer; xDIntervalo: array of
                                     Extended; xQtdInter: Byte);
const
  PERC_AJUSTE = 0.10;
var
  i : Byte;
  Maior, Menor: Real;
begin
  Maior := xQtdElemento[0];            // Descobre maior valor da coordenada y
  Menor := Maior;

  for i:=Low(xQtdElemento)+1 to High(xQtdElemento) do
    if xQtdElemento[i] > Maior then
      Maior := xQtdElemento[i]
    else if xQtdElemento[i] < Menor then
      Menor := xQtdElemento[i];

  with PlotPanel do
    begin
      Clear;
      XMax := xVlMax + PERC_AJUSTE * xVlMax;     // Valor m�ximo de x
      YMax := Maior + PERC_AJUSTE * Maior;       // Valor m�ximo de y
      XMin := xVlMin - PERC_AJUSTE * xVlMin;     // Valor m�nimo de x
      if Menor > 0 then
        YMin := Menor - PERC_AJUSTE * Menor      // Valor m�nimo de y
      else
        YMin := Menor;
      XMarksInterval := RoundTo(xDIntervalo[xQtdInter-1]/5, -1);
      YMarksInterval := RoundTo(Maior/5, -1);    // Amplitude da coordenada y

      for i:=0 to xQtdInter-1 do                 // Adiciona valores ao gr�fico
        AddXY (xDIntervalo[i], xQtdElemento[i]);
    end;
end;

end.
