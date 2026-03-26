# in ghostty_marks.fish replace your function with:
function __ghostty_prompt --on-event fish_prompt
    sleep 0.05
    printf "\e]133;A\a"
end
