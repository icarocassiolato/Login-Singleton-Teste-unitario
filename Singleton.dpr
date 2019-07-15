program Singleton;

uses
  System.StartUpCopy,
  FMX.Forms,
  Login in 'Login.pas' {FrmLogin},
  UsuarioSingleton in 'UsuarioSingleton.pas',
  UsuarioDados in 'UsuarioDados.pas' {DMUsuarioDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMUsuarioDados, DMUsuarioDados);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
