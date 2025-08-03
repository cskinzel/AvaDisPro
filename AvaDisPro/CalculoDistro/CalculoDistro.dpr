program CalculoDistro;

{$IFDEF LINUX}
uses
  QForms,
  Principal in 'Principal.pas' {FormPrincipal},
  Distribuicao in '../SourceDistro/Distribuicao.pas',
  Exponencial in '../SourceDistro/Exponencial.pas',
  Uniforme in '../SourceDistro/Uniforme.pas',
  LogLogistic in '../SourceDistro/LogLogistic.pas',
  Normal in '../SourceDistro/Normal.pas',
  Gama in '../SourceDistro/Gama.pas',
  Triangular in '../SourceDistro/Triangular.pas',
  Binomial in '../SourceDistro/Binomial.pas',
  BinomialNegativa in '../SourceDistro/BinomialNegativa.pas',
  Geometrica in '../SourceDistro/Geometrica.pas',
  Poisson in '../SourceDistro/Poisson.pas',
  UniformeDiscreta in '../SourceDistro/UniformeDiscreta.pas',
  Util in '../Source/Util.pas',
  Weibull in '../SourceDistro/Weibull.pas';
{$ENDIF}

{$IFDEF MSWINDOWS}
uses
  QForms,
  Principal in 'Principal.pas' {FormPrincipal},
  Distribuicao in '..\SourceDistro\Distribuicao.pas',
  Exponencial in '..\SourceDistro\Exponencial.pas',
  Uniforme in '..\SourceDistro\Uniforme.pas',
  LogLogistic in '..\SourceDistro\LogLogistic.pas',
  Normal in '..\SourceDistro\Normal.pas',
  Gama in '..\SourceDistro\Gama.pas',
  Triangular in '..\SourceDistro\Triangular.pas',
  Binomial in '..\SourceDistro\Binomial.pas',
  BinomialNegativa in '..\SourceDistro\BinomialNegativa.pas',
  Geometrica in '..\SourceDistro\Geometrica.pas',
  Poisson in '..\SourceDistro\Poisson.pas',
  UniformeDiscreta in '..\SourceDistro\UniformeDiscreta.pas',
  Util in '..\Source\Util.pas',
  Weibull in '..\SourceDistro\Weibull.pas';
{$ENDIF}
{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CP-AvaDisPro';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
