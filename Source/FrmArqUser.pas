unit FrmArqUser;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TFormArqUser = class(TForm)
  published
    MArqUser: TMemo;
    constructor Cria (NomeArquivo: String);
  end;

var
  FormArqUser: TFormArqUser;

implementation

{$R *.xfm}

{ DEFINI��O DO CONSTRUTOR Cria - - - - - - - - - - - - - - - - - - - - - - - -
 Cria o objeto FormArqUser e adiciona em MArqUser o conte�do do arquivo
 NomeArquivo.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01}
constructor TFormArqUser.Cria (NomeArquivo: String);
var
  arq: TextFile;
begin
  inherited Create(Owner);

  AssignFile(arq, NomeArquivo);  // Verifica se arquivo pode ser aberto
  try
    Reset(arq);
  except
		raise Exception.Create ('Arquivo n�o p�de ser aberto!');
  end;
  CloseFile (arq);

  try
    MArqUser.Lines.LoadFromFile(NomeArquivo);
  except
 		raise Exception.Create ('Erro ao visualizar arquivo');
  end;

  Caption := NomeArquivo;
end;

end.
