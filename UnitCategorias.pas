unit UnitCategorias;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
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
  System.Variants, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmCategorias = class(TForm)
    lyt_toolbar: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    rect_botton: TRectangle;
    img_add: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CadCategoria(id_cat: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategorias: TFrmCategorias;

implementation

uses
  UnitPrincipal, UnitCategoriasCad;

{$R *.fmx}

procedure TFrmCategorias.CadCategoria(id_cat: string);
begin
    if NOT Assigned(FrmCategoriasCad) then
        Application.CreateForm(TFrmCategoriasCad,FrmCategoriasCad);

    FrmCategoriasCad.rect_botton.Visible := False;
    if id_cat = '' then
    begin
        FrmCategoriasCad.lbl_titulo.Text     := 'Nova Categoria';
    end
    else
    begin
        FrmCategoriasCad.lbl_titulo.Text     := 'Editar Categoria';
        FrmCategoriasCad.rect_botton.Visible := True;
    end;

    FrmCategoriasCad.Show;

end;

procedure TFrmCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action        := TCloseAction.caFree;
    FrmCategorias := nil;
end;

procedure TFrmCategorias.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    foto := TMemoryStream.Create;
    FrmPrincipal.img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for x := 1 to 10 do
        FrmPrincipal.AddCategoria(lv_categoria,
                                  '00001',
                                  'Transporte',
                                   foto);

    foto.DisposeOf;
end;

procedure TFrmCategorias.img_addClick(Sender: TObject);
begin
    CadCategoria('');
end;

procedure TFrmCategorias.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmCategorias.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    CadCategoria(AItem.TagString);
end;

procedure TFrmCategorias.lv_categoriaUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupCategoria(AItem,lv_categoria.Width);
end;

end.
