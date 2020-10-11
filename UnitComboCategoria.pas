unit UnitComboCategoria;

interface

uses
  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.DApt,


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
  TfrmComboCategoria = class(TForm)
    lyt_Toolbar: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure ListarCategorias;
    { Private declarations }
  public
    { Public declarations }
    CategoriaSelecao : string;
    IdCategoriaSelecao : Integer;
  end;

var
  frmComboCategoria: TfrmComboCategoria;

implementation

uses
  UnitPrincipal, cCategoria, UnitDM;

{$R *.fmx}

procedure TfrmComboCategoria.FormShow(Sender: TObject);
begin
    ListarCategorias;
end;

procedure TfrmComboCategoria.img_voltarClick(Sender: TObject);
begin
    IdCategoriaSelecao := 0;
    CategoriaSelecao   := '';
    Close;
end;

procedure TfrmComboCategoria.ListarCategorias;
var
    cat   : TCategoria;
    qry   : TFDQuery;
    erro  : string;
    icone : TStream;
begin
    try
        lv_categoria.Items.Clear;

        cat := TCategoria.Create(dm.conn);
        qry := cat.ListarCategoria(erro);

        while NOT qry.Eof do
        begin
            //Icone
           if qry.FieldByName('ICONE').AsString <> '' then
              icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
           else
              icone := nil;

           FrmPrincipal.AddCategoria(frmComboCategoria.lv_categoria,
                                 qry.FieldByName('ID_CATEGORIA').AsString,
                                 qry.FieldByName('DESCRICAO').AsString,
                                 icone);

            if icone <> nil then
                icone.DisposeOf;
            qry.Next;
        end;
    finally
        qry.DisposeOf;
        cat.DisposeOf;
    end;
end;

procedure TfrmComboCategoria.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    IdCategoriaSelecao := AItem.TagString.ToInteger;
    CategoriaSelecao   := TListItemText(AItem.Objects.FindDrawable('TxtCategoria')).Text;
    Close;
end;

end.
