if not status is-interactive
    exit
end

if command -q keychain
    keychain --eval --quiet -Q | source
end
