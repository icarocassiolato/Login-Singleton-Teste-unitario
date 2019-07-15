unit UsuarioDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.FMXUI.Wait, FireDAC.Comp.UI;

type
  TDMUsuarioDados = class(TDataModule)
    FdcConexao: TFDConnection;
    FdqUsuario: TFDQuery;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure FdcConexaoBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Selecionar(psEmail: string; psSenha: string = ''): TFDQuery;
    procedure Inserir(psEmail, psNome, psSenha: String);
    procedure AlterarSenha(piID: integer; psSenhaNova: string);
  end;

var
  DMUsuarioDados: TDMUsuarioDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMUsuarioDados.DataModuleCreate(Sender: TObject);
begin
  FdcConexao.Open;
end;

procedure TDMUsuarioDados.FdcConexaoBeforeConnect(Sender: TObject);
begin
  FdcConexao.Params.LoadFromFile('Config.ini');
end;

procedure TDMUsuarioDados.AlterarSenha(piID: integer; psSenhaNova: string);
begin
  FdqUsuario.ExecSQL(Format('UPDATE USUARIO SET SENHA = %s WHERE IDUSUARIO = %d',
    [QuotedStr(psSenhaNova), piID]));
end;

function TDMUsuarioDados.Selecionar(psEmail: string; psSenha: string = ''): TFDQuery;
var
  sSQL: string;
begin
  if FdqUsuario.Active then
    FdqUsuario.Close;

  sSQL := Format('SELECT * FROM USUARIO WHERE EMAIL = %s', [QuotedStr(psEmail)]);

  if psSenha.Length > 0 then
    sSQL := sSQL + Format(' AND SENHA = %s', [QuotedStr(psSenha)]);

  FdqUsuario.Open(sSQL);
  Result := FdqUsuario;
end;

procedure TDMUsuarioDados.Inserir(psEmail, psNome, psSenha: String);
begin
  FdqUsuario.Insert;
  FdqUsuario.FieldByName('IDUSUARIO').AsInteger := 0;
  FdqUsuario.FieldByName('NOME').AsString := psNome;
  FdqUsuario.FieldByName('SENHA').AsString := psSenha;
  FdqUsuario.FieldByName('EMAIL').AsString := psEmail;
  FdqUsuario.Post;
end;

end.
