function clear --description "Clear screen and scrollback"
	printf '\e[3J'
	command clear $argv
end
