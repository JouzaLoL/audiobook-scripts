function Render {
    param (
        [string]$Image, [string]$Audio, [string]$Folder
    )

    $Folder = $Folder -replace '\s',''

    $renderCommand = "ffmpeg -y -loop 1 -framerate 1 -i ""$($Image)"" $($Audio) -vf ""pad=ceil(iw/2)*2:ceil(ih/2)*2"" -c:v libx264 -preset veryslow -crf 0 -c:a copy -shortest ""$Folder + '\' + ""rendered.mp4""";
    
    Invoke-Expression $renderCommand;
}

# TODO: Ignore folders without mp3s or jpegs

# Where to put rendered files
$renderFolder = "./Rendered";

$renderFolderExists = Get-ChildItem -Directory -Filter $renderFolder;

if(!$renderFolderExists.Exists) {
    New-Item -ItemType Directory -Force -Path $renderFolder;
}

$folders = Get-ChildItem -Recurse -Directory;

foreach ($folder in $folders) {
    if($folder.FullName.Contains("Rendered")) {
        continue;
    }

    # get image
    $Image = Get-ChildItem $folder.FullName -include ('*.jpg', '*.png') -recurse | ForEach-Object { $_.FullName };
    if ($Image.Length -eq 0) {
        continue;
    }

    # get mp3(s)
    # $alreadyConcat = Get-ChildItem -Path $folder.FullName -Recurse -Filter "*MP3WRAP*"
    # if($alreadyConcat.Exists) {
    #     $alreadyConcat.Delete();
    # }

    $mp3s = Get-ChildItem $folder.FullName -include ('*.mp3', '*.m4a') -recurse | Where-Object { $_.Name -match '^out.*mp3' } | ForEach-Object { $_.FullName };
    if ($mp3s.Length -gt 1) {
        $mp3s = $mp3s | Sort-Object;
        $mp3s = $mp3s | ForEach-Object { "-i ""$($_)"" "};
        $mp3s = $mp3s -join "";
    }

    if ($mp3s.Length -eq 0) {
        continue;
    }

    Render $Image $mp3s $folder
    
}
