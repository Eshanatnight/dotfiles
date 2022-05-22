Write-Output "Starting ssh keygen...";
Write-Output "When prompted, press enter to accept the default values.";
Write-Output "";

# Generate keys
ssh-keygen -o -t rsa -C "email-address-here";

Write-Output "";
Write-Output "Keys generated.";
Write-Output "Open the SSH Folder in a Text Editor."
Write-Output "Copy the public key and add it to your GitHub account.";

Write-Output "";
Write-Output "Try cloning the repository now.";
Write-Output "An error might pop up, but it's fine. For the first time that is completely normal.";
Write-Output "";
