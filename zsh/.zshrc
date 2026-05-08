# Zim 安装时添加的配置开始 {{{
#
# 供交互式 shell 加载的用户配置
#

# -----------------
# Zsh 配置
# -----------------

#
# 历史记录
#

# 如果将要加入重复命令，则删除历史记录中更早的那条。
setopt HIST_IGNORE_ALL_DUPS

#
# 输入/输出
#

# 设置编辑模式默认键位为 emacs（`-e`）或 vi（`-v`）
bindkey -v

# 为命令拼写纠错提供提示。
#setopt CORRECT

# 自定义拼写纠错提示。
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# 从 WORDCHARS 中移除路径分隔符。
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim 配置
# -----------------

# 使用 degit 代替 git，作为安装和更新模块的默认工具。
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# 模块配置
# --------------------

#
# git
#

# 为自动生成的别名设置自定义前缀。默认前缀是 'G'。
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# 当输入以 `..` 开头后，每多输入一个 `.`，自动追加一个 `../`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# 使用提示符扩展转义序列自定义终端标题格式。
# 参见 http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# 如果不设置，则默认使用 '%n@%m: %~'。
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# 禁用每次 precmd 时自动重新绑定 widget。
# 当 zsh-users/zsh-autosuggestions 是 ~/.zimrc 中最后一个模块时可这样设置。
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# 自定义自动建议的显示样式。
# 参见 https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# 设置要启用哪些高亮器。
# 参见 https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# 自定义主高亮器的样式。
# 参见 https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# 初始化模块
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# 如果缺少 zimfw 插件管理器，则自动下载。
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# 如果模块缺失则自动安装；如果 ${ZIM_HOME}/init.zsh 缺失或过期则自动更新。
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# 初始化模块。
source ${ZIM_HOME}/init.zsh

# ------------------------------
# 模块初始化后的配置
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo

# 为普通模式和 vi 命令模式都绑定历史搜索快捷键。
for key ('^[[A' '^P' ${terminfo[kcuu1]}); do
  bindkey ${key} history-substring-search-up
done
for key ('^[[B' '^N' ${terminfo[kcud1]}); do
  bindkey ${key} history-substring-search-down
done
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
unset key
# }}} Zim 安装时添加的配置结束

# -------------------
# 个人覆盖配置
# -------------------

# 为交互式 shell 加载个人别名和环境设置。
[[ -r ${HOME}/.mbprc ]] && source ${HOME}/.mbprc
