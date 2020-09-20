unit UnitLancamentos;

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
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lbl_mes: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    img_add: TImage;
    lv_lancamento: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
  private
    procedure EditarLancamento(id_lancamento: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentos: TFrmLancamentos;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitLancamentosCad, cLancamento, UnitDM;

procedure TFrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //Action := TCloseAction.caFree;
    //FrmLancamentos := nil;  // Estamos destruindo no close do FrmPrincipal
end;

procedure TFrmLancamentos.FormShow(Sender: TObject);
var
//    x : integer;

    Lanc : TLancamento;
    qry  : TFDQuery;
    erro : string;
    foto : TStream;

begin
    try
        lanc := TLancamento.Create(dm.conn);
        qry  := Lanc.ListarLancamento(0, erro);

        if erro <> '' then
        begin
            ShowMessage(erro);
            Exit;
        end;


        while NOT qry.Eof do
        begin
            if qry.FieldByName('ICONE').AsString <> '' then
                foto := qry.CreateBlobStream(qry.FieldByName('ICONE'),TBlobStreamMode.bmRead)
            else
                foto := nil;

            FrmPrincipal.AddLancamento(FrmPrincipal.lv_lancamento,
                          qry.FieldByName('ID_LANCAMENTO').AsString,
                          qry.FieldByName('DESCRICAO').AsString,
                          qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                          qry.FieldByName('VALOR').AsFloat,
                          qry.FieldByName('DATA').AsDateTime,
                          foto
                          );

            qry.Next;

            foto.DisposeOf;
        end;

    finally
        Lanc.DisposeOf;
    end;
end;

procedure TFrmLancamentos.img_addClick(Sender: TObject);
begin
    EditarLancamento('');
end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmLancamentos.EditarLancamento(id_lancamento: string);
begin
    if NOT Assigned(FrmLancamentosCad) then
        Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

    FrmLancamentosCad.Show;
end;

procedure TFrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    EditarLancamento('');
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupLancamento(FrmLancamentos.lv_lancamento, AItem);
end;

end.
