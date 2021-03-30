unit UnitLancamentosResumo;

interface

uses
  cLancamento,

  Data.DB,

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

  FireDAC.Comp.Client,
  FireDAC.DApt,

  System.Classes,
  System.DateUtils,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TfrmLancamentosResumo = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image3: TImage;
    lbl_mes: TLabel;
    lv_resumo: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_voltarClick(Sender: TObject);
    procedure lv_resumoUpdatingObjects(const Sender: TObject;
      const AItem: TListViewItem; var AHandled: Boolean);
  private
    procedure AddCategoria(listview: TListView; categoria: string;
      valor: double; foto: TStream);
    procedure MontarResumo;
    { Private declarations }
  public
    dt_filtro : TDate;
    { Public declarations }
  end;

var
  frmLancamentosResumo: TfrmLancamentosResumo;

implementation

uses
  UnitPrincipal, UnitDM;

{$R *.fmx}
procedure TFrmLancamentosResumo.AddCategoria(listview: TListView;
                                      categoria: string;
                                      valor: double;
                                      foto: TStream);
var
    txt : TListItemText;
    img : TListItemImage;
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin
        txt      := TListItemText(Objects.FindDrawable('TxtCategoria'));
        txt.Text := categoria;

        txt      := TListItemText(Objects.FindDrawable('TxtValor'));
        txt.Text := FormatFloat('#,##0.00', valor);
        TagFloat := valor;
        if valor < 0 then
            Txt.TextColor := $FFF58162
        else
            Txt.TextColor := $FF69F944;


        // Icone...
        img := TListItemImage(Objects.FindDrawable('ImgIcone'));

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);

            img.OwnsBitmap := true;
            img.Bitmap := bmp;
        end;

    end;
end;

procedure TFrmLancamentosResumo.MontarResumo;
var
    lanc : TLancamento;
    qry: TFDQuery;
    erro: string;
    icone: TStream;
begin
    try
        lv_resumo.Items.Clear;

        lanc := TLancamento.Create(dm.conn);
        lanc.DATA_DE  := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dt_filtro));
        lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dt_filtro));
        qry := lanc.ListarResumo(erro);

        while NOT qry.Eof do
        begin
            // Icone...
            if qry.FieldByName('ICONE').AsString <> '' then
                icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
            else
                icone := nil;

            FrmLancamentosResumo.AddCategoria(lv_resumo,
                                              qry.FieldByName('DESCRICAO').AsString,
                                              qry.FieldByName('VALOR').AsCurrency,
                                              icone);

            if icone <> nil then
                icone.DisposeOf;

            qry.Next;
        end;

    finally
        qry.DisposeOf;
        lanc.DisposeOf;
    end;
end;


procedure TfrmLancamentosResumo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmLancamentosResumo := nil;
end;

procedure TfrmLancamentosResumo.FormShow(Sender: TObject);
begin
    MontarResumo;
end;

procedure TfrmLancamentosResumo.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmLancamentosResumo.lv_resumoUpdatingObjects(const Sender: TObject;
  const AItem: TListViewItem; var AHandled: Boolean);
var
    txt : TListItemText;
begin
        txt      := TListItemText(AItem.Objects.FindDrawable('TxtValor'));
        if txt.TagFloat < 0 then
            Txt.TextColor := $FFF58162
        else
            Txt.TextColor := $FF69F944;

end;

end.
