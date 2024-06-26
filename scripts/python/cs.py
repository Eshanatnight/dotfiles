#! /usr/bin/env python3
"""
print the content of rem.txt, cheatsheet to stdout
"""


def main():
    """
    entry point for the program
    """

    rem_text = """
    Keymaps
        le -> go to end of the line
        ls -> go to start of the line
        <leader>gb -> git blame
        <leader>td -> get the deleted lines in the current file
        <leader>cc -> jump to current context
        <leader>wK -> open witch key help
        <leader>l -> lint file
        <leader>ff -> Find files
        <leader>fa -> Find all
        <leader>fw -> Live grep
        <leader>fb -> Find buffers
        <leader>fh -> Help page
        <leader>fo -> Find oldfiles
        <leader>fz -> Find in current buffer

        <leader>cm -> Git commits
        <leader>gt -> Git status
        <leader>th -> Nvchad themes

        gd -> Go to definition
        K -> hover documentation
        gi -> Go to implementation
        <leader>ra -> Rename symbol
        <leader>ca -> Code action
        <leader>/ -> comment toggle

    For Folding

        <leader>za -> Toggle fold under cursor
        <leader>zc -> Toggle close fold under cursor
        <leader>zC -> Toggle close on all folds under cursor
        <leader>zM -> Toggle close all folds 
        <leader>zo -> Toggle open fold under cursor
        <leader>zO -> Toggle open on all folds under cursor
        <leader>zR -> Toggle open on all folds

    """

    print(rem_text)


if __name__ == "__main__":
    main()
