#define ApplicationName "Pup Killer"
#define ApplicationId "PUPKiller"
#define ApplicationMainExeFileName "pup_killer.exe"

[Setup]
AppName={#ApplicationName}
AppId={#ApplicationId}
AppVerName={#ApplicationName}
DefaultDirName={pf}\{#ApplicationName}
DefaultGroupName={#ApplicationName}
AppPublisher=VioletGiraffe
AllowNoIcons=true
OutputDir=.
OutputBaseFilename={#ApplicationId}
UsePreviousAppDir=yes

UninstallDisplayIcon={app}\{#ApplicationMainExeFileName}

SolidCompression=true
LZMANumBlockThreads=4
Compression=lzma2/ultra64
LZMAUseSeparateProcess=yes
LZMABlockSize=8192

[Files]

;App binaries
Source: binaries/32/*; DestDir: {app}; Flags: ignoreversion;

;Qt binaries
Source: binaries/32/Qt/*; DestDir: {app}; Flags: ignoreversion recursesubdirs skipifsourcedoesntexist;

;MSVC binaries
Source: binaries/32/msvcr/*; DestDir: {app}; Flags: ignoreversion;

[Tasks]
Name: startup; Description: "Automatically run this program when Windows starts"; GroupDescription: "{cm:AdditionalIcons}";

[Icons]
Name: {group}\{#ApplicationName}; Filename: {app}\{#ApplicationMainExeFileName};
Name: {group}\{cm:UninstallProgram,{#ApplicationName}}; Filename: {uninstallexe}
Name: {userstartup}\{#ApplicationName}; Filename: {app}\{#ApplicationMainExeFileName}; Tasks: startup

[Run]
Filename: {app}\{#ApplicationMainExeFileName}; Description: {cm:LaunchProgram,{#ApplicationName}}; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: dirifempty; Name: "{app}"