# Windows registry path we will probe for default install folder
$regPath = @("Microsoft", "Windows", "CurrentVersion", "App Paths", "Python.exe")  
 
$computername=$PC.NameOfComputer  
 
# Branch of the Registry  
$Branch='LocalMachine'  
 
# Main Sub Branch you need to open  
$SubBranch="SOFTWARE\\"

$SucessMsg="Found Default Value For Python Install Path: "  

function checkForRegPath ($registry, $SubBranch, $regPathArr, $ReturnKey)
{
    $registrykey=$registry.OpenSubKey($Subbranch)  
    $SubKeys=$registrykey.GetSubKeyNames()  
    If ( $SubKeys -contains $regPathArr[0] )
    {  
        $SubBranch=$SubBranch+"\\"+$regPathArr[0]+"\\"
        # WRITE-HOST "Found " $regPathArr[0] " in Windows Registry."
        # This will be executed when the recursive function reached the end of the registry path
        if ( $regPathArr.Length -eq 1) 
                { 
                    
                    $BottomPath=$registry.OpenSubKey($SubBranch)  
                    $ReturnKey=$BottomPath.GetValue("")  
                    return $ReturnKey
                }
        $newRPA=@()
        For ($i=1; $i -lt $regPathArr.Length; $i++) 
        {
            $newRPA+=$regPathArr[$i]
        }
        
        return checkForRegPath $registry $SubBranch $newRPA $ReturnKey
    } else
    {
        WRITE-HOST "ERROR: Can not find " $regPathArr[0] " in Windows Registry."
    }
}

 
$registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$computername)  

$DefaultVal= checkForRegPath $registry $SubBranch $regPath
$DefaultVal= $DefaultVal.subString(0,$DefaultVal.length-11)

WRITE-HOST  $SucessMsg $DefaultVal
$Correct = Read-Host -Prompt 'Is this the correct Python install path? [y,n]'
if ( $Correct -eq "n" )
{
    $DefaultVal = Read-Host -Prompt 'Please enter the correct Python install path'
}
WRITE-HOST "Executing: copy lib\*" $DefaultVal"\DLLS"  
copy lib\* $DefaultVal\DLLS
WRITE-HOST "Executing: copy cuncsd.pyd" $DefaultVal"\DLLS" 
copy cuncsd.pyd $DefaultVal\DLLS
WRITE-HOST "Executing: copy SQ\*" $DefaultVal"\DLLS"  
copy SQ\* $DefaultVal\DLLS
