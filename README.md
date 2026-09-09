 Batocera port of the scripts for Elecrow's PiTower Gen 1 Mini PC case for the Raspberry Pi 5.

 https://www.elecrow.com/small-mini-pc-case-with-1-3-oled-screen-for-raspberry-pi-and-jetson-nano.html

 This is a modified version of the original python script controlling the OLED screen and monitoring
 the power button adapted to work with Batocera's services. It also includes an additional info screen
 if you are playing a game.

 Notes: The script that handles sending the shutdown to the case relies on a depreciated
 EmulationStation feature where it used to look for a file to know when to shutdown. The script will 
 look for a file /tmp/shutdown.please . While shutting down via the menu or my script will do this, shutting 
 down via command line will not.

 Installation instructions.

 Press F1 in Batocera to bring up PCmanFM.
 Navigate to where you have the script files saved to.
 At the top, click Tools - Open current folder in Terminal or press F4.
 Mark all the script files as executable with chmod +x {filename)
 
    chmod +x elecrow.py
    chmod +x elecrow_mini_pc
    chmod +x get_game.sh
    chmod +x get_system.sh

Next, move the scripts to their respective directories

    mv elecrow.py /userdata/system/ 
    mv elecrow_mini_pc /userdata/system/services/

The last two will need their locations created first...

    mkdir /userdata/system/configs/emulationstation/scripts/game-start/
    mkdir /userdata/system/scripts
    mv get_game.sh /userdata/system/configs/emulationstation/scripts/game-start/
    mv get_system.sh /userdata/system/scripts

Navigate to /boot and in the terminal, type

    mount o- remount,rw /boot

(folder will revert to write only on reboot)
    
Edit config.txt. add the following line to the bottom...

    dtoverlay=i2c0

CLose out everything, return to the Batocera menu. Pull up the Main menu and navigate to
System settings - Services
turn on "Elecrow_Mini_PC"


 
 
