unit UnitLancamentos;

interface

uses
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
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    img_anterior: TImage;
    img_proximo: TImage;
    Image3: TImage;
    lbl_mes: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    Label5: TLabel;
    lbl_rec: TLabel;
    lbl_desp: TLabel;
    Label3: TLabel;
    lbl_saldo: TLabel;
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
    procedure img_proximoClick(Sender: TObject);
    procedure img_anteriorClick(Sender: TObject);
    procedure lbl_mesClick(Sender: TObject);
  private
    dt_Filtro : TDate;
    procedure AbrirLancamento(id_lancamento: string);
    procedure ListarLancamentos;
    procedure NavegarMes(num_mes: Integer);
    function NomeMes: string;
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

function TFrmLancamentos.NomeMes() : string;
begin
    case MonthOf(dt_filtro) of
        1 : Result := 'Janeiro';
        2 : Result := 'Fevereiro';
        3 : Result := 'Mar�o';
        4 : Result := 'Abril';
        5 : Result := 'Maio';
        6 : Result := 'Junho';
        7 : Result := 'Julho';
        8 : Result := 'Agosto';
        9 : Result := 'Setembro';
        10 : Result := 'Outubro';
        11 : Result := 'Novembro';
        12 : Result := 'Dezembro';
    end;

    Result := Result + ' / ' + YearOf(dt_filtro).ToString;
end;

procedure TFrmLancamentos.NavegarMes(num_mes: Integer);
begin
    dt_Filtro    := IncMonth(dt_Filtro, num_mes);
    lbl_mes.Text := NomeMes;
    ListarLancamentos;

end;

procedure TFrmLancamentos.ListarLancamentos;
var
//    x : integer;

    Lanc    : TLancamento;
    qry     : TFDQuery;
    erro    : string;
    foto    : TStream;
    vl_rec,
    vl_desp : Double;
begin
    try
        FrmLancamentos.lv_lancamento.Items.Clear;
        vl_rec        := 0;
        vl_desp       := 0;

        Lanc          := TLancamento.Create(dm.conn);
        Lanc.DATA_DE  := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dt_Filtro));
        Lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dt_Filtro));
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

            FrmPrincipal.AddLancamento(FrmLancamentos.lv_lancamento,
                          qry.FieldByName('ID_LANCAMENTO').AsString,
                          qry.FieldByName('DESCRICAO').AsString,
                          qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                          qry.FieldByName('VALOR').AsFloat,
                          qry.FieldByName('DATA').AsDateTime,
                          foto
                          );

            if qry.FieldByName('VALOR').AsFloat > 0 then
                vl_rec  := vl_rec + qry.FieldByName('VALOR').AsFloat
            else
                vl_desp := vl_desp + qry.FieldByName('VALOR').AsFloat;

            qry.Next;

            foto.DisposeOf;
        end;
        lbl_rec.Text   := 'R$ ' + Formatfloat('#,##0.00',vl_rec);
        lbl_desp.Text  := 'R$ ' + Formatfloat('#,##0.00',vl_desp);
        lbl_saldo.Text := 'R$ ' + Formatfloat('#,##0.00',vl_rec+vl_desp);  // Somamos pq o vl_desp j� esta negativo...

        if (vl_rec+vl_desp)<0 then
            lbl_saldo.TextSettings.FontColor := $FFD0D0D0
        else
            lbl_saldo.TextSettings.FontColor := $FFFFFFFF;

    finally
        Lanc.DisposeOf;
    end;

end;

procedure TFrmLancamentos.FormShow(Sender: TObject);

begin
    dt_filtro := Date;
    NavegarMes(0);
end;

procedure TFrmLancamentos.img_addClick(Sender: TObject);
begin
    AbrirLancamento('');
end;

procedure TFrmLancamentos.img_anteriorClick(Sender: TObject);
begin
    NavegarMes(-1);
end;

procedure TFrmLancamentos.img_proximoClick(Sender: TObject);
begin
    NavegarMes(1);
end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmLancamentos.lbl_mesClick(Sender: TObject);
begin
    //TODO: Deixar escolher o m�s pelo calend�rio
end;

procedure TFrmLancamentos.AbrirLancamento(id_lancamento: string);
begin
    if NOT Assigned(FrmLancamentosCad) then
        Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

    if id_lancamento = '' then
    begin
        FrmLancamentosCad.modo    := 'I';
        FrmLancamentosCad.id_lanc := 0;
    end
    else
    begin
        FrmLancamentosCad.modo    := 'A';
        FrmLancamentosCad.id_lanc := id_lancamento.ToInteger;
    end;


    FrmLancamentosCad.Show;
end;

procedure TFrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    AbrirLancamento(AItem.TagString);
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupLancamento(FrmLancamentos.lv_lancamento, AItem);
end;

end.
