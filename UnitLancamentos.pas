unit UnitLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lbl_mes: TLabel;
    rect_botton: TRectangle;
    Image4: TImage;
    Layout3: TLayout;
    Layout4: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Layout5: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout6: TLayout;
    Label6: TLabel;
    Label7: TLabel;
    lv_lancamento: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentos: TFrmLancamentos;

implementation

uses
  UnitPrincipal;

{$R *.fmx}

procedure TFrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{    Action        := TCloseAction.caFree;
    FrmLancamentos := nil;
}
end;

procedure TFrmLancamentos.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    foto := TMemoryStream.Create;
    FrmPrincipal.img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for x := 1 to 10 do
        FrmPrincipal.AddLancamento(lv_lancamento,
                      '00001', 'Compra de Passagem teste 123456 ', 'Transporte',
                       -45, date, foto);

    foto.DisposeOf;

end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupLancamento(AItem,lv_lancamento.Width);
end;

end.
