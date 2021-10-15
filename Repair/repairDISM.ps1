<#
    \\ Uses the DISM  to check faults in the Windows Update
#>

DISM.exe /Online /Cleanup-image /Restorehealth;

if($?)
{
    # sfc to can and download the corrected image
    sfc /scannow
};