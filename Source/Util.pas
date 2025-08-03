unit Util;

interface

{$IFDEF LINUX}
uses
  Classes, QDialogs, Typinfo, SysUtils, Math, QForms;
{$ENDIF}

{$IFDEF MSWINDOWS}
uses
  Classes, ShellApi, Windows, QDialogs, Typinfo, SysUtils, Math, QForms;
{$ENDIF}


type
  TUtil = class (TObject)
  public
    { M�todos de convers�o e estat�sticos }
    function FloatToInt (x: Real): Integer;                                 {01}
    function IntToFloat (x: Integer): Real;                                 {02}
    function SampleVariance (const X: array of Extended): Extended;         {03}

    { M�todos para internet }
    procedure AbreURL (AppHandle: THandle; URL: String);                    {04}
    procedure AbreMail (AppHandle: THandle; mail: String); overload;        {05}
    procedure AbreMail (AppHandle: THandle; mail, titulo: String); overload;{06}
    procedure AbreMail (AppHandle: THandle; mail, titulo, msg: String);     {07}
    overload;

    { M�todos de sistema }
    function FormAtivo (Frm: TForm): Boolean;                               {08}
    procedure ExecutaProgramaExterno (x : PChar);                           {09}

    function AtribuiProp(Comp: TComponent; Const PropName: string;
                         Val: string): Boolean;                             {10}
end;

implementation


{ IMPLEMENTA��O DO M�TODO P�BLICO FloatToInt - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 01 }
{ Converte um n�mero real em um inteiro - - - - - - - - - - - - - - - - - - - }
function TUtil.FloatToInt (x: Real): Integer;
begin
   Result := StrToInt (FloatToStr (x));
end;


{ IMPLEMENTA��O DO M�TODO P�BLICO FloatToInt - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 02 }
{ Converte um n�mero real em um inteiro - - - - - - - - - - - - - - - - - - - }
function TUtil.IntToFloat (x: Integer): Real;
begin
  Result := StrToFloat (IntToStr (x));
end;


{ IMPLEMENTA��O DO M�TODO P�BLICO SampleVariance - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 03 }
{ Calcula a vari�ncia de um conjunto de dados (considerando uma amostra) - - -}
function TUtil.SampleVariance (const X: array of Extended): Extended;

  function SumEArray (const B: array of Extended): Extended;
  var
	  I: Integer;
  begin
	  Result := B [Low (B)];
  	for I := Low (B) + 1 to High (B) do
	  	Result := Result + B [I];
  end;

  function ESBMean (const X: array of Extended): Extended;
  begin
	  Result := SumEArray (X) / (High (X) - Low (X) + 1)
  end;

var
	I: Integer;
	SumSq: Extended;
	Mean: Extended;
begin
	Mean := ESBMean (X);
	SumSq := 0.0;
	for I := Low (X) to High (X) do
		SumSq := SumSq + Sqr (X [I] - Mean);
	Result := SumSq / (High (X) - Low (X))
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO AbreURL - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 04 }
procedure TUtil.AbreURL ( AppHandle: THandle; URL: String );
begin
  {$IFDEF MSWINDOWS}
  ShellExecute (AppHandle, nil, pChar(URL), '', '', SW_SHOW);
  {$ENDIF}
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO AbreMail - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 05 }
{ Abre o leitor padr�o de mail com o nome do destinat�rio - - - - - - - - - - }

procedure TUtil.AbreMail (AppHandle: THandle; mail: String);
var
  strMsg : String;
begin
  strMsg := 'mailto:' + mail + '?Subject=' + '&Body=';
  {$IFDEF MSWINDOWS}
  ShellExecute (AppHandle, 'open', pChar (strMsg), '', '', SW_SHOW);
  {$ENDIF}
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO AbreMail - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 06 }
{ Abre o leitor padr�o de mail com o nome do destinat�rio e o t�tulo da msg - }

procedure TUtil.AbreMail (AppHandle: THandle; mail, titulo: String);
var
  strMsg : String;
begin
  strMsg := 'mailto:' + mail + '?Subject=' + titulo + '&Body=';
  {$IFDEF MSWINDOWS}
  ShellExecute (AppHandle, 'open', pChar (strMsg), '', '', SW_SHOW);
  {$ENDIF}
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO AbreMail - - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 07 }
{ Abre o leitor padr�o de mail com o destinat�rio, t�tulo e corpo da msg - -  }

procedure TUtil.AbreMail (AppHandle: THandle; mail, titulo, msg: String);
var
  strMsg : String;
begin
  strMsg := 'mailto:' + mail + '?Subject=' + titulo + '&Body=' + msg;
  {$IFDEF MSWINDOWS}
  ShellExecute (AppHandle, 'open', pChar (strMsg), '', '', SW_SHOW);
  {$ENDIF}
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO ExecutaProgramaExterno - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 08 }
procedure TUtil.ExecutaProgramaExterno (x : PChar);
var
  retorno : byte;
begin
  {$IFDEF MSWINDOWS}
  retorno := WinExec(x, sw_show);

  if retorno = 0 then
		raise Exception.Create ('Erro: N�o h� mem�ria livre para executar o programa')
  else if retorno = ERROR_BAD_FORMAT then
    raise Exception.Create ('Erro: Arquivo excut�vel inv�lido')
  else if retorno = ERROR_FILE_NOT_FOUND then
    raise Exception.Create ('Erro: Arquivo n�o encontrado')
  else if retorno = ERROR_PATH_NOT_FOUND then
    raise Exception.Create ('Erro: Caminho Inv�lido');
 {$ENDIF}
end;


{ DEFINI��O DO M�TODO P�BLICO FormAtivo - - - - - - - - - - - - - - - - - - - -
  Testa se um form est� ativo ou n�o.
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 09}
function TUtil.FormAtivo (Frm: TForm): Boolean;
var
  Ativo : Boolean;
begin
  try
    Ativo := Frm.Visible;
  except
    Ativo := False;
  end;
  Result := Ativo;
end;


{ IMPLEMENTA��O DO M�TODO PUBLICO AtribuiProp - - - - - - - - - - - - - - - - -
 -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 10 }
{ Atibui propriedade ao componente, dado seu valor como string - - - - - - -  }
function TUtil.AtribuiProp (Comp: TComponent; Const PropName: string;
                            Val: string): Boolean;
var
  PInfo: PPropInfo;
begin
  // Pega informa��es de tipo da propriedade
  PInfo := GetPropInfo(Comp.ClassInfo, PropName);
  // Achou?
  if PInfo <> nil then
    begin
      // Trata conforme o tipo
      Result := True;
      case PInfo^.Proptype^.Kind of
        tkInteger: SetOrdProp (Comp, PInfo, StrToInt(Val));
        tkChar, tkWChar: SetOrdProp (Comp, PInfo, ord(Val[1]));
        tkEnumeration: SetOrdProp (Comp, PInfo, GetEnumValue(PInfo^.PropType^, Val));
        tkFloat: SetFloatProp (Comp, PInfo, StrToFloat(Val));
        tkString, tkLString, tkWString: SetStrProp (Comp, PInfo, Val);
        tkVariant: SetVariantProp (Comp, PInfo, Val);
        tkInt64: SetInt64Prop (Comp, PInfo, StrToInt64(Val));
      else
        Result := False;
     end;
    end
  else
    Result := False;
end;

end.
