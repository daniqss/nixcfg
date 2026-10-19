# bash port of ../nushell/prompt.nu
#
# PS1 itself is static, the dynamic segments live in variables referenced
# from it, so a branch named `$(...)` is never expanded and other hooks that
# wrap PS1 (ghostty shell integration) keep working

__PROMPT_GIT_BIN=${__PROMPT_GIT_BIN:-git}
__PROMPT_GIT_ICON=""
__PROMPT_DURATION_THRESHOLD=8000

# \001 and \002 delimit non printing sequences, unlike \[ \] they also work
# inside the expanded variables
__prompt_sgr() { printf '\001\e[%sm\002' "$1"; }
__PROMPT_RESET=$(__prompt_sgr 0)
__PROMPT_DARK_GRAY=$(__prompt_sgr 90)
__PROMPT_GREEN_BOLD=$(__prompt_sgr '1;32')
__PROMPT_BLUE_BOLD=$(__prompt_sgr '1;34')
__PROMPT_RED=$(__prompt_sgr 31)
__PROMPT_RED_BOLD=$(__prompt_sgr '1;31')
__PROMPT_CYAN_BOLD=$(__prompt_sgr '1;36')
__PROMPT_YELLOW=$(__prompt_sgr 33)
__PROMPT_YELLOW_BOLD=$(__prompt_sgr '1;33')
__PROMPT_SEPARATOR=" ${__PROMPT_DARK_GRAY}|${__PROMPT_RESET} "

__prompt_git_segment() {
  local out
  out=$("$__PROMPT_GIT_BIN" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null) || return

  local branch=HEAD line index worktree
  local -i ahead=0 behind=0 staged=0 modified=0 deleted=0 renamed=0 untracked=0 conflicted=0

  while IFS= read -r line; do
    case $line in
    '# branch.head '*) branch=${line#'# branch.head '} ;;
    '# branch.ab '*)
      read -r _ _ ahead behind <<<"${line//[+-]/}"
      ;;
    '? '*) untracked+=1 ;;
    'u '*) conflicted+=1 ;;
    [12]' '*)
      # columns 2 and 3 hold the staged / unstaged status codes
      index=${line:2:1}
      worktree=${line:3:1}

      case $index in
      R | C) renamed+=1 ;;
      D) deleted+=1 ;;
      .) ;;
      *) staged+=1 ;;
      esac

      case $worktree in
      D) deleted+=1 ;;
      .) ;;
      *) modified+=1 ;;
      esac
      ;;
    esac
  done <<<"$out"

  local tracking=
  if ((ahead > 0 && behind > 0)); then
    tracking="⇕⇡${ahead}⇣${behind}"
  elif ((ahead > 0)); then
    tracking="⇡${ahead}"
  elif ((behind > 0)); then
    tracking="⇣${behind}"
  fi

  local state=
  ((conflicted > 0)) && state+="=${conflicted}"
  ((staged > 0)) && state+="+${staged}"
  ((renamed > 0)) && state+="»${renamed}"
  ((modified > 0)) && state+="!${modified}"
  ((deleted > 0)) && state+="✘${deleted}"
  ((untracked > 0)) && state+="?${untracked}"

  local flags=${tracking}${tracking:+${state:+ }}${state}

  __prompt_segments+="${__PROMPT_SEPARATOR}${__PROMPT_RED_BOLD}${__PROMPT_GIT_ICON} ${branch}${__PROMPT_RESET}"
  [[ -n $flags ]] && __prompt_segments+=" ${__PROMPT_RED}${flags}${__PROMPT_RESET}"
}

__prompt_nix_segment() {
  [[ -n ${IN_NIX_SHELL-} || -n ${NIX_BUILD_TOP-} ]] || return

  # ble.sh may run PROMPT_COMMAND below its own `local name`, peel those off
  # in a subshell until the outermost (global) value is left
  local label
  label=$(
    value=${name-}
    while unset -v name 2>/dev/null && [[ -v name ]]; do
      value=$name
    done
    printf '%s' "$value"
  )
  label=${label%-env}
  if [[ -z $label || $label == nix-shell ]]; then
    label=nix
  else
    label="nix:$label"
  fi

  __prompt_segments+="${__PROMPT_SEPARATOR}${__PROMPT_CYAN_BOLD}λ ${label}${__PROMPT_RESET}"
}

__prompt_indicator_line() {
  local -i code=$1 elapsed=0
  local duration='' status=''

  if [[ -n ${__prompt_start-} ]]; then
    elapsed=$(((${EPOCHREALTIME/[.,]/} - __prompt_start) / 1000))
  fi

  if ((elapsed >= __PROMPT_DURATION_THRESHOLD)); then
    local pretty
    if ((elapsed < 60000)); then
      # one decimal, dropped when it is 0 like nushell does
      local -i tenths=$(((elapsed + 50) / 100))
      pretty="$((tenths / 10))"
      ((tenths % 10)) && pretty+=".$((tenths % 10))"
      pretty+="s"
    else
      local -i secs=$((elapsed / 1000))
      pretty="$((secs / 60))m $((secs % 60))s"
    fi
    duration="${__PROMPT_YELLOW}took ${pretty}${__PROMPT_RESET} "
  fi

  if ((code != 0)); then
    status="${__PROMPT_RED_BOLD}[${code}]${__PROMPT_RESET} "
  fi

  __prompt_indicator="${duration}${status}${__PROMPT_YELLOW_BOLD}\$${__PROMPT_RESET} "
}

__prompt_precmd() {
  local code=$?

  __prompt_segments=
  __prompt_git_segment
  __prompt_nix_segment
  __prompt_indicator_line "$code"

  unset __prompt_start
  return "$code"
}

__prompt_preexec() {
  __prompt_start=${EPOCHREALTIME/[.,]/}
}

if [[ ${BLE_VERSION-} ]]; then
  blehook PREEXEC!=__prompt_preexec
else
  # PS0 is expanded in the current shell right before running a command, the
  # arithmetic expansion stores the start time without printing anything
  # (substring of PS1, as bash skips the arithmetic on empty variables)
  PS0+='${PS1:0:$((__prompt_start = ${EPOCHREALTIME/[.,]/}, 0))}'
fi

# prepend, so the exit code is read before other hooks overwrite it
if [[ ";${PROMPT_COMMAND[*]-};" != *";__prompt_precmd;"* ]]; then
  PROMPT_COMMAND=(__prompt_precmd "${PROMPT_COMMAND[@]}")
fi

PS1="\n${__PROMPT_GREEN_BOLD}\u@\h${__PROMPT_RESET}${__PROMPT_DARK_GRAY}:${__PROMPT_RESET}${__PROMPT_BLUE_BOLD}\w${__PROMPT_RESET}"'${__prompt_segments}'"\n"'${__prompt_indicator}'
PS2="${__PROMPT_DARK_GRAY}::: ${__PROMPT_RESET}"
