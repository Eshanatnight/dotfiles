<#
    * How this should work
    * gcr "https://github.com/xxxx/xxxxx.git"
    * this should expand to something that looks like this
    * git clone --recursive "https://github.com/xxxx/xxxx.git"
    *
    * gcr "https://github.com/xxxx/xxxxx.git folder_name"
    * this should expand to something that looks like this
    * git clone --recursive "https://github.com/xxxx/xxxx.git folder_name"
#>

# Declare the global variables cause convinience
$error_msg_one = "Invalid useage `n`Useage: gcr <git_repository_url>"
$error_msg_two = "Invalid useage `n`Useage: gcr <git_repository_url> <dirName>"
$argsLen = $args.Count;


# if no args are provided
if ($argsLen -eq 0)
{
    Write-Error $error_msg_one;
    exit;
}

$repository;

# if only the url is provided, check if it is an url or not
# and deal with the consequences
if($argsLen -eq 1)
{
    $repository = $args[0];
    try
    {
        if($repository.substring($repository.length - 4) -ceq ".git")
        {
            $repository;
            Start-Process git -ArgumentList "clone --recursive ${repository}" -NoNewWindow -Wait;
        }

        else
        {
            Write-Error $error_msg_one;
            exit
        }
    }

    catch
    {
        Write-Error $error_msg_one;
    }
}

$dirName;

# if two args are provided, i.e. url and dir name
# then deal with the consequences
if ($argsLen -eq 2)
{
    $repository = $args[0];

    try
    {
        # check if the args are in the correct order
        # gcr url dir_name
        if($repository.substring($repository.length -4) -ceq ".git")
        {
            $dirName = $args[1];
            Start-Process git -ArgumentList "clone --recursive ${repository} ${dirName}" -NoNewWindow -Wait;
        }

        else
        {
            Write-Error $error_msg_two;
            exit
        }
    }

    catch
    {
        Write-Error $error_msg_two;
        exit;
    }


}




#Start-Process git -ArgumentList "clone --recursive ${repository}" -NoNewWindow -Wait
