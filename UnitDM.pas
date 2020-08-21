unit UnitDM;

interface

uses
  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Pool,
  FireDAC.UI.Intf,

  System.Classes,
  System.IOUtils,
  System.SysUtils;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
    with Conn do
    begin
        {$IFDEF MSWINDOWS}
        try
//            Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\banco.db';
            Params.Values['Database'] := 'D:\Projetos\99Money2\DB\banco.db';

            Connected := true;
        except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;

        {$ELSE}

        Params.Values['DriverID'] := 'SQLite';
        try
            Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
            Connected := true;
        except on E:Exception do
            raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;
        {$ENDIF}
    end;
end;

end.
