# ==============================================================================
#                      ZSH CONFIGURATION (.zshrc)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. 语言与基础环境变量
# ------------------------------------------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ------------------------------------------------------------------------------
# 2. 生产级历史记录策略 (安全与多会话即时共享)
# ------------------------------------------------------------------------------
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # 写入命令时间戳与执行耗时
setopt INC_APPEND_HISTORY        # 命令执行后立即落盘追加，防崩溃丢记录
setopt SHARE_HISTORY             # 跨终端多 session 实时共享历史
setopt HIST_IGNORE_ALL_DUPS      # 出现重复命令时删除旧记录
setopt HIST_IGNORE_SPACE         # 前缀带空格的命令不记入历史 (防止敏感 Token 泄露)
setopt HIST_SAVE_NO_DUPS         # 不向历史文件写入重复命令
setopt HIST_REDUCE_BLANKS        # 自动移除多余空格

# ------------------------------------------------------------------------------
# 3. 命令行交互与输入行为
# ------------------------------------------------------------------------------
bindkey -e                       # 采用标准的 Emacs 键位模式
setopt AUTO_CD                   # 直接输入目录名即可自动 cd
WORDCHARS=${WORDCHARS//[\/]}     # 路径分隔符视为词边界 (Ctrl-W 按路径分段删除)

# ------------------------------------------------------------------------------
# 4. Zimfw 模块预配置 (Pre-initialization)
# ------------------------------------------------------------------------------
# Git 模块别名前缀 ('g' -> 'gst', 'gco' 等)
zstyle ':zim:git' aliases-prefix 'g'

# 快速上级目录扩展 ('...' 自动扩展为 '../../')
zstyle ':zim:input' double-dot-expand yes

# 终端窗口标题格式 (显示当前一级目录)
zstyle ':zim:termtitle' format '%1~'

# zsh-autosuggestions 性能与样式调优
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# zsh-syntax-highlighting 启用主高亮器与括号匹配
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ------------------------------------------------------------------------------
# 5. Zimfw 框架初始化
# ------------------------------------------------------------------------------
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# 缺失自动下载 zimfw 插件管理器
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# 自动安装缺失模块；.zimrc 更新时静默重新编译 init.zsh
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# 加载 Zim 编译后的 init 脚本
source ${ZIM_HOME}/init.zsh

# ------------------------------------------------------------------------------
# 6. 模块初始化后键位绑定 (Post-init Keybindings)
# ------------------------------------------------------------------------------
# 历史子串模糊匹配 (Up / Down Arrow, Ctrl-P / Ctrl-N)
if (( ${+widgets[history-substring-search-up]} )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

# 自动建议补全 (Ctrl+Space 一键采纳建议)
if (( ${+widgets[autosuggest-accept]} )); then
  bindkey '^ ' autosuggest-accept
fi

# ------------------------------------------------------------------------------
# 7. 终端增强与第三方集成
# ------------------------------------------------------------------------------
# iTerm2 Shell 集成
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ------------------------------------------------------------------------------
# 8. 加载个人环境与通用别名
# ------------------------------------------------------------------------------
[[ -r ${HOME}/.mbprc ]] && source ${HOME}/.mbprc

