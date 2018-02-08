$ErrorActionPreference = "SilentlyContinue"

# Get the location of the script. Every other path is relative to this.
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Set-Location -Path $scriptPath  

foreach ($repo in Get-Content -Path ".\repos\repolist.txt"){
    echo "In repo - " + $repo
   
    # Costruct fully named path of the directory housing the repo
    $path = [io.path]::Combine($scriptPath,"repos",$repo)

    # In case it is a new repo, clone it
    if ( -not (Test-Path $path)){
        
        # Construct the URL for the repository
        $repo_url = "github url here" + $repo + ".git"

        #Set path to ../repos/
        $pathtillrepodir = [io.path]::Combine($scriptPath,"repos")
        Set-Location -Path $pathtillrepodir

        # Clone the repo
        git clone $repo_url
       
       }

    # Move inside the repo directory
    Set-Location -Path $path

    # Pull all committed changes from remote
    git fetch --all

    # Move back to the root directory
    Set-Location -Path $scriptPath  
}