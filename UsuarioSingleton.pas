unit UsuarioSingleton;

interface

uses
  FireDAC.Comp.Client, SysUtils;

type
  ExcecaoEsperada = class(Exception);
  TUsuarioSingleton = class
    private
      class var FID: Integer;
      class var FNome: String;
      class var FSenha: String;
      class var FEmail: String;
      class var FQuery: TFDQuery;

      class var FInstance: TUsuarioSingleton;
      constructor CreatePrivate;
      class function Criptografar(const Value: string): string;
      class function PodeTrocarSenha(psSenhaAntiga, psSenhaNova,
        psSenhaComparacao: String): Boolean;
      class function PodeCriarUsuario(psSenha,
        psSenhaComparacao: String): Boolean; static;
      class function SenhasConferem(psSenha, psSenhaComparacao: String): Boolean; static;
    public
      class function FazerLogin(psEmail, psSenha: String): Boolean;
      class function CriarUsuario(psEmail, psNome, psSenha, psSenhaComparacao: String): Boolean;
      class function AlterarSenha(psSenhaAntiga, psSenhaNova, psSenhaComparacao: String): Boolean;
      class procedure SetQuery(poQuery: TFDQuery);

      class function GetInstance: TUsuarioSingleton;

      class property ID: Integer read FID;
      class property Nome: String read FNome;
      class property Senha: String read FSenha;
      class property Email: String read FEmail;
  end;

implementation

uses
  FMX.Dialogs, IdHashMessageDigest, DB, Firedac.Dapt, UsuarioDados;

constructor TUsuarioSingleton.CreatePrivate;
begin
  inherited Create;
end;

class function TUsuarioSingleton.GetInstance: TUsuarioSingleton;
begin
  if not Assigned(FInstance) then
    FInstance := TUsuarioSingleton.CreatePrivate;
  Result := FInstance;
end;

class procedure TUsuarioSingleton.SetQuery(poQuery: TFDQuery);
begin
  FQuery := poQuery;
end;

{$REGION 'Funções auxiliares'}
class function TUsuarioSingleton.Criptografar(const Value: string): string;
begin
  with TIdHashMessageDigest5.Create do
  begin
    Result := HashStringAsHex(Value);
    Free;
  end;
end;
{$ENDREGION}

{$REGION 'Validações'}
class function TUsuarioSingleton.SenhasConferem(psSenha, psSenhaComparacao: String): Boolean;
begin
  Result := psSenha = psSenhaComparacao;
  if not Result then
    ShowMessage('As senhas não conferem!');
end;

class function TUsuarioSingleton.PodeCriarUsuario(psSenha, psSenhaComparacao: String): Boolean;
begin
  if not FQuery.IsEmpty then
    raise ExcecaoEsperada.Create('Usuario já cadastrado!');

  Result := SenhasConferem(psSenha, psSenhaComparacao);
end;

class function TUsuarioSingleton.PodeTrocarSenha(psSenhaAntiga, psSenhaNova, psSenhaComparacao: String): Boolean;
begin
  if FID = 0 then
    raise ExcecaoEsperada.Create('Faça login antes de alterar a senha');

  if FSenha <> Criptografar(psSenhaAntiga) then
    raise ExcecaoEsperada.Create('A senha antiga não confere!');

  Result := SenhasConferem(psSenhaNova, psSenhaComparacao);
end;
{$ENDREGION}

{$REGION 'Ações'}
class function TUsuarioSingleton.CriarUsuario(psEmail, psNome, psSenha, psSenhaComparacao: String): Boolean;
begin
  FQuery := DMUsuarioDados.Selecionar(psEmail);

  if not PodeCriarUsuario(psSenha, psSenhaComparacao) then
    Exit(False);

  DMUsuarioDados.Inserir(psEmail, psNome, Criptografar(psSenha));

  ShowMessage('Usuario cadastrado com sucesso!');
  Result := True;
end;

class function TUsuarioSingleton.AlterarSenha(psSenhaAntiga, psSenhaNova, psSenhaComparacao: String): Boolean;
begin
  if not PodeTrocarSenha(psSenhaAntiga, psSenhaNova, psSenhaComparacao) then
    Exit(False);

  DMUsuarioDados.AlterarSenha(FID, Criptografar(psSenhaNova));
  FSenha := Criptografar(psSenhaNova);
  ShowMessage('Senha alterada com sucesso!');
  Result := True;
end;

class function TUsuarioSingleton.FazerLogin(psEmail, psSenha: String): Boolean;
begin
  FQuery := DMUsuarioDados.Selecionar(psEmail, Criptografar(psSenha));

  if FQuery.IsEmpty then
    raise ExcecaoEsperada.Create('Usuario e/ou senha inválido(s)');

  FID := FQuery.FieldByName('IDUSUARIO').AsInteger;
  FNome := FQuery.FieldByName('NOME').AsString;
  FEmail := FQuery.FieldByName('EMAIL').AsString;
  FSenha := FQuery.FieldByName('SENHA').AsString;

  Result := True;
end;
{$ENDREGION}

end.
