unit Opcoes;

interface

uses
  IniFiles, SysUtils, QDialogs, QForms;

type
  TOpcoes = class(TObject)
  public
    COMENT    : Char;    { Caractere de coment�rio para arquivo de dados }
    DIGITOS   : Byte;    { Valor inicial para casas decimais }
    NINTERVALO: Byte;    { N�mero de intervalos criados para cada classe }
    TIPODADO  : Byte;    { 1, se Cont�nuo; 0, se Discreto }
    CASA_DIS  : Byte;    { N�mero de casas utilizadas se TIPODADO = 0 }
    SALVAR_Q2 : Byte;    { 1, se Sim; 0, se N�o }
    SALVAR_KS : Byte;    { 1, se Sim; 0, se N�o }
    constructor Cria;                                                      {01}
    procedure LeOpcoes;                                                    {02}
    procedure GravaOpcoes (Ops: array of Integer);                         {03}
  private
    ArqUser   : TIniFile;
end;

implementation

const
  NOMEARQOPCOES = 'AvaDisPro.ini';


{ IMPLEMENTA��O DO CONSTRUCTOR CRIA - - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
constructor TOpcoes.Cria;
begin
  ArqUser := TIniFile.Create (ExtractFilePath(Application.ExeName) + '/' + NOMEARQOPCOES);

  COMENT := '|';
end;


{ IMPLEMENTA��O DO M�TODO P�BLICO LeOpcoes - - - - - - - - - - - - - - - - - -
 L� op��es do arquivo de configura��o do usu�rio.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02 }
procedure TOpcoes.LeOpcoes;
begin
  with ArqUser do
  begin
    DIGITOS := ReadInteger ('Geral', 'Casas Decimais', 2);
    NINTERVALO := ReadInteger ('Geral', 'Qtd. Intervalos', 5);
    TIPODADO := ReadInteger ('Geral', 'Tipo de Dado', 1);
    CASA_DIS := ReadInteger ('Geral', 'Casas Decimais [Discreto]', 2);
    SALVAR_Q2 := ReadInteger ('Geral', 'Executar automaticamente qui-quadrado', 1);
    SALVAR_KS := ReadInteger ('Geral', 'Executar automaticamente K-S', 1);
  end;
end;


{ IMPLEMENTA��O DO M�TODO P�BLICO GravaOpcoes - - - - - - - - - - - - - - - - -
 Grava as op��es de configura��o do usu�rio.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 03 }
procedure TOpcoes.GravaOpcoes (Ops: array of Integer);
begin
  with ArqUser do
  begin
    WriteInteger ('Geral', 'Casas Decimais', DIGITOS);
    WriteInteger ('Geral', 'Qtd. Intervalos', Ops[0]);
    WriteInteger ('Geral', 'Tipo de Dado', Ops[1]);
    WriteInteger ('Geral',  'Executar automaticamente qui-quadrado', Ops[2]);
    WriteInteger ('Geral', 'Executar automaticamente K-S', Ops[3]);
  end;
end;

end.
