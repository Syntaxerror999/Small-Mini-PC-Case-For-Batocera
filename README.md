 Batocera port of the scripts for Elecrow's PiTower Gen 1 Mini PC case for the Raspberry Pi 5.

 https://www.elecrow.com/small-mini-pc-case-with-1-3-oled-screen-for-raspberry-pi-and-jetson-nano.html

 This is a modified version of the original python script controlling the OLED screen and monitoring
 the power button adapted to work with Batocera's services. It also includes an additional info screen
 if you are playing a game.

 Notes: The script that handles sending the shutdown to the case relies on a depreciated
 EmulationStation feature where it used to look for a file to know when to shutdown. The script will 
 look for a file /tmp/shutdown.please . While shutting down via the menu or my script will do this, shutting 
 down via command line will not.

UPDATE 2.3
- New installation method! Now all the script files are contained in a single file! Just download and run install.sh
  and all the files are created, made executable, and moved to their appropriate directories. If the setting to /boot/config.txt
  is needed, you will need to reboot your system. When future updates come out, install.sh will update the script files.
- De-cluttered the temperature screen. Now just the first stages of the fan and CPU throttling are marked with no letters.
- Screen now goes blank when Batocera's screensaver turns on. This is in sync with OLED screen changes so the change won't be instant.  
   
UPDATE 2.2
- Renamed service script file in case someone else ports the Pi Tower gen 2 script (or someone buys me one to do it)
- names of systems on Now playing screen get parsed into something more human readable
- added a "thermometer" to the temperature screen with markings for the default Raspberry Pi temps for the fans low, med, and high activation as well as for CPU throttle (*)   
- elecrow.py now looks at your batocera.conf file for system_language and adjusts the clock accordingly if its en_US or defalt (not set in config)
- if language is en_US or default, systems like the Mega Drive will be Genesis on the now playing screen
- new more Batocera themed startup screen and screen when no game is being played. (don't worry, I left the shutdown message)

 Installation instructions

 Press F1 in Batocera to bring up PCmanFM.
 Navigate to where you have the install.sh saved to.
 At the top, click Tools - Open current folder in Terminal or press F4.
 Mark the script files as executable with chmod +x {filename)
 
    chmod +x install.sh
    
Next, run install.sh

    ./install.sh

(If "dtoverlay=i2c0" was needed to be added to /boot/config.txt , you will need to reboot.)

Close out everything, return to the Batocera menu. Pull up the Main menu and navigate to
System settings - Services
Check that "pi_tower_gen_1" is turned on
Reboot if needed.

 
 
