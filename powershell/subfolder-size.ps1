#Get-ChildItem $directory | select -Expand Name | $PSScriptRoot

# Get the current directory
$currentFolder = Get-Location

# Get all subfolders in the current directory
$subfolders = Get-ChildItem -Directory -Path $currentFolder

# Iterate through each subfolder and calculate its size
$results = foreach ($subfolder in $subfolders) {
    $size = (Get-ChildItem -Path $subfolder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{
        Subfolder = $subfolder.Name
        SizeGB    = [math]::Round($size / 1GB, 2)
    }
}

# Display the results
$results | Sort-Object SizeGB -Descending | Format-Table -AutoSize