> "%~dp0\filelist.txt" (
    for /F "eol=| delims=" %%F in ('
        dir /B /S /A:-D "%~dp0\*.*"
    ') do @(
        echo(%%~nxF
    )
)