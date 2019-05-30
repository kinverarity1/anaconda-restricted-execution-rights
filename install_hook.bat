reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
 /t REG_EXPAND_SZ /d "c:\devapps\init.cmd" /f
