unit Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TTipoAcao = (taCadastrar, taLogin, taAlterarSenha);

  TFrmLogin = class(TForm)
    EdtNome: TEdit;
    EdtEmail: TEdit;
    EdtSenhaComparacao: TEdit;
    RbtCadastrar: TRadioButton;
    RbtLogin: TRadioButton;
    RbtAlterarSenha: TRadioButton;
    BtnAcao: TButton;
    EdtSenha: TEdit;
    EdtNovaSenha: TEdit;
    RtgFundo: TRectangle;
    procedure RadioButtonChange(Sender: TObject);
    procedure BtnAcaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAcaoSelecionada: TTipoAcao;
    procedure Configurar(psTextoBotao: string; pbNome, pbEmail, pbSenha, pbSenhaConfirmacao,
      pbNovaSenha: boolean);
    procedure SelecionarAcao(poSender: TObject);
    procedure LimparEdits;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
  UsuarioSingleton, UsuarioDados;

{$R *.fmx}

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  TUsuarioSingleton.GetInstance.SetQuery(DMUsuarioDados.FdqUsuario);
  RadioButtonChange(RbtCadastrar);
end;

procedure TFrmLogin.SelecionarAcao(poSender: TObject);
begin
  FAcaoSelecionada := TTipoAcao(TRadioButton(poSender).Tag);
end;

procedure TFrmLogin.Configurar(psTextoBotao: string; pbNome, pbEmail, pbSenha, pbSenhaConfirmacao, pbNovaSenha: boolean);
begin
  BtnAcao.Text := psTextoBotao;

  EdtNome.Visible := pbNome;
  EdtEmail.Visible := pbEmail;
  EdtSenha.Visible := pbSenha;
  EdtSenhaComparacao.Visible := pbSenhaConfirmacao;
  EdtNovaSenha.Visible := pbNovaSenha;
end;

procedure TFrmLogin.RadioButtonChange(Sender: TObject);
begin
  LimparEdits;
  SelecionarAcao(Sender);
  case FAcaoSelecionada of
    taCadastrar: Configurar(TRadioButton(Sender).Text, True, True, True, True, False);
    taLogin: Configurar(TRadioButton(Sender).Text, False, True, True, False, False);
    taAlterarSenha: Configurar(TRadioButton(Sender).Text, False, False, True, True, True);
  end;
end;

procedure TFrmLogin.LimparEdits;
begin
  EdtNome.Text := EmptyStr;
  EdtEmail.Text := EmptyStr;
  EdtSenhaComparacao.Text := EmptyStr;
  EdtSenha.Text := EmptyStr;
  EdtNovaSenha.Text := EmptyStr;
end;

procedure TFrmLogin.BtnAcaoClick(Sender: TObject);
var
  bSucesso: boolean;
begin
  bSucesso := False;
  case FAcaoSelecionada of
    taCadastrar: bSucesso := TUsuarioSingleton.GetInstance.CriarUsuario(EdtEmail.Text, EdtNome.Text, EdtSenha.Text, EdtSenhaComparacao.Text);
    taLogin: bSucesso := TUsuarioSingleton.GetInstance.FazerLogin(EdtEmail.Text, EdtSenha.Text);
    taAlterarSenha: bSucesso := TUsuarioSingleton.GetInstance.AlterarSenha(EdtSenha.Text, EdtNovaSenha.Text, EdtSenhaComparacao.Text);
  end;

  if bSucesso then
    LimparEdits;
end;

end.
