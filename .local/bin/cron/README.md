# Note

if the cron job sends notifications or need environment variables, call it like this
```
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus; export DISPLAY=:0; . $HOME/.zprofile;  then_command_goes_here
```
