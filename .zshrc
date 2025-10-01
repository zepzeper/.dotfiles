# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Enable completion system
autoload -U compinit
compinit

# Enable auto-suggestions (requires zsh-autosuggestions)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable syntax highlighting (requires zsh-syntax-highlighting)
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


# Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Check if Oh My Zsh is installed, if not provide installation command
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "Oh My Zsh not found. Install with:"
    echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi

# Zplug setup (plugin manager)
export ZPLUG_HOME="$HOME/.zplug"

# Install zplug if not installed
if [[ ! -d $ZPLUG_HOME ]]; then
    echo "Installing zplug..."
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

# Load zplug
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
    source $ZPLUG_HOME/init.zsh
    
    # Plugins
    zplug "jeffreytse/zsh-vi-mode"
    
    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
    
    # Load plugins
    zplug load
fi

eval "$(starship init zsh)"

export PATH=~/.npm-global/bin:$PATH
