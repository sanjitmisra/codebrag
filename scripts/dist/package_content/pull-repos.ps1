# This is to suppress error messages that get shown as git outputs to the stdout stream. Not the best way of handling the issue though as useful error messages may also get blanked out.
$ErrorActionPreference = "SilentlyContinue"

# Get the location of the script. Every other path is relative to this.
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Set-Location -Path $scriptPath  

# Loop through all the repos listed in the repolist.txt file
foreach ($repo in Get-Content -Path ".\repos\repolist.txt"){
   
    # Costruct fully named path of the directory housing the repo
    $path = [io.path]::Combine($scriptPath,"repos",$repo)

    # In case it is a new repo, first clone it.
    if ( -not (Test-Path $path)){
        
        # Construct the URL for the repository
        $repo_url = "github url here" + $repo + ".git"

        #Set path to ../repos/
        $pathtillrepodir = [io.path]::Combine($scriptPath,"repos")
        Set-Location -Path $pathtillrepodir

        # Clone the repo
        git clone $repo_url   

	# The codebrag server may need a restart post addition of a new repo.     
       }

    # Move inside the repo directory
    Set-Location -Path $path

    # Pull all committed changes from remote
    git fetch --all

    # Move back to the root directory
    Set-Location -Path $scriptPath  
}