@echo "Custom AutoRun is executing this file:"
@echo %0
@SET CUSTOM_PATH=^
c:\devapps\python\miniconda3;^
c:\devapps\python\miniconda3\Library\mingw-w64\bin;^
c:\devapps\python\miniconda3\Library\usr\bin;^
c:\devapps\python\miniconda3\Library\bin;^
c:\devapps\python\miniconda3\Scripts
@SET PATH=%CUSTOM_PATH%;%PATH%
@SET TMPDIR=c:\devapps\temp
