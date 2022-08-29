wpeinit -unattend:"win10pe-macgrabber.xml"
wpeutil InitializeNetwork /nowait
@for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do @if exist %%a:\LISTGOESHERE set USBDRIVE=%%a
@echo The list is on drive: %USBDRIVE%
WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file maclist.ps1