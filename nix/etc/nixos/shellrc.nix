{ config, lib, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [
		zsh-autocomplete
		zsh-autosuggestions
		zsh-syntax-highlighting
		];

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		setOptions = [
			"NO_BEEP"
				# BEEP (+B) <D>
					# Beep on error in ZLE.
				# APPEND_HISTORY <D>
					# If this is set, zsh sessions will append their history list to the history file, rather than replace it.  Thus,  multiple  parallel  zsh
					# sessions  will  all have the new entries from their history lists added to the history file, in the order that they exit.  The file will
					# still be periodically re-written to trim it when the number of lines grows 20% beyond the value specified by  $SAVEHIST  (see  also  the
					# HIST_SAVE_BY_COPY option).
				# EXTENDED_HISTORY <C>
					# Save  each  command's beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.  The format of
					# this prefixed data is:
					# 
					# `: <beginning time>:<elapsed seconds>;<command>'.
			"HIST_EXPIRE_DUPS_FIRST"
				# HIST_EXPIRE_DUPS_FIRST
					# If the internal history needs to be trimmed to add the current command line, setting this option will cause  the  oldest  history  event
					# that has a duplicate to be lost before losing a unique event from the list.  You should be sure to set the value of HISTSIZE to a larger
					# number  than  SAVEHIST  in  order  to give you some room for the duplicated events, otherwise this option will behave just like HIST_IG‐
					# NORE_ALL_DUPS once the history fills up with unique events.
				# HIST_FIND_NO_DUPS
					# When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates  are
					# not contiguous.
			"HIST_IGNORE_ALL_DUPS"
				# HIST_IGNORE_ALL_DUPS
					# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is
					# not the previous event).
				# HIST_IGNORE_DUPS (-h)
					# Do not enter command lines into the history list if they are duplicates of the previous event.
				# HIST_SAVE_NO_DUPS
					# When writing out the history file, older commands that duplicate newer ones are omitted.
				# HIST_VERIFY
					# Whenever  the  user enters a line with history expansion, don't execute the line directly; instead, perform history expansion and reload
					# the line into the editing buffer.
				# INC_APPEND_HISTORY
					# This option works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally (as soon as  they  are  en‐
					# tered),  rather  than waiting until the shell exits.  The file will still be periodically re-written to trim it when the number of lines
					# grows 20% beyond the value specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
				# INC_APPEND_HISTORY_TIME
					# This option is a variant of INC_APPEND_HISTORY in which, where possible, the history entry is written out to the file after the  command
					# is  finished,  so  that  the time taken by the command is recorded correctly in the history file in EXTENDED_HISTORY format.  This means
					# that the history entry will not be available immediately from other instances of the shell that are using the same history file.
					# 
					# This option is only useful if INC_APPEND_HISTORY and SHARE_HISTORY are turned off.  The three options should be considered mutually  ex‐
					# clusive.
			"SHARE_HISTORY"
				# SHARE_HISTORY <K>
					# This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file (the
					# latter  is like specifying INC_APPEND_HISTORY, which should be turned off if this option is in effect).  The history lines are also out‐
					# put with timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where we left  off  reading  the  file  after  it  gets
					# re-written).
					# 
					# By  default,  history movement commands visit the imported lines as well as the local lines, but you can toggle this on and off with the
					# set-local-history zle binding.  It is also possible to create a zle widget that will make some commands ignore  imported  commands,  and
					# some include them.
					# 
					# If  you  find  that you want more control over when commands get imported, you may wish to turn SHARE_HISTORY off, INC_APPEND_HISTORY or
					# INC_APPEND_HISTORY_TIME (see above) on, and then manually import commands whenever you need them using `fc -RI'.

		];
	};

	users.defaultUserShell = pkgs.zsh;

}
