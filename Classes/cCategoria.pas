unit cCategoria;

interface

uses
    FireDAC.Comp.Client,
    FireDAC.DApt,

    FMX.Graphics,

    System.SysUtils;

type
    TCategoria = class
    private
        Fconn: TFDConnection;
        FID_CATEGORIA: Integer;
        FDESCRICAO: string;
        FICONE: TBitmap;
        FINDICE_ICONE: Integer;
    public
        constructor Create(conn: TFDConnection);
        property ID_CATEGORIA: Integer Read FID_CATEGORIA Write FID_CATEGORIA;
        property DESCRICAO: string Read FDESCRICAO Write FDESCRICAO;
        property ICONE: TBitmap Read FICONE Write FICONE;
        property INDICE_ICONE : Integer  read FINDICE_ICONE write FINDICE_ICONE;

        function ListarCategoria(out erro: String): TFDQuery;
        function Inserir(out erro: String): Boolean;
        function Alterar(out erro: String): Boolean;
        function Excluir(out erro: String): Boolean;
end;

implementation

{ TCategoria }

constructor TCategoria.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;

function TCategoria.Inserir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if DESCRICAO = '' then
    begin
        erro   := 'Informe a descrição da categoria';
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
                SQL.Add('INSERT INTO TAB_CATEGORIA(DESCRICAO, ICONE, INDICE_ICONE)');
                SQL.Add('VALUES(:DESCRICAO, :ICONE, :INDICE_ICONE)');
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ParamByName('ICONE').Assign(ICONE);
                ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao inserir categoria: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TCategoria.ListarCategoria(out erro: String): TFDQuery;
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
            SQL.Add('SELECT * FROM TAB_CATEGORIA');
            SQL.Add('WHERE 1 =1');

            if ID_CATEGORIA > 0  then
            begin
                SQL.Add('AND ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            end;

            SQL.Add('ORDER BY DESCRICAO');

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

function TCategoria.Alterar(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if DESCRICAO = '' then
    begin
        erro   := 'Informe a descrição da categoria';
        Result := False;
        Exit;
    end;

    if ID_CATEGORIA = 0 then
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
                SQL.Add('UPDATE TAB_CATEGORIA SET DESCRICAO=:DESCRICAO, ICONE=:ICONE, ');
                SQL.Add('INDICE_ICONE=:INDICE_ICONE');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('DESCRICAO').Value    := DESCRICAO;
                ParamByName('INDICE_ICONE').Value := INDICE_ICONE;

                ParamByName('ICONE').Assign(ICONE);
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao alterar categoria: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TCategoria.Excluir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if ID_CATEGORIA = 0 then
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
                SQL.Add('SELECT * FROM TAB_LANCAMENTO');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                Active := True;

                if RecordCount > 0  then
                begin
                    Result := False;
                    erro := 'A Categoria possui lançamentos e não pode ser excluída!';
                    Exit
                end;

                Active := False;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_CATEGORIA');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao excluir categoria: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

end.
