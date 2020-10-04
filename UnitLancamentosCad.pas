unit UnitLancamentosCad;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,

  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.DateTimeCtrls,
  FMX.Dialogs,
  FMX.DialogService,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  FMX.ListBox,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants,

  uFormat;

type
  TFrmLancamentosCad = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_descricao: TEdit;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    edt_valor: TEdit;
    Line2: TLine;
    Layout4: TLayout;
    Label4: TLabel;
    Layout5: TLayout;
    Label5: TLabel;
    Line4: TLine;
    img_hoje: TImage;
    dt_lanc: TDateEdit;
    img_ontem: TImage;
    rect_delete: TRectangle;
    img_delete: TImage;
    img_tipo_lanc: TImage;
    img_despesa: TImage;
    img_receita: TImage;
    cmb_categoria: TComboBox;
    procedure img_voltarClick(Sender: TObject);
    procedure img_tipo_lancClick(Sender: TObject);
    procedure img_hojeClick(Sender: TObject);
    procedure img_ontemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_saveClick(Sender: TObject);
    procedure edt_valorTyping(Sender: TObject);
    procedure img_deleteClick(Sender: TObject);
  private
    procedure ComboCategoria;
    { Private declarations }
  public
    { Public declarations }
    modo   : string;   // Inclusão / Alteração
    id_lanc : Integer;

  end;

var
  FrmLancamentosCad: TFrmLancamentosCad;

implementation

{$R *.fmx}

uses UnitPrincipal, CCategoria, UnitDM, cLancamento, UnitLancamentos;

procedure TFrmLancamentosCad.ComboCategoria;
//TODO: Mudar comboBox
var
    c : TCategoria;
    erro : string;
    qry : TFDQuery;
begin
    try
        cmb_categoria.Items.Clear;

        c := TCategoria.Create(dm.conn);
        qry := c.ListarCategoria(erro);

        if erro <> '' then
        begin
            ShowMessage(erro);
            Exit;
        end;


        while NOT qry.Eof do
        begin
            cmb_categoria.Items.AddObject(qry.FieldByName('DESCRICAO').AsString,
                                          TObject(qry.FieldByName('ID_CATEGORIA').AsInteger));
            qry.Next;
        end;
    finally
        qry.DisposeOf;
        c.DisposeOf;
    end;
end;

procedure TFrmLancamentosCad.edt_valorTyping(Sender: TObject);
begin
    Formatar(edt_valor, TFormato.Valor);
end;

procedure TFrmLancamentosCad.FormShow(Sender: TObject);
var
    Lanc : TLancamento;
    erro : string;
    qry  : TFDQuery;
begin
    ComboCategoria;

    if modo='I' then
    begin
       dt_lanc.Date         := Date;
       edt_descricao.Text   := '';
       edt_valor.Text       := '';
       img_tipo_lanc.Bitmap := img_despesa.Bitmap;
       rect_delete.Visible  := False;
    end
    else
    begin
        try
            Lanc               := TLancamento.Create(dm.conn);
            Lanc.ID_LANCAMENTO := id_lanc;
            qry                := Lanc.ListarLancamento(0,erro);

            if qry.RecordCount = 0 then
            begin
                ShowMessage('Lançamento não encontrado!');
                Exit;
            end;
            dt_lanc.Date         := qry.FieldByName('DATA').AsDateTime;
            edt_descricao.Text   := qry.FieldByName('DESCRICAO').AsString;
            if qry.FieldByName('VALOR').AsFloat < 0 then
            begin
                edt_valor.Text       := FormatFloat('#,##0.00',qry.FieldByName('VALOR').AsFloat * -1);
                img_tipo_lanc.Bitmap := img_despesa.Bitmap;
                img_tipo_lanc.Tag    := -1;
            end
            else
            begin
                edt_valor.Text       := FormatFloat('#,##0.00',qry.FieldByName('VALOR').AsFloat);
                img_tipo_lanc.Bitmap := img_receita.Bitmap;
                img_tipo_lanc.Tag    := 1;
            end;

            cmb_categoria.ItemIndex := cmb_categoria.items.IndexOf(qry.FieldByName('DESCRICAO_CATEGORIA').AsString);
            rect_delete.Visible  := True;

        finally
            Lanc.DisposeOf;
            qry.DisposeOf;
        end;
    end;
end;

procedure TFrmLancamentosCad.img_deleteClick(Sender: TObject);
var
    lanc   : TLancamento;
    erro  : string;
begin
   TDialogService.MessageDialog('Confirma exclusão do lançamento?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
     procedure(const AResult: TModalResult)
     var
        erro: string;
     begin
        if AResult = mrYes then
        begin
            try
                Lanc              := TLancamento.Create(dm.conn);
                Lanc.ID_LANCAMENTO := id_lanc;
                if not lanc.Excluir(erro) then
                begin
                    ShowMessage(erro);
                    Exit;
                end;

                Close;

            finally
                Lanc.DisposeOf;
            end;
        end;
      end);

end;

procedure TFrmLancamentosCad.img_hojeClick(Sender: TObject);
begin
    dt_lanc.Date := Date;
end;

procedure TFrmLancamentosCad.img_ontemClick(Sender: TObject);
begin
    dt_lanc.Date := Date-1;
end;

function TrataValor(Str: string): Double;
begin
    // Recebe = 1.250,75
    str := StringReplace(str, '.', '', [rfReplaceAll]); // 1250,75
    str := StringReplace(str, ',', '', [rfReplaceAll]); // 125075

    try
        Result := StrToFloat(str) / 100;
    except
        Result := 0;
    end;
end;

procedure TFrmLancamentosCad.img_saveClick(Sender: TObject);
var
    Lanc : TLancamento;
    erro : string;
begin
    try
        Lanc               := TLancamento.Create(dm.conn);
        Lanc.DESCRICAO     := edt_descricao.Text;
        Lanc.VALOR         := TrataValor(edt_valor.Text) * img_tipo_lanc.Tag;
        Lanc.ID_CATEGORIA  := Integer(cmb_categoria.Items.Objects[cmb_categoria.ItemIndex]);
        Lanc.DATA          := dt_lanc.Date;

        if modo='I' then
        begin
            Lanc.Inserir(erro);
        end
        else
        begin
            Lanc.ID_LANCAMENTO := id_lanc;
            Lanc.Alterar(erro);
        end;

        if erro <> '' then
        begin
            ShowMessage(erro);
            Exit;
        end;

        Close;

    finally
        Lanc.DisposeOf;
    end;

end;

procedure TFrmLancamentosCad.img_tipo_lancClick(Sender: TObject);
begin
    if img_tipo_lanc.tag = 1 then
    begin
        img_tipo_lanc.Bitmap := img_despesa.Bitmap;
        img_tipo_lanc.Tag    := -1;
    end
    else
    begin
        img_tipo_lanc.Bitmap := img_receita.Bitmap;
        img_tipo_lanc.Tag    := 1;
    end;;
end;

procedure TFrmLancamentosCad.img_voltarClick(Sender: TObject);
begin
    close;
end;

end.
