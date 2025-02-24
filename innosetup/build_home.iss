; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Clash Meta For Windows Mini"
#define MyAppVersion "1.85"
#define MyAppPublisher "Kogeki, Inc."
#define MyAppURL "https://github.com/kogekiplay/ClashMetaForWindows_Mini"
#define MyAppExeName "CMFW_mini.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{86089AED-81D0-493F-80D7-ADA8EE646344}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=admin
;PrivilegesRequiredOverridesAllowed=dialog
OutputDir=F:\Downloads
OutputBaseFilename=CMFW_setup
SetupIconFile=F:\Git\ClashMetaForWindows_Mini\img\logo.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Dirs]
Name: {app}; Permissions: users-full

[Files]
Source: "F:\Git\ClashMetaForWindows_Mini\dist\run\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\Git\ClashMetaForWindows_Mini\dist\run\*"; Excludes:"\foo\bin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "F:\Git\ClashMetaForWindows_Mini\dist\run\foo\bin\*"; DestDir: "{app}\foo\bin"; Flags: onlyifdoesntexist recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]  
// 自定义函数，判断软件是否运行，参数为需要判断的软件的exe名称
function CheckSoftRun(strExeName: String): Boolean;
// 变量定义
var ErrorCode: Integer;
var bRes: Boolean;
var strFileContent: AnsiString;
var strTmpPath: String;  // 临时目录
var strTmpFile: String;  // 临时文件，保存查找软件数据结果
var strCmdFind: String;  // 查找软件命令
var strCmdKill: String;  // 终止软件命令
begin
  strTmpPath := GetTempDir();
  strTmpFile := Format('%sfindSoftRes.txt', [strTmpPath]);
  strCmdFind := Format('/c tasklist /nh|find /c /i "%s" > "%s"', [strExeName, strTmpFile]);
  strCmdKill := Format('/c taskkill /f /t /im %s', [strExeName]);
  bRes := ShellExec('open', ExpandConstant('{cmd}'), strCmdFind, '', SW_HIDE, ewWaitUntilTerminated, ErrorCode);
  if bRes then begin
      bRes := LoadStringFromFile(strTmpFile, strFileContent);
      strFileContent := Trim(strFileContent);
      if bRes then begin
         if StrToInt(strFileContent) > 0 then begin
            if MsgBox(ExpandConstant('{cm:checkSoftTip}'), mbConfirmation, MB_OKCANCEL) = IDOK then begin
             // 终止程序
             ShellExec('open', ExpandConstant('{cmd}'), strCmdKill, '', SW_HIDE, ewNoWait, ErrorCode);
             Result:= true;// 继续安装
            end else begin
             Result:= false;// 安装程序退出
             Exit;
            end;
         end else begin
            // 软件没在运行
            Result:= true;
            Exit;
         end;
      end;
  end;
  Result :=true;
end;

// 开始页下一步时判断软件是否运行
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if 1=CurPageID then begin
      Result := CheckSoftRun('{#MyAppExeName}');
      Exit;
  end; 
  Result:= true;
end;

// 卸载时关闭软件
function InitializeUninstall(): Boolean;
begin
  Result := CheckSoftRun('{#MyAppExeName}');
end;


[CustomMessages]
chinesesimplified.checkSoftTip=安装程序检测到将安装的软件正在运行！%n%n点击"确定"终止软件后继续操作，否则点击"取消"。