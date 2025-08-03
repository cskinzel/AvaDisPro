unit FrmJanelaEspera;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QComCtrls;

type
  TFormJanelaEspera = class(TForm)
  public
    constructor Criar (Titulo: String);                                    {01}
    procedure IniciaBarra (_Min, _Max, _Posicao: Integer );                {02}
    procedure AtualizaBarra (Qtd: Integer);                                {03}
  published
    BBCancelar : TBitBtn;
    ProgressBar: TProgressBar;
  end;

var
  FormJanelaEspera: TFormJanelaEspera;

implementation

{$R *.xfm}

const
  MIN_SHOW_PERCENTUAL = 500;


{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }
{                      Implementação de Métodos PÚBLICOS                      }
{ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= }

{ IMPLEMENTAÇÃO DO CONSTRUCTOR Criar - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
constructor TFormJanelaEspera.Criar (Titulo: String);
begin
  inherited Create(Owner);
  Caption := Titulo;
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO IniciaBarra - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02 }
procedure TFormJanelaEspera.IniciaBarra (_Min, _Max, _Posicao: Integer);
begin
  with ProgressBar do begin
    Min := _Min;
    Max := _Max;
    Position := _Posicao;
    if _Max > MIN_SHOW_PERCENTUAL then
      Caption := ' 0%'
    else
      ShowCaption := False
   end
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO AtualizaBarra - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 03 }
procedure TFormJanelaEspera.AtualizaBarra (Qtd: Integer);
var
  Perc   : Single;
  PercStr: String;
begin
  with ProgressBar do begin
    Position := Position + Qtd;    // Atualiza Indicador de Progresso
    Perc := Position / Max * 100;  // Atualiza Percentual Concluído
    PercStr := FloatToStr (Perc);

    if Perc < 10 then
      Caption := ' ' + PercStr[1] + '%'
    else
      Caption := PercStr[1] + PercStr[2] + '%';
  end;

  Update;                          // Atualiza controles pendentes
end;

end.
