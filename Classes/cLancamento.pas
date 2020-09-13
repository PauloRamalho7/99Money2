unit cLancamento;

interface

uses
    FireDAC.Comp.Client,
    FireDAC.DApt,

    FMX.Graphics,

    System.SysUtils;

type
    TLancamento = class
    private
    Fconn: TFDConnection;
    FVALOR: Double;
    FDESCRICAO: string;
    FID_CATEGORIA: Integer;
    FDATA: TDateTime;
    FID_LANCAMENTO: Integer;
    public
        constructor Create(conn: TFDConnection);
        property ID_LANCAMENTO: Integer Read FID_LANCAMENTO Write FID_LANCAMENTO;
        property ID_CATEGORIA: Integer Read FID_CATEGORIA Write FID_CATEGORIA;
        property VALOR : Double read FVALOR write FVALOR;
        property DATA : TDateTime read FDATA write FDATA;
        property DESCRICAO: string Read FDESCRICAO Write FDESCRICAO;

        function ListarLancamento(out erro: String): TFDQuery;
        function Inserir(out erro: String): Boolean;
        function Alterar(out erro: String): Boolean;
        function Excluir(out erro: String): Boolean;
end;

implementation

{ TCategoria }

constructor TLancamento.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;


function TLancamento.Inserir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if DESCRICAO = '' then
    begin
        erro   := 'Informe a descrição do lançamento';
        Result := False;
        Exit;
    end;

    if ID_CATEGORIA <= 0 then
    begin
        erro   := 'Informe o ID da categoria';
        Result := False;
        Exit;
    end;

    try
        try
            qry            := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := False;
                SQL.Clear;
                SQL.Add('INSERT INTO TAB_LANCAMENTO(ID_CATEGORIA, VALOR, DATA, DESCRICAO)');
                SQL.Add('VALUES(:ID_CATEGORIA, :VALOR, :DATA, :DESCRICAO)');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('VALOR').Value        := VALOR;
                ParamByName('DATA').Value         := DATA;
                ParamByName('DESCRICAO').Value    := DESCRICAO;
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao inserir lançamento: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TLancamento.ListarLancamento(out erro: String): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry            := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        with qry do
        begin
            Active := False;
            SQL.Clear;
            SQL.Add('SELECT L.*, C.DESCRICAO AS DESCRICAO_CATEGORIA, C.ICONE');
            SQL.Add(' FROM TAB_LANCAMENTO L');
            SQL.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
            SQL.Add('WHERE 1 = 1');

            if ID_LANCAMENTO > 0  then
            begin
                SQL.Add('AND ID_LANCAMENTO = :ID_LANCAMENTO');
                ParamByName('ID_LANCAMENTO').Value := ID_LANCAMENTO;
            end;

            Active := True;
        end;

        Result := qry;
        erro   := '';

    except on ex:Exception do
    begin
        Result := nil;
        erro   := 'Erro ao consultar categorias: '+ ex.Message;
    end;
    end;


end;

function TLancamento.Alterar(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if DESCRICAO = '' then
    begin
        erro   := 'Informe a descrição do lançamento';
        Result := False;
        Exit;
    end;

    if ID_CATEGORIA <= 0 then
    begin
        erro   := 'Informe o ID da categoria';
        Result := False;
        Exit;
    end;

    if ID_LANCAMENTO <= 0 then
    begin
        erro   := 'Informe o ID do lançamento';
        Result := False;
        Exit;
    end;


    try
        try
            qry            := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := False;
                SQL.Clear;
                SQL.Add('UPDATE TAB_LANCAMENTO SET ID_CATEGORIA=:ID_CATEGORIA, VALOR=:VALOR, ');
                SQL.Add('DATA=:DATA, DESCRICAO=:DESCRICAO)');
                SQL.Add('WHERE ID_LANCAMENTO = :ID_LANCMENTO');

                ParamByName('ID_LANCAMENTO').Value := ID_LANCAMENTO;
                ParamByName('ID_CATEGORIA').Value  := ID_CATEGORIA;
                ParamByName('VALOR').Value         := VALOR;
                ParamByName('DATA').Value          := DATA;
                ParamByName('DESCRICAO').Value     := DESCRICAO;
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao alterar lançamento: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TLancamento.Excluir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if ID_LANCAMENTO <= 0 then
    begin
        erro   := 'Informe o ID do lançamento';
        Result := False;
        Exit;
    end;


    try
        try
            qry            := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := False;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_LANCAMENTO');
                SQL.Add('WHERE ID_LANCAMENTO = :ID_LANCAMENTO');
                ParamByName('ID_LANCAMENTO').Value := ID_LANCAMENTO;
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao excluir lançamento: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

end.
