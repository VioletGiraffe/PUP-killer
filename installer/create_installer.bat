REM this script must set QTDIR32 and QTDIR64 paths to the root of corresponding Qt builds. Example:
REM set QTDIR32=k:\Qt\5\5.4\msvc2013_opengl\
REM set QTDIR64=k:\Qt\5\5.4\msvc2013_64_opengl\

call set_qt_paths.bat
set VS_TOOLS_DIR=%VS140COMNTOOLS%

SETLOCAL

RMDIR /S /Q binaries\

call "%VS_TOOLS_DIR%..\..\VC\vcvarsall.bat" x86

REM X86
pushd ..\
"%QTDIR32%\bin\qmake.exe" -tp vc -r

msbuild /t:Build /p:Configuration=Release;PlatformToolset=v140
popd

xcopy /R /Y ..\bin\release\x86\*.exe binaries\32\
xcopy /R /Y ..\bin\release\x86\*.dll binaries\32\

SETLOCAL
SET PATH=%QTDIR32%\bin\
FOR %%p IN (%~dp0\..\bin\release\x86\*.dll) DO %QTDIR32%\bin\windeployqt.exe --dir binaries\32\Qt --force --no-translations --no-compiler-runtime --release --no-angle %%p
FOR %%p IN (%~dp0\..\bin\release\x86\*.exe) DO %QTDIR32%\bin\windeployqt.exe --dir binaries\32\Qt --force --no-translations --no-compiler-runtime --release --no-angle %%p
ENDLOCAL

xcopy /R /Y %SystemRoot%\SysWOW64\msvcp140.dll binaries\32\msvcr\
xcopy /R /Y %SystemRoot%\SysWOW64\vcruntime140.dll binaries\32\msvcr\
xcopy /R /Y "%programfiles(x86)%\Windows Kits\10\Redist\ucrt\DLLs\x86\*" binaries\32\msvcr\

del binaries\32\Qt\opengl*.*

ENDLOCAL

"c:\Program Files (x86)\Inno Setup 5\compil32" /cc setup.iss