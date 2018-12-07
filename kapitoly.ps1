$folder= (Get-Item -Path ".\").FullName;
$com = (New-Object -ComObject Shell.Application).NameSpace($folder);
$lengthattribute = 27;
for($i = 0; $i -lt 64; $i++) {
	$name = $com.GetDetailsOf($com.Items, $i)
	if ($name -eq 'Length') { $lengthattribute = $i}
}

($kapitoly = $com.Items() |
	Where-Object{-not($_.IsFolder)} |
	ForEach-Object {
		[PSCustomObject]@{
			Name = $_.Name.Substring(0, $_.Name.Length - 4)
			Length = [timespan]$com.GetDetailsOf($_, $lengthattribute)
		}
    }
)

$timestamps = @'
Kapitoly:

'@;

$currentTime = New-TimeSpan;
foreach ($item in $kapitoly) {
    $timestamps = $timestamps + $currentTime.ToString("h\:mm\:ss") + " - " + $item.Name + "`n";
    $currentTime = $currentTime.Add($item.Length);
}

$timestamps > kapitoly.txt

Exit-PSHostProcess