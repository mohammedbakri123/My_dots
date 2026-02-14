function ll --wraps='lsd -l --group-dirs=first --icon=auto' --description 'alias ll=lsd -l --group-dirs=first --icon=auto'
    lsd -l --group-dirs=first --icon=auto $argv
end
