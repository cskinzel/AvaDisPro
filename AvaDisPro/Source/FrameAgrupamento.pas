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
{                      Implementação de Métodos Públicos                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ IMPLEMENTAÇÃO DO MÉTODO PUBLISHED FAgrupamentoBBAplicarClasseClick - - - - -
 Chama o método DefineAgrupamento (Usuario ou Padrao) e, se o form
 do gráfico estiver ativo, o refaz.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.BBAplicarRestaurarClasseClick(Sender: TObject);
begin
  if Sender = BBAplicarClasse then
    DefineAgrupamentoUsuario
  else
    DefineAgrupamentoPadrao;

  with FormPrincipal do begin
    if XFormGrafico <> nil then
      with XFormGrafico do                        // Atualiza Gráfico
        if Visible then
          PlotaGrafico(StrToFloat(EVlInicial.Text),
                       StrToFloat(EVlFinal.Text), Dados.QtdElemento,
                       Dados.InterIni, SEIntervalo.Value );

    if DistroAtiva <> nil then begin         // Atualiza Testes
      EstimaParametros;                      // Estima novamente os parâmetros
      AtivaElementosTeste;                   // Ativa elementos de teste
    end;
    
  end;
end;


{ DEFINIÇÃO DO MÉTODO PÚBLICO AtivaElementos - - - - - - - - - - - - - - - - -
 Ativa ou Desativa os elementos do frame FAgrup.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.AtivaElementos (status, Reabertura: Boolean);
var
  i: Byte;
begin
  for i:=0 to ComponentCount-1 do begin
    if not Reabertura then                   // Se não é reabertura de arquivo,
      if (Components[i] is TEdit) then       // então limpa componentes TEdit
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


{ DEFINIÇÃO DO MÉTODO PÚBLICO DefineAgrupamentoPadrao - - - - - - - - - - - - -
 Realiza o agrupamento de dados padrão do sistema.
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


{ DEFINIÇÃO DO MÉTODO PÚBLICO DefineAgrupamentoUsuario - - - - - - - - - - - -
 Realiza o agrupamento de dados com informações do usuário.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.DefineAgrupamentoUsuario;
var
  xVlInicial, xVlFinal: Real;
begin
  try
    XVlInicial := StrToFloat (EVlInicial.Text);
  except
    raise Exception.Create ('Valor Inicial inválido!');
  end;
  try
    XVlFinal := StrToFloat (EVlFinal.Text);
  except
    raise Exception.Create ('Valor Final inválido');
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
{                      Implementação de Métodos Privados                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ DEFINIÇÃO DO MÉTODO PRIVADO InsereElementos - - - - - - - - - - - - - - - - -
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
    TotalElem := Dados.getTotElementos;   // Obtém o total de elementos

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


{ DEFINIÇÃO DO MÉTODO PRIVADO GeraResumo - - - - - - - - - - - - - - - - - - -
 Gera um resumo do agrupamento de dados (total de elementos, média e DP).
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
procedure TFAgrup.GeraResumo;
begin
  with FormPrincipal do begin
    ETotElementos.Text := IntToStr (Dados.GetTotElementos);
    EMedia.Text := FloatToStrF (Dados.getMedia, ffNumber, 6, getCasasDec);
    EDP.Text := FloatToStrF (Dados.getDP, ffNumber, 6, getCasasDec);
  end;
end;


{ DEFINIÇÃO DO MÉTODO PRIVADO getCasasDec - - - - - - - - - - - - - - - - - - -
 Define o número de casas decimais utilizadas nos atributos do sistema.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function TFAgrup.getCasasDec: Byte;
begin
  with FormPrincipal do
    if MIDiscreto.Checked then            // Se dados discretos
      Result := XOp.CASA_DIS              // Pega num. casas dec. padrão
    else
      Result := XOp.DIGITOS;              // Pega num. casas dec. def. usuário
end;

end.
