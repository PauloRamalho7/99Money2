unit UnitLancamentosCad;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.DateTimeCtrls,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TFrmLancamentosCad = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_login_email: TEdit;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    Edit1: TEdit;
    Line2: TLine;
    Layout4: TLayout;
    Label4: TLabel;
    Edit2: TEdit;
    Line3: TLine;
    Layout5: TLayout;
    Label5: TLabel;
    Line4: TLine;
    Image1: TImage;
    DateEdit1: TDateEdit;
    Image2: TImage;
    Rectangle1: TRectangle;
    img_add: TImage;
    procedure img_voltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentosCad: TFrmLancamentosCad;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmLancamentosCad.img_voltarClick(Sender: TObject);
begin
    close;
end;

end.
