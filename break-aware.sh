#!/usr/bin/env bash

# Get the current Unix timestamp
current_unix_timestamp=$(date "+%s")

# Get the syslog entry from the command line argument
resume_entry="$(grep 'sinceresume resumed' /var/log/syslog | tail -n 1)"
# Extract the timestamp from the syslog entry using awk
resume_ts=$(echo "$resume_entry" | awk '{print $1, $2, $3}')
# Convert the extracted timestamp to a Unix timestamp
syslog_unix_timestamp=$(date -d "$resume_ts" "+%s")
seconds_since_resume=$((current_unix_timestamp - syslog_unix_timestamp))
minutes_since_resume=$((seconds_since_resume / 60))


# get time since session / last unlock
case "$XDG_SESSION_DESKTOP" in
  ubuntu)
    session_entry=$(journalctl -u session-2.scope  | grep "gkr-pam: unlocked login keyring" | tail -n 1)
    ;;
  pantheon)
    session_entry=$(journalctl -u systemd-logind.service | grep "New session" | tail -n 1)
    ;;
  *)
    echo "Unsupported XDG_SESSION_DESKTOP $XDG_SESSION_DESKTOP!"
    exit 1
    ;;
esac
session_ts=$(echo "$session_entry" | awk '{print $1, $2, $3}')
# Convert the extracted timestamp to a Unix timestamp
syslog_unix_timestamp=$(date -d "$session_ts" "+%s")
seconds_since_session=$((current_unix_timestamp - syslog_unix_timestamp))
minutes_since_session=$((seconds_since_session / 60))


if [ "$minutes_since_resume" -lt "$minutes_since_session" ]; then
  st="resume"
  minutes="$minutes_since_resume"
  ts="$resume_ts"
else
  st="session"
  minutes="$minutes_since_session"
  ts="$session_ts"
fi

echo "${minutes}m ($ts - $st)"
