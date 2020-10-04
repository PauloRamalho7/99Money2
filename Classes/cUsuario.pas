unit cUsuario;

interface

uses
    FireDAC.Comp.Client,
    FireDAC.DApt,

    FMX.Graphics,

    System.SysUtils;

type
    TUsuario = class
    private
        Fconn: TFDConnection;
        FIND_LOGIN: String;
        FEMAIL: string;
        FSENHA: string;
        FNOME: string;
        FID_USUARIO: Integer;
        FFOTO: TBitmap;
    public
        constructor Create(conn: TFDConnection);
        property ID_USUARIO: Integer Read FID_USUARIO Write FID_USUARIO;
        property NOME: string Read FNOME Write FNOME;
        property EMAIL: string Read FEMAIL Write FEMAIL;
        property SENHA: string Read FSENHA Write FSENHA;
        property IND_LOGIN : string  read FIND_LOGIN write FIND_LOGIN;
        property FOTO: TBitmap Read FFOTO Write FFOTO;

        function ListarUsuario(out erro: String): TFDQuery;
        function ValidarLogin(out erro: String): Boolean;
        function Inserir(out erro: String): Boolean;
        function Alterar(out erro: String): Boolean;
        function Excluir(out erro: String): Boolean;
        function Logout(out erro: string): boolean;
end;

implementation

{ TCategoria }

constructor TUsuario.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;

function TUsuario.Excluir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin


    try
        try
            qry            := TFDQuery.Create(nil);
            qry.Connection := Fconn;


            with qry do
            begin
                Active := False;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_USUARIO');

                if ID_USUARIO > 0  then
                begin
                    SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
                    ParamByName('ID_USUARIO').Value := ID_USUARIO;
                end;

                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao excluir usuário: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TUsuario.Inserir(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if NOME = '' then
    begin
        erro   := 'Informe o nome do usuário!';
        Result := False;
        Exit;
    end;

    if EMAIL = '' then
    begin
        erro   := 'Informe o e-mail do usuário!';
        Result := False;
        Exit;
    end;

    if SENHA = '' then
    begin
        erro   := 'Informe a senha do usuário!';
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
                SQL.Add('INSERT INTO TAB_USUARIO(NOME, EMAIL, SENHA, IND_LOGIN, FOTO)');
                SQL.Add('VALUES(:NOME, :EMAIL, :SENHA, :IND_LOGIN, :FOTO)');
                ParamByName('NOME').Value      := NOME;
                ParamByName('EMAIL').Value     := EMAIL;
                ParamByName('SENHA').Value     := SENHA;
                ParamByName('IND_LOGIN').Value := IND_LOGIN;
                ParamByName('FOTO').Assign(FOTO);
                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao inserir usuário: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;

function TUsuario.ListarUsuario(out erro: String): TFDQuery;
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
            SQL.Add('SELECT * FROM TAB_USUARIO');
            SQL.Add('WHERE 1 =1');

            if ID_USUARIO > 0  then
            begin
                SQL.Add('AND ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end;

            if EMAIL <> ''  then
            begin
                SQL.Add('AND EMAIL = :EMAIL');
                ParamByName('EMAIL').Value := EMAIL;
            end;

            if SENHA <> ''  then
            begin
                SQL.Add('AND SENHA = :SENHA');
                ParamByName('SENHA').Value := SENHA;
            end;

            Active := True;
        end;

        Result := qry;
        erro   := '';

    except on ex:Exception do
    begin
        Result := nil;
        erro   := 'Erro ao consultar usuários: '+ ex.Message;
    end;
    end;


end;

function TUsuario.Alterar(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    if NOME = '' then
    begin
        erro   := 'Informe o nome do usuário!';
        Result := False;
        Exit;
    end;

    if EMAIL = '' then
    begin
        erro   := 'Informe o e-mail do usuário!';
        Result := False;
        Exit;
    end;

    if SENHA = '' then
    begin
        erro   := 'Informe a senha do usuário!';
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
                SQL.Add('UPDATE TAB_USUARIO SET NOME=:NOME, EMAIL=:EMAIL, ');
                SQL.Add('SENHA=:SENHA, IND_LOGIN=:IND_LOGIN, FOTO=:FOTO');
                SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
                ParamByName('NOME').Value       := NOME;
                ParamByName('EMAIL').Value      := EMAIL;
                ParamByName('SENHA').Value      := SENHA;
                ParamByName('IND_LOGIN').Value  := IND_LOGIN;
                ParamByName('FOTO').Assign(FOTO);


                ExecSQL;
            end;

            Result := True;
            erro   := '';

        except on ex:exception do
        begin
            Result := False;
            erro   := 'Erro ao alterar usuário: '+ ex.Message;
        end;
        end;  // end try

    finally
        qry.DisposeOf;
    end;

end;


function TUsuario.ValidarLogin(out erro: String): Boolean;
var
    qry : TFDQuery;
begin

    if EMAIL = '' then
    begin
        erro   := 'Informe o e-mail do usuário!';
        Result := False;
        Exit;
    end;

    if SENHA = '' then
    begin
        erro   := 'Informe a senha do usuário!';
        Result := False;
        Exit;
    end;

    try
        qry            := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        try

            with qry do
            begin
                Active := False;
                SQL.Clear;
                SQL.Add('SELECT * FROM TAB_USUARIO');
                SQL.Add('WHERE EMAIL = :EMAIL');
                SQL.Add('AND SENHA = :SENHA');

                ParamByName('EMAIL').Value := EMAIL;
                ParamByName('SENHA').Value := SENHA;

                Active := True;


                if RecordCount = 0 then
                begin
                    Result := False;
                    erro   := 'Email ou senha inválidos!';
                    Exit
                end;

                Active := False;
                SQL.Clear;
                SQL.Add('UPDATE TAB_USUARIO');
                SQL.Add('SET IND_LOGIN=''S''');
                ExecSql;

            end;
            Result := True;
            erro   := '';

        except on ex:Exception do
        begin
            Result := False;
            erro   := 'Erro ao validar login: '+ ex.Message;
        end;
        end;
    finally
       qry.DisposeOf;
    end;


end;

function TUsuario.Logout(out erro: string): boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        try
            with qry do
            begin
                Active := false;
                sql.Clear;
                sql.Add('UPDATE TAB_USUARIO');
                SQL.Add('SET IND_LOGIN = ''N''');
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao fazer logout: ' + ex.Message;
        end;
        end;
    finally
        qry.DisposeOf;
    end;
end;

end.
