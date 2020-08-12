unit UnitCategoriasCad;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TFrmCategoriasCad = class(TForm)
    lyt_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    img_salvar: TImage;
    rect_botton: TRectangle;
    img_add: TImage;
    Layout1: TLayout;
    Label2: TLabel;
    edt_login_email: TEdit;
    Line1: TLine;
    Label1: TLabel;
    lb_icone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    img_selecao: TImage;
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
  private
    icone_selecionado: TBitmap;
    procedure SelecionaIcone(img: TImage);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoriasCad: TFrmCategoriasCad;

implementation

uses
  UnitPrincipal;

{$R *.fmx}

procedure TFrmCategoriasCad.SelecionaIcone(img: TImage);
begin
    icone_selecionado  := img.Bitmap;  //salvou o icone selecionado
    img_selecao.Parent := img.Parent;
end;

procedure TFrmCategoriasCad.FormResize(Sender: TObject);
begin
    lb_icone.Columns := Trunc(lb_icone.Width / 80);
end;

procedure TFrmCategoriasCad.Image1Click(Sender: TObject);
begin
    SelecionaIcone(TImage(Sender));
end;

procedure TFrmCategoriasCad.img_voltarClick(Sender: TObject);
begin
    Close;
end;

end.
