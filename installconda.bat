
:: Choose either Anaconda3 (large download, all major conda packages pre-installed)
:: or alter to Miniconda3 (very small, need to install conda packages/environments yourself)

set CONDA_VERSION=Miniconda3

@echo DEW %CONDA_VERSION% install shim - v1.0 - 18/06/2020 - Kent.Inverarity@sa.gov.au

if exist c:\devapps\%USERNAME%\python\Anaconda3 del /s /f /q c:\devapps\%USERNAME%\python\Anaconda3 >nul 2>&1
if exist c:\devapps\%USERNAME%\python\Miniconda3 del /s /f /q c:\devapps\%USERNAME%\python\Miniconda3 >nul 2>&1

if not exist c:\devapps\%USERNAME% mkdir c:\devapps\%USERNAME% >nul 2>&1
if not exist c:\devapps\%USERNAME%\python mkdir c:\devapps\%USERNAME%\python >nul 2>&1
if not exist c:\devapps\%USERNAME%\python\setup mkdir c:\devapps\%USERNAME%\python\setup >nul 2>&1
if not exist c:\devapps\%USERNAME%\apps mkdir c:\devapps\%USERNAME%\apps >nul 2>&1
if not exist c:\devapps\%USERNAME%\temp mkdir c:\devapps\%USERNAME%\temp >nul 2>&1

:: Create init.cmd

@echo Creating initialization batch file at c:\devapps\%USERNAME%\init.cmd... This will be run every time you run Command Prompt (cmd.exe).
@echo @ECHO "Custom AutoRun is executing this file:" > c:\devapps\%USERNAME%\init.cmd
@echo @ECHO %%0 >> c:\devapps\%USERNAME%\init.cmd
@echo @SET CUSTOM_PATH=c:\devapps\%USERNAME%\python\%CONDA_VERSION%;c:\devapps\%USERNAME%\python\%CONDA_VERSION%\Scripts;c:\devapps\%USERNAME%\python\%CONDA_VERSION%\Library\mingw-w64\bin;c:\devapps\%USERNAME%\python\%CONDA_VERSION%\Library\usr\bin;c:\devapps\%USERNAME%\python\%CONDA_VERSION%\Library\bin >> c:\devapps\%USERNAME%\init.cmd
@echo @SET PATH=%%CUSTOM_PATH%%;%%PATH%%  >> c:\devapps\%USERNAME%\init.cmd
@echo @SET TEMP=c:\devapps\%USERNAME%\temp  >> c:\devapps\%USERNAME%\init.cmd

:: Download Anaconda3/Miniconda3 installer

if not exist "c:\devapps\%USERNAME%\python\setup\conda-installer-Windows-x86_64.exe" (
  @echo Downloading %CONDA_VERSION% installer...
  @echo Number of bytes downloaded:
  bitsadmin /cancel PythonSetupInstaller >nul 2>&1
  bitsadmin /create PythonSetupInstaller >nul 2>&1
  if %CONDA_VERSION%==Miniconda3 bitsadmin /addfile PythonSetupInstaller https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe c:\devapps\%USERNAME%\python\setup\conda-installer-Windows-x86_64.exe >nul 2>&1
  if %CONDA_VERSION%==Anaconda3 bitsadmin /addfile PythonSetupInstaller https://repo.anaconda.com/archive/Anaconda3-2020.02-Windows-x86_64.exe c:\devapps\%USERNAME%\python\setup\conda-installer-Windows-x86_64.exe >nul 2>&1
  bitsadmin /SetPriority PythonSetupInstaller "FOREGROUND" >nul 2>&1
  bitsadmin /resume PythonSetupInstaller >nul 2>&1
  :WAIT_CONDA_DATA_DOWNLOAD_LOOP_START
    :: state thanks to http://ss64.com/nt/bitsadmin.html & http://serverfault.com/a/646948/93281
    bitsadmin /info PythonSetupInstaller /verbose | find "STATE: TRANSFERRED" 
    if %ERRORLEVEL% equ 0 goto WAIT_CONDA_DATA_DOWNLOAD_LOOP_END
    @echo ...
    bitsadmin /RawReturn /GetBytesTransferred PythonSetupInstaller 
    :: sleep thanks to http://stackoverflow.com/a/1672375/535203
    timeout 5  >nul 2>&1
    @goto WAIT_CONDA_DATA_DOWNLOAD_LOOP_START
  :WAIT_CONDA_DATA_DOWNLOAD_LOOP_END
  bitsadmin /complete PythonSetupInstaller >nul 2>&1
)

:: Install Anaconda3/Miniconda3

@echo Installing %CONDA_VERSION% into c:\devapps\%USERNAME%\python\%CONDA_VERSION%...
start /wait "" c:\devapps\%USERNAME%\python\setup\conda-installer-Windows-x86_64.exe /S /D=c:\devapps\%USERNAME%\python\%CONDA_VERSION%

:: Install registry hook to modify paths for a new shell.
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "c:\devapps\%USERNAME%\init.cmd" /f >nul 2>&1

:: Ensure that the base conda environment is activated every time you run cmd.exe
@echo Ensure that the base conda environment is activated every time you run cmd.exe...
@echo @c:\devapps\%USERNAME%\python\%CONDA_VERSION%\scripts\activate base >> c:\devapps\%USERNAME%\init.cmd

:: Install 64-bit Oracle Client

if not exist "c:\devapps\%USERNAME%\apps\instantclientx64.zip" (
  @echo Downloading 64 bit Oracle Client...
  @echo Number of bytes downloaded:
  bitsadmin /cancel OracleClientInstaller 
  bitsadmin /create OracleClientInstaller 
  bitsadmin /addfile OracleClientInstaller "https://download.oracle.com/otn_software/nt/instantclient/19300/instantclient-basiclite-windows.x64-19.3.0.0.0dbru.zip" c:\devapps\%USERNAME%\apps\instantclientx64.zip 
  bitsadmin /SetPriority OracleClientInstaller "FOREGROUND" 
  bitsadmin /resume OracleClientInstaller 
  :WAIT_ORACLE_DATA_DOWNLOAD_LOOP_START
    :: state thanks to http://ss64.com/nt/bitsadmin.html & http://serverfault.com/a/646948/93281
    bitsadmin /info OracleClientInstaller /verbose | find "STATE: TRANSFERRED" 
    if %ERRORLEVEL% equ 0 goto WAIT_ORACLE_DATA_DOWNLOAD_LOOP_END
    @echo ...
    bitsadmin /RawReturn /GetBytesTransferred OracleClientInstaller
    :: sleep thanks to http://stackoverflow.com/a/1672375/535203
    timeout 5  
    goto WAIT_ORACLE_DATA_DOWNLOAD_LOOP_START
  :WAIT_ORACLE_DATA_DOWNLOAD_LOOP_END
  bitsadmin /complete OracleClientInstaller >nul 2>&1
)

@echo Unzipping 64 bit Oracle Instant Client installer...
if exist c:\devapps\%USERNAME%\apps\oracle_instantclientx64 del /s /f /q c:\devapps\%USERNAME%\apps\oracle_instantclientx64\* >nul 2>&1
@powershell Expand-Archive c:\devapps\%USERNAME%\apps\instantclientx64.zip -DestinationPath c:\devapps\%USERNAME%\apps\oracle_instantclientx64 >nul 2>&1

@echo Adding Oracle to your PATH
setx PATH %PATH%;c:\devapps\%USERNAME%\apps\oracle_instantclientx64\instantclient_19_3 >nul 2>&1

:: Create conda_setup_tweaks.bat
@echo Creating initialization batch file at c:\devapps\%USERNAME%\conda_setup_tweaks.bat... This will be run only once.
@echo @call conda config --add channels conda-forge > c:\devapps\%USERNAME%\conda_setup_tweaks.bat
@echo @call conda config --set channel_priority strict >> c:\devapps\%USERNAME%\conda_setup_tweaks.bat
@echo @call python -m pip config --global set global.extra-index-url http://envtelem04:8090/simple/ >> c:\devapps\%USERNAME%\conda_setup_tweaks.bat
@echo @call python -m pip config --global set global.trusted-host envtelem04 >> c:\devapps\%USERNAME%\conda_setup_tweaks.bat
@echo @call conda install -y jupyter ipykernel black geopandas sqlparse click cx_Oracle pillow numpy sqlalchemy pandas matplotlib >> c:\devapps\%USERNAME%\conda_setup_tweaks.bat

:: Run the conda setup tweaks batch file.
c:\devapps\%USERNAME%\conda_setup_tweaks.bat 

:: Start it up!
start cmd /k "@echo Welcome to your new installation of %CONDA_VERSION% and Oracle Instant Client! Have fun :-)"

