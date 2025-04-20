# Andre Gomes DotFiles

## Description
Personal development environment configurations and dotfiles

## The dotfiles here
1. Zshrc
2. Vimrc
3. Tmux
3. Taskwarrier

```bash
# Link files
sudo ln -s /path/to/repo/file ~/.file
```

## Crontab
```bash
crontab -e
```
MAILTO=""
WORKSPACE="PATH/TO/WORKSPACE"
SCRIPTS="PATH/TO/SCRIPTS"
*/2 * * * * cd $WORKSPACE/project && sh $WORKSPACE/_scripts/,auto-save
