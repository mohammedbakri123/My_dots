function code
    if test (count $argv) -eq 0
        setsid /opt/vsc/bin/code . >/dev/null 2>&1 &
    else
        setsid /opt/vsc/bin/code $argv >/dev/null 2>&1 &
    end
end

