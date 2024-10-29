# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ -n $(command -v brew) ]; then
	    PREFIX="${HOME}/.local"
	        export HOMEBREW_PREFIX="$PREFIX"
		    export HOMEBREW_CELLAR="$PREFIX/Cellar"
		        export HOMEBREW_REPOSITORY="$PREFIX/Homebrew"
			    export HOMEBREW_CASK_OPTS='${HOME}/Applications'
			        export PATH="$PREFIX/bin:$PREFIX/sbin${PATH+:$PATH}"
				    export MANPATH="$PREFIX/share/man${MANPATH+:$MANPATH}:"
				        export INFOPATH="$PREFIX/share/info:${INFOPATH:-}"
					    # export HOMEBREW_NO_ANALYTICS=1
					    #     # export HOMEBREW_NO_ENV_HINTS=1
fi









export PATH="$PATH:/opt/nvim/"
past() {
  local alias_name=$1
  local current_dir=$(pwd)
  local alias_command="alias $alias_name='cd \"$current_dir\"'"
  eval $alias_command
  echo $alias_command >> ~/.zshrc
}
compdef past=cd
setopt complete_aliases

# Make sure to export the function so it's available in your shell

export PATH="$PATH:/usr/bin/clang"


alias code='gtk-launch com.visualstudio.code.desktop 2>/dev/null'
alias pasta='nautilus .'

alias test='cd "/home/jperpect/Desktop/test"'
alias files='cd "/home/jperpect/Desktop/42_porto_student/piscine_feles"'


alias script='cd "/home/jperpect/Desktop/scripts"'
alias mini='cd "/home/jperpect/Desktop/progect_finich/miniTalk"'
alias push='cd "/home/jperpect/Desktop/push_swap"'

alias gi='cd "/home/jperpect/Desktop/github"'
alias av='cd "/home/jperpect/Desktop/avalia"'
alias phi='cd "/home/jperpect/Desktop/philo"'
alias cf='cd "/home/jperpect/.config"'
alias ex='exit' 


