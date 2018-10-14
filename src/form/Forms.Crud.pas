unit Forms.Crud;

interface

uses
  System.Actions,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  Utils.Constants,
  Utils.Messages,
  Vcl.ActnList,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Forms;

type
  TCrud = class(TForm)
    PanelButtons: TPanel;
    ActionListActions: TActionList;
    ActionInsert: TAction;
    ActionEdit: TAction;
    ActionRemove: TAction;
    ButtonInsert: TSpeedButton;
    ButtonEdit: TSpeedButton;
    ButtonRemove: TSpeedButton;
    StatusBarStatus: TStatusBar;
    procedure ActionInsertExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionRemoveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FRequiredComponents: TDictionary<TWinControl, TCustomLabel>;
    function GetLabel(Control: TControl): TCustomLabel;
    procedure DefineInitialFocus;
    function ValidateMandatoryComponents(out Control: TWinControl): Boolean;
  protected
    { Crud actions }
    procedure Insert; virtual;
    procedure Edit; virtual;
    procedure Remove; virtual;
    { Form initialization and finalization }
    procedure Initialize;
    procedure Finalize;
    { Mandatory components }
    procedure DefineMandatoryComponents(Components: TArray<TWinControl>); overload;
    procedure DefineMandatoryComponents; overload; virtual; abstract;
    { Other useful methods }
    procedure Clear; virtual; abstract;
    procedure SetStatusBarText(const Text: string);
    procedure ControlActions; virtual; abstract;
    function GetInitialFocus: TWinControl; virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Helpers.WinControl;

{ TCrud }

constructor TCrud.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FRequiredComponents := TDictionary<TWinControl, TCustomLabel>.Create;
end;

destructor TCrud.Destroy;
begin
  FreeAndNil(FRequiredComponents);
  inherited Destroy;
end;

procedure TCrud.ActionEditExecute(Sender: TObject);
begin
  Edit;
end;

procedure TCrud.ActionInsertExecute(Sender: TObject);
var
  Control: TWinControl;
  Caption: string;
begin
  if not ValidateMandatoryComponents(Control) then
  begin
    Caption := FRequiredComponents.Items[Control].Caption;
    Caption := Caption.Replace(MANDATORY_CHAR, string.Empty).QuotedString;
    TMessage.Information('O campo %s � obrigat�rio.', [Caption]);
    Exit;
  end;

  Insert;
  ControlActions;
end;

procedure TCrud.ActionRemoveExecute(Sender: TObject);
begin
  Remove;
  ControlActions;
end;

procedure TCrud.DefineMandatoryComponents(Components: TArray<TWinControl>);
var
  Control: TWinControl;
  CustomLabel: TCustomLabel;
begin
  for Control in Components do
  begin
    Control.Mandatory := True;
    CustomLabel := GetLabel(Control);
    CustomLabel.Caption := CustomLabel.Caption + MANDATORY_CHAR;
    FRequiredComponents.Add(Control, CustomLabel);
  end;
end;

procedure TCrud.Edit;
begin
  Exit;
end;

procedure TCrud.Finalize;
begin
  Exit;
end;

procedure TCrud.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Finalize;
end;

procedure TCrud.FormShow(Sender: TObject);
begin
  Initialize;
end;

function TCrud.GetInitialFocus: TWinControl;
begin
  Result := nil;
end;

function TCrud.GetLabel(Control: TControl): TCustomLabel;
var
  Index: Cardinal;
  Component: TComponent;
begin
  Result := nil;
  for Index := 0 to Pred(ComponentCount) do
  begin
    Component := Components[Index];

    if Component is TLabel then
    begin
      if Control = (Component as TLabel).FocusControl then
        Exit(Component as TLabel);
    end;

    if Component is TLabeledEdit then
    begin
      if Control = Component then
        Exit((Component as TLabeledEdit).EditLabel);
    end;
  end;
end;

procedure TCrud.DefineInitialFocus;
var
  Component: TWinControl;
begin
  Component := GetInitialFocus;
  if Assigned(Component) then
    Component.TrySetFocus;
end;

procedure TCrud.Initialize;
begin
  DefineMandatoryComponents;
  DefineInitialFocus;
  SetStatusBarText(Format('%s: campos obrigat�rios.', [MANDATORY_CHAR]));
  ControlActions;
end;

procedure TCrud.Insert;
begin
  TMessage.Information('Inserido com sucesso!');
end;

procedure TCrud.Remove;
begin
  Clear;
end;

procedure TCrud.SetStatusBarText(const Text: string);
begin
  StatusBarStatus.SimpleText := Text;
end;

function TCrud.ValidateMandatoryComponents(out Control: TWinControl): Boolean;
var
  Foo: TWinControl;
begin
  Result := True;
  for Foo in FRequiredComponents.Keys do
  begin
    if Foo is TCustomEdit then
      Result := not (Foo as TCustomEdit).IsEmpty
    else if Foo is TDateTimePicker then
      Result := not (Foo as TDateTimePicker).IsEmpty;

    if not Result then
      Control := Foo;
  end;
end;

end.
