unit UnitLancamentosCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.DateTimeCtrls;

type
  TFrmLancamentosCad = class(TForm)
    lyt_toolbar: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    img_salvar: TImage;
    Layout1: TLayout;
    Label2: TLabel;
    edt_login_email: TEdit;
    Line1: TLine;
    Layout2: TLayout;
    Label3: TLabel;
    Line2: TLine;
    Layout3: TLayout;
    Label4: TLabel;
    Edit2: TEdit;
    Line3: TLine;
    Layout4: TLayout;
    Label5: TLabel;
    Edit3: TEdit;
    Line4: TLine;
    rect_botton: TRectangle;
    img_add: TImage;
    DateEdit1: TDateEdit;
    Image1: TImage;
    Image2: TImage;
    procedure img_voltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentosCad: TFrmLancamentosCad;

implementation

uses
  UnitPrincipal;

{$R *.fmx}

procedure TFrmLancamentosCad.img_voltarClick(Sender: TObject);
begin
    Close;
end;

end.
