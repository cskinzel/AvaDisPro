unit Opcoes;

interface

uses
  IniFiles, SysUtils, QDialogs, QForms;

type
  TOpcoes = class(TObject)
  public
    COMENT    : Char;    { Caractere de comentário para arquivo de dados }
    DIGITOS   : Byte;    { Valor inicial para casas decimais }
    NINTERVALO: Byte;    { Número de intervalos criados para cada classe }
    TIPODADO  : Byte;    { 1, se Contínuo; 0, se Discreto }
    CASA_DIS  : Byte;    { Número de casas utilizadas se TIPODADO = 0 }
    SALVAR_Q2 : Byte;    { 1, se Sim; 0, se Não }
    SALVAR_KS : Byte;    { 1, se Sim; 0, se Não }
    constructor Cria;                                                      {01}
    procedure LeOpcoes;                                                    {02}
    procedure GravaOpcoes (Ops: array of Integer);                         {03}
  private
    ArqUser   : TIniFile;
end;

implementation

const
  NOMEARQOPCOES = 'AvaDisPro.ini';


{ IMPLEMENTAÇÃO DO CONSTRUCTOR CRIA - - - - - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
constructor TOpcoes.Cria;
begin
  ArqUser := TIniFile.Create (ExtractFilePath(Application.ExeName) + '/' + NOMEARQOPCOES);

  COMENT := '|';
end;


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO LeOpcoes - - - - - - - - - - - - - - - - - -
 Lê opções do arquivo de configuração do usuário.
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


{ IMPLEMENTAÇÃO DO MÉTODO PÚBLICO GravaOpcoes - - - - - - - - - - - - - - - - -
 Grava as opções de configuração do usuário.
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
