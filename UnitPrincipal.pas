unit UnitPrincipal;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.ListView,
  FMX.ListView.Adapters.Base,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    Circle1: TCircle;
    img_notif: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    Image4: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label8: TLabel;
    lbl_todos_lanc: TLabel;
    lv_lancamento: TListView;
    img_categoria: TImage;
    StyleBook1: TStyleBook;
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lbl_todos_lancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image4Click(Sender: TObject);
    procedure img_menuClick(Sender: TObject);
  private

  public
    procedure SetupCategoria(item: TListViewItem; aWidth: Single);
    procedure AddCategoria(listview: TListView; id_categoria, categoria: string;
                           foto: TStream);
    procedure SetupLancamento(item: TListViewItem; aWidth: Single);
    procedure AddLancamento(listview : TListView;
                            id_lancamento, descricao, categoria: string;
                            valor : double; dt_lanc : TDateTime;
                            foto: TStream);
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  UnitCategorias,
  UnitLancamentos;

{$R *.fmx}

procedure TFrmPrincipal.AddLancamento(listview : TListView;
                                      id_lancamento, descricao, categoria: string;
                                      valor : double; dt_lanc : TDateTime;
                                      foto: TStream);
var
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin
        TagString := id_lancamento;

        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtValor')).Text     := FormatFloat('#,##0.00',valor);
        TListItemText(Objects.FindDrawable('TxtData')).Text      := FormatDateTime('dd/mm',dt_lanc);

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap     := bmp;
            //não precisa destruir pq está dentro da listview;
        end;

    end;
end;

procedure TFrmPrincipal.AddCategoria(listview : TListView;
                                      id_categoria,
                                      categoria: string;
                                      foto: TStream);
var
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin
        TagString := id_categoria;

        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap     := bmp;
            //não precisa destruir pq está dentro da listview;
        end;

    end;
end;


procedure TFrmPrincipal.SetupLancamento(item : TListViewItem; aWidth: Single);
begin
 {   if lv_lancamento.Width < 200 then
    begin
        TListItemImage(Item.Objects.FindDrawable('ImgIcone')).Visible := false;
        TListItemText(Item.Objects.FindDrawable('TxtDescricao')).PlaceOffset.X := 22;
    end;
}
    TListItemText(Item.Objects.FindDrawable('TxtDescricao')).Width := aWidth -
                TListItemText(Item.Objects.FindDrawable('TxtDescricao')).PlaceOffset.X -100;

end;

procedure TFrmPrincipal.SetupCategoria(item : TListViewItem; aWidth: Single);
begin
    TListItemText(Item.Objects.FindDrawable('TxtCategoria')).Width := aWidth -
                TListItemText(Item.Objects.FindDrawable('TxtCategoria')).PlaceOffset.X -20;

end;


procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if Assigned(FrmLancamentos) then
    begin
        FrmLancamentos.DisposeOf;
        FrmLancamentos := nil;
    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    foto := TMemoryStream.Create;
    img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for x := 1 to 10 do
        AddLancamento(lv_lancamento,
                      '00001', 'Compra de Passagem teste 123456 ', 'Transporte',
                       -45, date, foto);

    foto.DisposeOf;
end;

procedure TFrmPrincipal.Image4Click(Sender: TObject);
begin
    FrmLancamentos.EditarLancamento('');
end;

procedure TFrmPrincipal.img_menuClick(Sender: TObject);
begin
    if NOT Assigned(FrmCategorias) then
        Application.CreateForm(TFrmCategorias,FrmCategorias);

    FrmCategorias.Show;

end;

procedure TFrmPrincipal.lbl_todos_lancClick(Sender: TObject);
begin
    if not Assigned(FrmLancamentos) then
        Application.CreateForm(TFrmLancamentos,FrmLancamentos);
    FrmLancamentos.Show;
end;

procedure TFrmPrincipal.lv_lancamentoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  {
    if TListView(Sender).Selected <> nil then
    begin
        if ItemObject is TListItemImage then
        begin
            Image3.Bitmap := TListItemImage(ItemObject).Bitmap;
        end;

        if ItemObject is TListItemText then
        begin
            Label2.Text := TListItemText(ItemObject).Text;
        end;
    end;
    }
end;

procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    SetupLancamento(AItem,lv_lancamento.Width);
end;

end.
