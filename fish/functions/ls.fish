function ls --wraps='lsd --group-dirs=first --icon=auto --blocks=size,date,name' --description 'alias ls=lsd --group-dirs=first --icon=auto --blocks=size,date,name'
    lsd --group-dirs=first --icon=auto --blocks=size,date,name $argv
end
