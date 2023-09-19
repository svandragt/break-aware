#!/usr/bin/env fish

# Make sure trigger exists
set logger_file "/usr/lib/systemd/system-sleep/break-resume"
if not test -e $logger_file
    set contents "#!/bin/sh

case \$1 in
  post)
    logger 'break-resume triggered.'
    ;;
esac
"
  echo $contents | sudo tee $logger_file; and sudo chmod +x $logger_file
end


set display_threshold (count $argv > 0; and math "$argv[1]"; or echo 20)

set current_unix_timestamp (date "+%s")

# Get time since last sleep / suspend / hibernate
set resume_entry (grep 'break-resume triggered' /var/log/syslog | tail -n 1)
set resume_date (echo "$resume_entry" | awk '{print $1, $2, $3}')
set resume_ts (date -d "$resume_date" "+%s")
set minutes_since_resume (math "($current_unix_timestamp - $resume_ts) / 60")

# Get time since session / last unlock
switch "$XDG_SESSION_DESKTOP"
  case ubuntu
    set session_entry (journalctl -u session-2.scope  | grep "gkr-pam: unlocked login keyring" | tail -n 1)
  case pantheon
    set session_entry (journalctl -u systemd-logind.service | grep "New session" | tail -n 1)
  case '*'
    echo "Unsupported XDG_SESSION_DESKTOP $XDG_SESSION_DESKTOP!"
    exit 1
end
set session_date (echo "$session_entry" | awk '{print $1, $2, $3}')
set session_ts (date -d "$session_date" "+%s")
set minutes_since_session (math "($current_unix_timestamp - $session_ts) / 60")

set minutes (math floor (math min $minutes_since_session,$minutes_since_resume ))

set break_type "resume"
if test $minutes_since_session -lt $minutes_since_resume
  set break_type "session"
end

if test $minutes -gt $display_threshold
  echo "$minutes""m since $break_type."
end
