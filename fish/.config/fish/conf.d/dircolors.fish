if status is-login
    # Setup LS_COLORS.
    if command -qs dircolors
        eval (dircolors -c ~/.dir_colors)
    end
end
