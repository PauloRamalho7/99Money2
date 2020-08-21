program Money;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  u99Permissions in 'Units\u99Permissions.pas',
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitLancamentos in 'UnitLancamentos.pas' {FrmLancamentos},
<<<<<<< HEAD
  UnitLancamentosCad in 'UnitLancamentosCad.pas' {FrmLancamentosCad},
  UnitCategorias in 'UnitCategorias.pas' {FrmCategorias},
  UnitCategoriasCad in 'UnitCategoriasCad.pas' {FrmCategoriasCad},
  UnitDM in 'UnitDM.pas' {dm: TDataModule};
=======
  UnitLancamentosCad in 'UnitLancamentosCad.pas' {FrmLancamentosCad};
>>>>>>> parent of 9a441fb... Aula 11

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
