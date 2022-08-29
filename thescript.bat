set pathtodism=
set pathtopowershellpackages=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs
::Relaunch with admin permissions if not already there
setlocal enabledelayedexpansion

set CmdDir=%~dp0
set CmdDir=%CmdDir:~0,-1%

:: Check for Mandatory Label\High Mandatory Level
whoami /groups | find "S-1-16-12288" > nul
if "%errorlevel%"=="0" (
    echo Running as elevated user.  Continuing script.
) else (
    echo Not running as elevated user.
    echo Relaunching Elevated: "%~dpnx0" %*

    if exist "%CmdDir%\elevate.cmd" (
        set ELEVATE_COMMAND="%CmdDir%\elevate.cmd"
    ) else (
        set ELEVATE_COMMAND=elevate.cmd
    )

    set CARET=^^
    !ELEVATE_COMMAND! cmd /c cd /d "%~dp0" !CARET!^& call "%~dpnx0" %*
    goto :EOF
) 
::end of relaunch with admin permissions block

set PATH=%pathtodism%;%PATH%

copy /y %1 %~dpn1-modified%~x1
mkdir mntpnt
dism /mount-wim "/wimfile:%~dpn1-modified%~x1" /index:1 /mountdir:mntpnt

rem add Powershell
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-WMI.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-WMI_en-us.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-NetFX.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-NetFX_en-us.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-Scripting.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-Scripting_en-us.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-PowerShell_en-us.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-StorageWMI_en-us.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"mntpnt" /PackagePath:"%pathtopowershellpackages%\en-us\WinPE-DismCmdlets_en-us.cab"

rem change files
del /f mntpnt\Windows\System32\winpeshl.ini
copy /y win10pe-macgrabber.xml mntpnt\Windows\System32\
copy /y startnet.cmd mntpnt\Windows\System32\
copy /y maclist.ps1 mntpnt\Windows\System32\
dism /unmount-wim /mountdir:mntpnt /commit
rd /s /q mntpnt
