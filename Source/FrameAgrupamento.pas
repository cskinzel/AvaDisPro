unit FrameAgrupamento;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QComCtrls, QExtCtrls, Math;

type
  TFAgrup = class(TFrame)
  published
    PAgrupamento : TPanel;
    LAgrupamento : TLabel;
    LVClasse     : TListView;
    GBAgrup      : TGroupBox;
      LVlInicial : TLabel;
      EVlInicial : TEdit;
      LVlFinal   : TLabel;
      EVlFinal   : TEdit;
      LAmplitude : TLabel;
      EAmplitude : TEdit;
      LQtd       : TLabel;
      SEIntervalo: TSpinEdit;
      BBAplicarClasse  : TBitBtn;
      BBRestaurarClasse: TBitBtn;
      GBMedidas    : TGroupBox;
      LTotElementos: TLabel;
      ETotElementos: TEdit;
      LMedia       : TLabel;
      EMedia       : TEdit;
      LDP          : TLabel;
      EDP          : TEdit;
    procedure BBAplicarRestaurarClasseClick(Sender: TObject);
  public
    procedure AtivaElementos (status, Reabertura: Boolean);
    procedure DefineAgrupamentoPadrao;
    procedure DefineAgrupamentoUsuario;
  private
    procedure InsereElementos;
    procedure GeraResumo;
    function getCasasDec: Byte;
  end;

implementation

uses
  FrmPrincipal;

const
  COD_TAG_ENABLED = 1;

{$R *.xfm}


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementa��o de M�todos P�blicos                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ IMPLEMENTA��O DO M�TODO PUBLISHED FAgrupamentoBBAplicarClasseClick - - - - -
 Chama o m�todo DefineAgrupamento (Usuario ou Padrao) e, se o form
 do gr�fico estiver ativo, o refaz.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.BBAplicarRestaurarClasseClick(Sender: TObject);
begin
  if Sender = BBAplicarClasse then
    DefineAgrupamentoUsuario
  else
    DefineAgrupamentoPadrao;

  with FormPrincipal do begin
    if XFormGrafico <> nil then
      with XFormGrafico do                        // Atualiza Gr�fico
        if Visible then
          PlotaGrafico(StrToFloat(EVlInicial.Text),
                       StrToFloat(EVlFinal.Text), Dados.QtdElemento,
                       Dados.InterIni, SEIntervalo.Value );

    if DistroAtiva <> nil then begin         // Atualiza Testes
      EstimaParametros;                      // Estima novamente os par�metros
      AtivaElementosTeste;                   // Ativa elementos de teste
    end;
    
  end;
end;


{ DEFINI��O DO M�TODO P�BLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FAgrup.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.AtivaElementos (status, Reabertura: Boolean);
var
  i: Byte;
begin
  for i:=0 to ComponentCount-1 do begin
    if not Reabertura then                   // Se n�o � reabertura de arquivo,
      if (Components[i] is TEdit) then       // ent�o limpa componentes TEdit
        (Components[i] as TEdit).Clear;
    if FormPrincipal.ArqDadosBrutos then
      if Components[i].Tag = COD_TAG_ENABLED then  // Desabilita controles
        (Components[i] as TWidgetControl).Enabled := status
    else
      if Components[i].Tag = COD_TAG_ENABLED then  // Desabilita controles
        (Components[i] as TWidgetControl).Enabled := False;
  end;

 with LVClasse do
   if status then
      Color := clBase
   else begin
     Items.Clear;
     Color := clDisabledForeground;
   end;
end;


{ DEFINI��O DO M�TODO P�BLICO DefineAgrupamentoPadrao - - - - - - - - - - - - -
 Realiza o agrupamento de dados padr�o do sistema.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.DefineAgrupamentoPadrao;
begin
  with FormPrincipal do begin
    if ArqDadosBrutos then begin                 // Dados Brutos
      SEIntervalo.Value := XOp.NINTERVALO;

      Dados.setMinElemAgrup (Dados.getMinElemento);
      Dados.setMaxElemAgrup (Dados.getMaxElemento);
      Dados.setNumIntervalo (XOp.NINTERVALO);

      EVlInicial.Text := FloatToStrF (Dados.getMinElemAgrup, ffNumber, 6, XOp.DIGITOS);
      EVlFinal.Text := FloatToStrF (Dados.getMaxElemAgrup, ffNumber, 6, XOp.DIGITOS);
      EAmplitude.Text := FloatToStrF (Dados.getAmplitude, ffNumber, 6, getCasasDec);
      end
    else begin                                   // Dados Agrupados
      EVlInicial.Text := FloatToStrF (Dados.InterIni[0], ffNumber, 6, XOp.DIGITOS);
      EVlFinal.Text := FloatToStrF (Dados.InterFin[Dados.getNumIntervalo-1], ffNumber, 6, XOp.DIGITOS);
      SEIntervalo.Value := Dados.getNumIntervalo;
    end;
    Dados.AgrupaClasses;                         // Agrupa Classes em TDados
  end;
  InsereElementos;                               // Atualiza LVAgrupamento
  GeraResumo;
end;


{ DEFINI��O DO M�TODO P�BLICO DefineAgrupamentoUsuario - - - - - - - - - - - -
 Realiza o agrupamento de dados com informa��es do usu�rio.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.DefineAgrupamentoUsuario;
var
  xVlInicial, xVlFinal: Real;
begin
  try
    XVlInicial := StrToFloat (EVlInicial.Text);
  except
    raise Exception.Create ('Valor Inicial inv�lido!');
  end;
  try
    XVlFinal := StrToFloat (EVlFinal.Text);
  except
    raise Exception.Create ('Valor Final inv�lido');
   end;

  if XVlFinal <= XVlInicial then
        raise Exception.Create ('Valor Inicial deve ser menor que Valor Final');

  with FormPrincipal do begin
    Dados.setMinElemAgrup(XVlInicial);
    Dados.setMaxElemAgrup(XVlFinal);
    Dados.setNumIntervalo(SEIntervalo.Value);
    EAmplitude.Text := FloatToStrF (Dados.getAmplitude, ffNumber, 6, getCasasDec);
    Dados.AgrupaClasses;
  end;
  InsereElementos;
  GeraResumo;
end;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementa��o de M�todos Privados                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ DEFINI��O DO M�TODO PRIVADO InsereElementos - - - - - - - - - - - - - - - - -
 Insere elementos em LVAgrupamento (intervalos inicial e final, qtd. e %)
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.InsereElementos;
var
 i        : Byte;
 Item     : TListItem;
 TotalElem: Integer;
begin
  LVClasse.Items.Clear;                   // Limpa classes do agrupamento

  with FormPrincipal do begin
    TotalElem := Dados.getTotElementos;   // Obt�m o total de elementos

    for i:=0 to Dados.getNumIntervalo-1 do
      with LVClasse do begin              // adiciona itens na lista de classes
        Item := Items.Add;                // adiciona IntervaloInicial
        Item.Caption := FloatToStrF (Dados.InterIni[i], ffNumber, 6, getCasasDec );

      // Adiciona IntervaloFinal, TotalElementos e %TotalElementos
      with Item.SubItems do begin
        Add (FloatToStrF (Dados.InterFin[i], ffNumber, 6, getCasasDec));
        Add (IntToStr (Dados.QtdElemento[i]));
        if TotalElem <> 0 then
          Add (FloatToStrF (Dados.QtdElemento[i] / TotalElem * 100,ffNumber,6,2));
      end;
    end;
  end;
end;


{ DEFINI��O DO M�TODO PRIVADO GeraResumo - - - - - - - - - - - - - - - - - - -
 Gera um resumo do agrupamento de dados (total de elementos, m�dia e DP).
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.GeraResumo;
begin
  with FormPrincipal do begin
    ETotElementos.Text := IntToStr (Dados.GetTotElementos);
    EMedia.Text := FloatToStrF (Dados.getMedia, ffNumber, 6, getCasasDec);
    EDP.Text := FloatToStrF (Dados.getDP, ffNumber, 6, getCasasDec);
  end;
end;


{ DEFINI��O DO M�TODO PRIVADO getCasasDec - - - - - - - - - - - - - - - - - - -
 Define o n�mero de casas decimais utilizadas nos atributos do sistema.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TFAgrup.getCasasDec: Byte;
begin
  with FormPrincipal do
    if MIDiscreto.Checked then            // Se dados discretos
      Result := XOp.CASA_DIS              // Pega num. casas dec. padr�o
    else
      Result := XOp.DIGITOS;              // Pega num. casas dec. def. usu�rio
end;

end.
