# Git Large File System

Uses LFS for files in the repository that are larger in size.

## Useage

```terminal
git lfs track <*.extention> or <filename_with_extention>
```

Now `add` and `commit` as normal.

```terminal
git add large_file

git commit -m "Added large file"
```

## SSH Key for Github

Generate the keys by running the following command. Run the command prefferably in an important folder.
My personal choice for the folder is `~/.ssh`.

```terminal
ssh-keygen -o -t rsa -C <email-address-here>;
```

This will start the Key Generation Process. When prompted, press enter to accept the default values.
Open the SSH Folder in a Text Editor. Copy the `public key` and add it to your GitHub account settings.
You are **All Done** now. Try cloning the repository now.
An error might pop up, but it's fine. For the first time that is completely normal.
