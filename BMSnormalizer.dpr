program BMSnormalizer;

uses
  Forms,
  NormalizerForm in 'NormalizerForm.pas' {Form1},
  FunctionUnit in 'FunctionUnit.pas',
  ThreadUnit in 'ThreadUnit.pas',
  mgfile in 'mgfile.pas',
  DataTypeUnit in 'DataTypeUnit.pas',
  InfoForm in 'InfoForm.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'BMSNormalizer 0.2';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
