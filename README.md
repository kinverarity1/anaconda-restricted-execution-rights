# anaconda-restricted-execution-rights

How to install Anaconda/Miniconda when group policy restricts where you run executables or batch files. 

This is intended for a specific audience. If you are not sure whether these instructions apply to you (i.e. you arrived here from Google), then I suggest you do **not** follow them. Follow the official Anaconda/Miniconda/conda documentation instead.

## Step 1

Identify a location where you can run executables and/or batch files. For this example I will call this
location <span style="background-color: lightcyan"><code>c:\devapps</code></span>.

I believe you can use this path with needing to contact the Helpdesk.

## Step 2

Download and unzip the contents of this repository into that location, so that you end up with at least these files:

<pre>
<span style="background-color: lightcyan">c:\devapps\</span>init.cmd
<span style="background-color: lightcyan">c:\devapps\</span>install_hook.bat
</pre>

And these folder paths should also exist (create them if necessary):

<pre>
<span style="background-color: lightcyan">c:\devapps\</span>temp
<span style="background-color: lightcyan">c:\devapps\</span>python
<span style="background-color: lightcyan">c:\devapps\</span>python\setup
</pre>

There will be some other stuff like this README, you can ignore or detail that.

## Step 3

Download the version of Anaconda/Miniconda you wish to install from the [Anaconda archive](https://repo.continuum.io/archive/) or [Miniconda archive](https://repo.continuum.io/miniconda/), and place it in the <code><span style="background-color: lightcyan">c:\devapps</span>\python\setup</code> folder, e.g.:

<pre>
<span style="background-color: lightcyan">c:\devapps\</span>python\setup\<span style="background-color: honeydew">Miniconda3-latest-Windows-x86_64.exe</span>
</pre>

## Step 4

Install Anaconda/Miniconda. To do this open Command Prompt from the start menu and run:

<pre>
start /wait "" <span style="background-color: lightcyan">c:\devapps\</span>python\setup\<span style="background-color: honeydew">Miniconda3-latest-Windows-x86_64.exe</span>
</pre>

You will need to change the default location to which it installs. It defaults to something under ``c:\users``. E.g. for this example we would change it to: 
<span style="background-color: lightcyan"><code>c:\devapps\\</code></span><code>python\\</code><span style="background-color: honeydew"><code>miniconda3</code></span>


![GIF of installer running](python/setup/docs/installer.gif)

## Step 5 (skip if you are using ``c:\devapps``)

Open <code><span style="background-color: lightcyan">c:\devapps\\</span>install_hook.bat</code> in Notepad and edit the contents so that it points to the correct location for you:

<pre>
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
 /t REG_EXPAND_SZ /d "<span style="background-color: lightcyan">c:\devapps\</span>init.cmd" /f
</pre>

## Step 6

Open <code><span style="background-color: lightcyan">c:\devapps\\</span>init.cmd</code> and edit it in the same way to match the paths you are using:

<pre>
@echo "Custom AutoRun is executing this file:"
@echo %0
@SET CUSTOM_PATH=^
<span style="background-color: lightcyan">c:\devapps\</span>python\<span style="background-color: honeydew">miniconda3</span>;^
<span style="background-color: lightcyan">c:\devapps\</span>python\<span style="background-color: honeydew">miniconda3</span>\Library\mingw-w64\bin;^
<span style="background-color: lightcyan">c:\devapps\</span>python\<span style="background-color: honeydew">miniconda3</span>\Library\usr\bin;^
<span style="background-color: lightcyan">c:\devapps\</span>python\<span style="background-color: honeydew">miniconda3</span>\Library\bin;^
<span style="background-color: lightcyan">c:\devapps\</span>python\<span style="background-color: honeydew">miniconda3</span>\Scripts
@SET PATH=%CUSTOM_PATH%;%PATH%
@SET TEMP=<span style="background-color: lightcyan">c:\devapps\</span>temp
</pre>

## Step 8

Run <code><span style="background-color: lightcyan">c:\devapps\\</span>install_hook.bat</code>

## Step 9

Now run Command Prompt from the Start Menu. You should see this output:

<pre>
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.
"Custom AutoRun is executing this file:"
<span style="background-color: lightcyan">c:\devapps\</span>init.cmd

>
</pre>

Every time ``cmd.exe`` is run, your ``init.cmd`` batch file will run, which will ensure the TEMP and PATH environment variables are correctly modified (overriding any system environment variable settings, which you may not be able to change).

If you want to check, you can try running the command ``conda info``. You should get something like this, with the important parts highlighted:

<pre>
C:\Users\kinverarity>conda info

     active environment : None
       user config file : C:\Users\kinverarity\.condarc
 populated config files : C:\Users\kinverarity\.condarc
          conda version : 4.6.14
    conda-build version : not installed
         python version : 3.7.3.final.0
       base environment : <span style="background-color: yellow">c:\devapps\python\miniconda3</span>  (writable)
           channel URLs : https://conda.anaconda.org/kinverarity/win-64
                          https://conda.anaconda.org/kinverarity/noarch
                          https://conda.anaconda.org/conda-forge/win-64
                          https://conda.anaconda.org/conda-forge/noarch
                          https://repo.anaconda.com/pkgs/main/win-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/free/win-64
                          https://repo.anaconda.com/pkgs/free/noarch
                          https://repo.anaconda.com/pkgs/r/win-64
                          https://repo.anaconda.com/pkgs/r/noarch
                          https://repo.anaconda.com/pkgs/msys2/win-64
                          https://repo.anaconda.com/pkgs/msys2/noarch
          package cache : c:\devapps\python\miniconda3\pkgs
                          C:\Users\kinverarity\.conda\pkgs
                          C:\Users\kinverarity\AppData\Local\conda\conda\pkgs
       envs directories : c:\devapps\python\miniconda3\envs
                          C:\Users\kinverarity\.conda\envs
                          C:\Users\kinverarity\AppData\Local\conda\conda\envs
               platform : win-64
             user-agent : conda/4.6.14 requests/2.21.0 CPython/3.7.3 Windows/7 Windows/6.1.7601
          administrator : False
             netrc file : None
           offline mode : False
</pre>

## Step 9

And now things like ``conda activate base`` will work fine.

Everything works the same for Anaconda, including the nifty Anaconda Navigator GUI and all that.
