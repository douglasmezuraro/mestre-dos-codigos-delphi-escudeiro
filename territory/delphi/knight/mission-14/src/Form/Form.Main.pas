unit Form.Main;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Data.DB, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Grids;

type
  TMain = class sealed(TForm)
    DataSourceEmployees: TDataSource;
    PageControl: TPageControl;
    TabSheetEmployees: TTabSheet;
    GridEmployees: TDBGrid;
    TabSheetDepartments: TTabSheet;
    GridDepartments: TDBGrid;
    TabSheetRelationship: TTabSheet;
    DataSourceDepartments: TDataSource;
    GridRelationship: TDBGrid;
    DataSourceEmployeesDepartments: TDataSource;
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

end.

