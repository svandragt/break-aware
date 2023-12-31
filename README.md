# BreakAware

BreakAware is a lightweight and user-friendly Bash script designed to help you maintain a healthy work-life balance. It tracks the time since your last break, whether it's due to PC sleep, hibernation, logout, or session locking. BreakAware empowers you to be more aware of how you spend your time and encourages you to take regular breaks, enhancing your productivity and well-being.

An older version of the script is also provided for Fish users.

```
$ ./break-aware.sh 
18m (Dec 13 09:31:50 - session)
```

## Features:

 - Automatically tracks time since the last break.
 - Uses System-D data generated by the system to calculate the time since your last break.
 - Supports elementaryOS (specifically Pantheon) and Ubuntu systems, other system-d enabled OS patches welcome.

## Getting Started:

Download and run BreakAware and it will add a trigger to log a message to the syslog when you resume from a break. Then simply run the script again whenever you want to know how long it's been. I add it to the start of a terminal session.

## Contribution:

Contributions to enhance BreakAware are welcomed. Feel free to fork this project, make improvements, and submit pull requests.

## License:

This project is licensed under the GPL3 License.

## Disclaimer:

BreakAware is intended to promote healthy work habits, but it is ultimately your responsibility to manage your breaks and well-being. Please use it wisely and take breaks as needed for your health and productivity.

## Credits:

Thanks to [Pandan (macOS)](https://sindresorhus.com/pandan) for the inspiration, which is a GUI notification area alternative for Mac.
