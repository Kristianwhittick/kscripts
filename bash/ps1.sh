PS1='\D{%Y-%m-%d} \t\n\u \h \n[$?] \s > \w\$ <$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)> \\$'



PS1='iac-server > \[\e[92m\]\w\[\e[0m\] \\$ '