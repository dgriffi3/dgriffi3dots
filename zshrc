# .zshrc
# Original, Main author: Saleem Abdulrasool <compnerd@compnerd.org>
# Trivial modifications: David Majnemer
# vim:set nowrap:

# Mine:
  # Make sure sources are right - helpful when shell is run as a daemon
  source /etc/profile

# Original:  

autoload compinit; compinit -d "${HOME}/.zsh/.zcompdump"

autoload age
autoload zmv

if [ ${ZSH_VERSION//.} -gt 420 ] ; then
	autoload -U url-quote-magic
	zle -N self-insert url-quote-magic
fi

autoload -U edit-command-line
zle -N edit-command-line

# directory hashes
if [ -d "${HOME}/sandbox" ] ; then
	hash -d sandbox="${HOME}/sandbox"
fi

if [ -d "${HOME}/work" ] ; then
	hash -d work="${HOME}/work"

	for dir in "${HOME}"/work/*(N-/) ; do
		hash -d $(basename "${dir}")="${dir}"
	done
fi

# common shell utils
if [ -d "${HOME}/.commonsh" ] ; then
	for file in "${HOME}"/.commonsh/*(N.x:t) ; do
		. "${HOME}/.commonsh/${file}"
	done
fi

# extras
if [ -d "${HOME}/.zsh" ] ; then
	for file in "${HOME}"/.zsh/*(N.x:t) ; do
		. "${HOME}/.zsh/${file}"
	done
fi
