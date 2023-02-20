> "E:\workspace\IND_annual\marcXML-10000\processed_files\mods\filelist.txt" (
    for /F "eol=| delims=" %%F in ('
        dir /B /S /A:-D "E:\workspace\IND_annual\marcXML-10000\processed_files\mods\*.*"
    ') do @(
        echo(%%~nxF
    )
)