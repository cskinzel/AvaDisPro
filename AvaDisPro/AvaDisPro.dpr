program AvaDisPro;

{$IFDEF MSWINDOWS}
uses
  QForms,
  FrmPrincipal in 'Source\FrmPrincipal.pas' {FormPrincipal},
  FrmJanelaEspera in 'Source\FrmJanelaEspera.pas' {FormJanelaEspera},
  FrameConjuntoDados in 'Source\FrameConjuntoDados.pas' {FConjuntoDados: TFrame},
  FrameResumo in 'Source\FrameResumo.pas' {FResumo: TFrame},
  FrameAgrupamento in 'Source\FrameAgrupamento.pas' {FAgrup: TFrame},
  FrmArqUser in 'Source\FrmArqUser.pas' {FormArqUser},
  FrmGrafico in 'Source\FrmGrafico.pas' {FormGrafico},
  Opcoes in 'Source\Opcoes.pas',
  FrameQuiQuadrado in 'Source\FrameQuiQuadrado.pas' {FQuiQuadrado: TFrame},
  QuiQuadrado in 'SourceDistro\QuiQuadrado.pas',
  FrameKS in 'Source\FrameKS.pas' {FKS: TFrame},
  KS in 'SourceDistro\KS.pas',
  Distribuicao in 'SourceDistro\Distribuicao.pas',
  Exponencial in 'SourceDistro\Exponencial.pas',
  FrmDistribuicao in 'Source\FrmDistribuicao.pas' {FormDistro},
  Dados in 'Source\Dados.pas',
  Brutos in 'Source\Brutos.pas',
  Agrupamento in 'Source\Agrupamento.pas',
  Util in 'Source\Util.pas',
  Parametros in 'SourceDistro\Parametros.pas',
  Normal in 'SourceDistro\Normal.pas',
  Gama in 'SourceDistro\Gama.pas',
  FrameResultado in 'Source\FrameResultado.pas' {FResultado: TFrame},
  Uniforme in 'SourceDistro\Uniforme.pas',
  Weibull in 'SourceDistro\Weibull.pas',
  Poisson in 'SourceDistro\Poisson.pas',
  Triangular in 'SourceDistro\Triangular.pas',
  FrmLicenca in 'Source\FrmLicenca.pas' {FormLicenca},
  LogLogistic in 'SourceDistro\LogLogistic.pas',
  Binomial in 'SourceDistro\Binomial.pas',
  Geometrica in 'SourceDistro\Geometrica.pas',
  UniformeDiscreta in 'SourceDistro\UniformeDiscreta.pas',
  BinomialNegativa in 'SourceDistro\BinomialNegativa.pas',
  FrmDetalhes in 'Source\FrmDetalhes.pas' {FormDetalhes},
  FrmSobre in 'Source\FrmSobre.pas' {FormSobre};

{$ENDIF}

{$IFDEF Linux}
uses
  QForms,
  FrmPrincipal in 'Source/FrmPrincipal.pas' {FormPrincipal},
  FrmJanelaEspera in 'Source/FrmJanelaEspera.pas' {FormJanelaEspera},
  FrameConjuntoDados in 'Source/FrameConjuntoDados.pas' {FConjuntoDados: TFrame},
  FrameResumo in 'Source/FrameResumo.pas' {FResumo: TFrame},
  FrameAgrupamento in 'Source/FrameAgrupamento.pas' {FAgrup: TFrame},
  FrmArqUser in 'Source/FrmArqUser.pas' {FormArqUser},
  FrmGrafico in 'Source/FrmGrafico.pas' {FormGrafico},
  Opcoes in 'Source/Opcoes.pas',
  QuiQuadrado in 'SourceDistro/QuiQuadrado.pas',
  FrameQuiQuadrado in 'Source/FrameQuiQuadrado.pas' {FQuiQuadrado: TFrame},
  KS in 'SourceDistro/KS.pas',
  FrameKS in 'Source/FrameKS.pas' {FKS: TFrame},
  Distribuicao in 'SourceDistro/Distribuicao.pas',
  Exponencial in 'SourceDistro/Exponencial.pas',
  FrmDistribuicao in 'Source/FrmDistribuicao.pas' {FormDistro},
  Dados in 'Source/Dados.pas',
  Brutos in 'Source/Brutos.pas',
  Agrupamento in 'Source/Agrupamento.pas',
  Util in 'Source/Util.pas',
  Parametros in 'SourceDistro/Parametros.pas',
  Normal in 'SourceDistro/Normal.pas',
  Gama in 'SourceDistro/Gama.pas',
  FrameResultado in 'Source/FrameResultado.pas' {FResultado: TFrame},
  Uniforme in 'SourceDistro/Uniforme.pas',
  Weibull in 'SourceDistro/Weibull.pas',
  Poisson in 'SourceDistro/Poisson.pas',
  Triangular in 'SourceDistro/Triangular.pas',
  FrmSobre in 'Source/FrmSobre.pas' {FormSobre},
  LogLogistic in 'SourceDistro/LogLogistic.pas',
  Binomial in 'SourceDistro/Binomial.pas',
  Geometrica in 'SourceDistro/Geometrica.pas',
  UniformeDiscreta in 'SourceDistro/UniformeDiscreta.pas',
  BinomialNegativa in 'SourceDistro/BinomialNegativa.pas',
  FrmDetalhes in 'Source/FrmDetalhes.pas' {FormDetalhes},
  FrmLicenca in 'Source/FrmLicenca.pas' {FormLicenca};
{$ENDIF}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AvaDisPro';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormSobre, FormSobre);
  Application.Run;
end.
