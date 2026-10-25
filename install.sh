#!/bin/bash

new_version=2.3
echo " "
echo " "
echo "Elecrow Piower Gen 1 Install/Update version $new_version"


####### This is the stored scripts, not code for this script!


### get_game.sh

IFS='' read -r -d '' file_a << "EOF"
#!/bin/bash
#VERSION=

# Gets game's name and sends to the scratch pad
game="${3}" #EmulationStation arg to get current game's name

#Write game name to the scratch pad
sed -i "s|^\(NAME[[:blank:]]*=[[:blank:]]*\).*|\1${game//&/\\&}|" /tmp/elecrow.scratch
EOF


### send_start.sh

IFS='' read -r -d '' file_b << "EOF"
#!/bin/bash
#VERSION=

# send screen saver status flag to the scratch pad
sed -i "s|^\(STATUS[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch
EOF


### send_stop.sh

IFS='' read -r -d '' file_c << "EOF"
#!/bin/bash
#VERSION=

# send screen saver status flag to the scratch pad
sed -i "s|^\(STATUS[[:blank:]]*=[[:blank:]]*\).*|\10|" /tmp/elecrow.scratch
EOF


### get_system.sh

IFS='' read -r -d '' file_d << "EOF"
#!/bin/bash
#VERSION=
 #gets System being played and handles resetting the scratchpad
 #name is handled by /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh

case "$1" in
	gameStart)

        region=$(awk -F= '/^REGION=/ {print $2}' /tmp/elecrow.scratch) #check scratch pad for region
        system="$2" #Batocera arg that pulls shorthand system name

        #create table of default system names
        declare -A full_name=(
            #Arcade
            ["mame"]="Arcade" #MAME
            ["fbneo"]="Arcade" #FinalBurn Neo
            ["dice"]="Arcade" #DICE
            ["daphne"]="Arcade" #DAPHNE (Laserdisc)
            ["singe"]="Arcade" #SINGE
            ["namco22"]="Arcade" #Namco System 22
            ["mame/model1"]="Arcade" #Sega Moduel 1
            ["model2"]="Arcade" #Sega Model 2
            ["model3"]="Arcade" #Sega Model 3
            ["naomi"]="Arcade" #Sega NAOMI
            ["hikaru"]="Arcade" #Sega Hikaru
            ["gaelco"]="Arcade" #Gaelco 3D
            ["naomi2"]="Arcade" #Sega NAOMI 2
            ["namco2x6"]="Arcade" #Namco System 246
            ["chihiro"]="Arcade" #Sega Chihiro
            ["triforce"]="Arcade" #Triforce
            ["atomiswave"]="Arcade" #Sammy Atomiswave
            ["cave3rd"]="Arcade" #Cave CV1000
            ["systemsp"]="Arcade" #Sega System SP
            ["lindbergh"]="Arcade" #Sega Lindbergh

            #Home Console

                #1st-2nd Generation
            ["gong"]="Pong"
            ["channelf"]="Fairchild Channel F"
            ["atari2600"]="Atari 2600/VCS"
            ["odyssey2"]="Magnavox Odyssey 2"
            ["astrocade"]="Bally Astrocade"
            ["apfm1000"]="APF-MP 1000"
            ["vc4000"]="Video Computer 4000"
            ["intellivision"]="Intellivision"
            ["sv8000"]="Super Vision 8000"
            ["cassettevision"]="Cassette Vision"
            ["atari5200"]="Atari 5200"
            ["colecovision"]="ColecoVision"
            ["advision"]="Adventure Vision"
            ["vectrex"]="Vectrex"
            ["crvision"]="CreatiVision"
            ["arcadia"]="Arcadia 2001"

                #3rd Generation
            ["nes"]="NES/Famicom"
            ["sg1000"]="Sega SG-1000"
            ["multivision"]="Othello Multivision"
            ["videopacplus"]="Philips Videopac+"
            ["pv1000"]="Casio PV-1000"
            ["pv2000"]="Casio PV-2000"
            ["ctvboy"]="CompactVision TVBoy" #T
            ["scv"]="SuperCassetteVision" #T
            ["mastersystem"]="Sega Master System"
            ["fds"]="Famicom Disc System"
            ["atari7800"]="Atari 7800"
            ["socrates"]="Socrates"

                #4th Generation
            ["pcengine"]="PC Engine"
            ["megadrive"]="Sega Mega Drive"
            ["pcenginecd"]="PC Engine CD-ROM" #Add the 2
            ["supergrafx"]="PCE SuperGrafx" #T
            ["snes"]="Super NES/Famicom"
            ["neogeo"]="Neo Geo"
            ["cdi"]="CD-i"
            ["amigacdtv"]="Commodore CDTV"
            ["gx4000"]="Amstrad GX4000"
            ["megacd"]="Mega CD"
            ["snes-msu1"]="Super NES CD-ROM" #Super NES CD-ROM/SNES MSU-1
            ["pico"]="Sega Pico"
            ["sgb"]="Super Game Boy"
            ["supracan"]="Super A'Can"
            ["megadrive-msu"]="Mega CD MSU" #MSU-MD (M/S CD MSU Driver)
            ["sgb-msu1"]="Super Game Boy" #LADX-MSU1 (Links Awakening audio Hack)

                #5th Generation
            ["jaguar"]="Atari Jaguar"
            ["3do"]="3DO"
            ["amigacd32"]="Amiga CD32"
            ["sega32x"]="Sega 32X"
            ["psx"]="PlayStation"
            ["pcfx"]="NEC PC-FX"
            ["neogeocd"]="Neo Geo CD"
            ["saturn"]="Sega Saturn"
            ["loopy"]="Casio Loopy"
            ["virtualboy"]="Virtual Boy"
            ["satellaview"]="Satellaview"
            ["jaguarcd"]="Atari Jaguar CD"
            ["sufami"]="SuFami Turbo"
            ["n64"]="Nintendo 64"

                #6th Generation
            ["dreamcast"]="Sega Dreamcast"
            ["n64dd"]="Nintendo 64DD"
            ["ps2"]="PlayStation 2"
            ["gamecube"]="Nintendo GameCube"
            ["xbox"]="Xbox"
            ["tvgames"]="Plug & Play TV Game"
            ["beena"]="Advanced Pico Beena"           
            ["vsmile"]="V.Smile"

                #7th Generation
            ["xbox360"]="Xbox 360"
            ["wii"]="Nintendo Wii"
            ["ps3"]="Playstation 3"

                #8th Generation
            ["wiiu"]="Nintendo Wii U"
            ["ps4"]="Playstation 4"

                #Fantasy Consoles
            ["uzebox"]="Uzebox"
            ["voxatron"]="Voxatron"
            ["pico8"]="PICO-8"
            ["tic80"]="TIC-80"
            ["lowresnx"]="Lowres NX"
            ["wasm4"]="WASM4"
            ["pyxel"]="Pyxel"
            ["vircon32"]="Vircon32"

            #Handhelds
                #LCD
            ["gameandwatch"]="Game & Watch"
            ["lcdgames"]="Handheld LCD Game"
            ["gamepock"]="Game Pocket Computer"
            
                #4th Generation
            ["gb"]="Game Boy"
            ["gb2players"]="Game Boy 2 Players"
            ["lynx"]="Atari Lynx"
            ["gamegear"]="Sega Game Gear"
            ["gamate"]="Gamate"#T
            ["gmaster"]="Game Master"#T
            ["supervision"]="Watara Supervision"
            ["megaduck"]="Mega Duck"#T

                #5th Generation  
            ["gamecom"]="Game.com"
            ["gbc"]="Game Boy Color"
            ["gbc2player"]="Game Boy Color 2P"
            ["ngp"]="Neo Geo Pocket"
            ["vemulator"]="Dreamcast VMU"
            ["ngpc"]="NeoGeo Pocket Color"
            ["wswan"]="WonderSwan"
            ["wswanc"]="WonderSwan Color"

                #6th Generation
            ["gba"]="Game Boy Advanced"
            ["pokemini"]="Pokemon Mini"
            ["gp32"]="GP32"

                #7th Generation
            ["nds"]="Nintendo DS"
            ["psp"]="PS Portable"

                #8th Generation
            ["3ds"]="Nintendo 3DS"
            ["psvita"]="PS Vita"

                #Fantasy consoles
            ["arduboy"]="Arduboy"

            #Home computer

            ["pdp1"]="PDP-1"
            ["apple2"]="Apple II"
            ["pet"]="Commodore PET"
            ["trs80"]="TRS-80"
            ["mz80k"]="Sharp MZ-80k"
            ["atari800"]="Atari 800"
            ["atom"]="Acorn Atom"
            ["ti99"]="TI-99/4 (99/4a)"
            ["pc80"]="NEC PC-8001"
            ["c20"]="Commodore VIC-20"
            ["coco"]="TRS-80 Coco"
            ["pc60"]="NEC PC-6000"
            ["pc88"]="NEC PC-8800"
            ["zx81"]="Sinclair ZX81"
            ["bbcmicro"]="BBC Micro Series"
            ["x1"]="Sharp X1"
            ["zxspectrum"]="ZX Spectrum"
            ["c64"]="Commodore 64"
            ["pc98"]="NEC PC-9800"
            ["fm7"]="Fujitsu Micro 7"
            ["tutor"]="Tomy Tutor" #T
            ["cgenie"]="Colour Genie"
            ["mz700"]="Sharp MZ-700"
            ["mz2000"]="Sharp MZ-2000"
            ["electron"]="Acorn Electron"
            ["camplynx"]="Camuters Lynx"
            ["msx1"]="Microsoft MSX1"
            ["adam"]="Coleco Adam"
            ["spectravideo"]="Spectravideo"
            ["rx78"]="Bandai RX-78"
            ["sc3000"]="Sega SC-3000"
            ["mc10"]="TRS-80 MC-10"
            ["dragon64"]="Dragon 64"
            ["amstradcpc"]="Amstrad CPC"
            ["macintosh"]="Macintosh 128k"
            ["thomson"]="Thomson MO/TO"
            ["cplus4"]="Commodore Plus/4"
            ["laser310"]="Laser 310"
            ["oricatmos"]="Oric Atmos"
            ["mz800"]="Sharp MZ-800"
            ["atarist"]="Atari ST"
            ["msx2"]="Microsoft MSX2"
            ["c128"]="Commodore 128"
            ["enterprise"]="Enterprise"
            ["pcw"]="Amstrad PCW"
            ["bk"]="Elektronika BK"
            ["mz2500"]="Sharp MZ-2500"
            ["apple2gs"]="Apple IIGS"
            ["segaai"]="Sega AI Computer"
            ["tvc"]="Videotron TVC"
            ["archimedes"]="Archimedes"
            ["xegs"]="Atari XEGS"
            ["amiga500"]="Amiga 500/OCS/ECS"
            ["x68000"]="Sharp X68000"
            ["msx2+"]="Microsoft MSX2+"
            ["fmtowns"]="FM Towns/T. Marty"
            ["samcoupe"]="SAM Coupe"
            ["amiga1200"]="Amiga 1200/AGS"
            ["vis"]="Tandy Video IS"
            ["msxturbor"]="MS MSX turboR"
            ["commanderx16"]="Commander X16"

            #Operating systems
            ["dos"]="DOSbox"
            [windows]="WINE"

            #Applications and user ports
            ["ports"]="Native Ports"
            ["flash"]="Native Port" #Flashpoint
            ["moonlight"]="Native Port" #Moonlight
            ["vgmplay"]="Native Port" #MAME Music Player
            ["odcommander"]="Native Port" #OD-Commander"

            #Ported games and engines
            ["abuse"]="Native Port" #Abuse SDL
            ["bennugd"]="BennuGD"
            ["bstone"]="Native Port" #Blake Stone
            ["cannonball"]="Native Port" #Cannonball
            ["catacomb"]="Native Port" #CatacombGL
            ["cavestory"]="Native Port" #Cave Story
            ["cdogs"]="Native Port" #C-Dogs
            ["cgenius"]="Native Port" #Commander Genius
            ["corsixth"]="Native Port" #CorsixTH
            ["devilutionx"]="Native Port" #DevilutionX
            ["doom3"]="Doom 3 BFG"
            ["dxx-rebirth"]="DXX-Rebirth"
            ["easyrpg"]="EasyRPG"
            ["ecwolf"]="Native Port" #ECWolf
            ["eduke32"]="EDuke32"
            ["etlegacy"]="Native Port" #ET: Legacy
            ["fallout1-ce"]="Native Port" #Fallout CE
            ["fallout2-ce"]="Native Port" #Fallout 2 CE
            ["fury"]="Native Port" #Ion Fury
            ["gzdoom"]="GZDoom"
            ["halflife"]="Half-Life 1"
            ["hcl"]="Native Port" #Hydra Castle Labyrinth
            ["hurrican"]="Native Port" #Hurrican
            ["ikemen"]="Ikemen Go"
            ["jazz2"]="Native Port" #Jazz Jackrabbit 2
            ["jkdfl"]="Native Port" #Jedi Knight: Dark Forces II
            ["jknight"]="Native Port" #Star Wars: Jedi Academy
            ["lutro"]="Lutro"
            ["mohaa"]="Native Port" #Medal of Honor: Allied Assault

            ["mrboom"]="Native Port" #Mr. Boom
            ["mugen"]="M.U.G.E.N."
            ["openbor"]="Native Port" #Open Beats of Rage
            ["openjazz"]="Native Port" #Openjazz
            ["prboom"]="PrBoom"
            ["pygame"]="Pygame"
            ["quake"]="Native Port" #Quake
            ["quake2"]="Native Port" #Quake II
            ["quake3"]="Native Port" #Quake 3: Arena
            ["raze"]="Raze"
            ["rott"]="Native Port" #Rise of The Triad
            ["rtcw"]="Native Port" #Return to Castle Wolfenstein
            ["reminiscence"]="REminiscence"
            ["scummvm"]="scummVM"
            ["sdlpop"]="Native Port" #SDLPoP
            ["solarus"]="Solarus"
            ["sonic-mania"]="Native Port" #Sonic Mania
            ["sonic3-air"]="Native Port" #Sonic 3 A.I.R.
            ["sonicretro"]="Sonic Retro Engine" #T
            ["superbroswar"]="Native Port" #Super Mario War
            ["theforceengine"]="The Force Engine"
            ["thextech"]="THeXTech"
            ["traider1"]="Native Port" #TRX Tomb Raider 1
            ["traider2"]="Native Port" #TRX Tomb Raider 2
            ["tyrain"]="Native Port" #Tyrain
            ["uqm"]="Native Port" #The Ur-Quan Masters
            ["vpinball"]="Native Port" #Visual Pinball
            ["xrick"]="Native Port" #Rick Dangerous
            ["zc210"]="Zelda Classics"

            #Custom (enter in below ["shorthand name]="long name, max 19 characters"
            [""]=""
        )

        #Change region specific system names
        if [[ "$region" == "en_US" ]]; then
            if [[ "$system" == "megadrive" ]]; then 
                system="Sega Genesis"
            elif [[ "$system" == "megacd" ]]; then 
                system="Sega CD"
            elif [[ "$system" == "megadrive-msu" ]]; then 
                system="Sega CD MSU"
            elif [[ "$system" == "pcengine" ]]; then
                system="Turbo Grafx-16"
            elif [[ "$system" == "pcenginecd" ]]; then
                system="Turbo Grafx-CD"
            fi
        fi

    #Check system name with table and change name (no matches/region changed get passed as-is)
    if [[ -v full_name[$system] ]]; then
        system=${full_name[$system]}
    fi

        #Write System name to the scratch pad
        sed -i "s|^\(SYSTEM[[:blank:]]*=[[:blank:]]*\).*|\1${system//&/\\&}|" /tmp/elecrow.scratch

        #write Update flag to the scratch pad
        sed -i "s|^\(UPDATE[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch

    ;;

    gameStop)
        #reset scatch pad to defaults
        sed -i "s|^\(NAME[[:blank:]]*=[[:blank:]]*\).*|\1null|" /tmp/elecrow.scratch
        sed -i "s|^\(SYSTEM[[:blank:]]*=[[:blank:]]*\).*|\1null|" /tmp/elecrow.scratch
        sed -i "s|^\(UPDATE[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch
    ;;

esac
EOF

### elecrow.py

IFS='' read -r -d '' file_e << "EOF"
#!/usr/bin/env python3
#Batocera service For Elecrow PiTower Gen 1
#Adaptation of origional PiOS script from Elecrow
#VERSION=2.3
import psutil
import time
import smbus
import os
import sys
from pathlib import Path

class RPiSystemMonitor:
    def __init__(self):
        # Initialize I2C bus
        self.bus = smbus.SMBus(0)  # Use I2C-0
        self.i2c_address = 0x2D    # I2C slave address
        # Add NVME check timer
        self.last_nvme_check_time = 0
        self.nvme_error_status = False  # Cache the error check result

    def get_cpu_usage(self):
        """Get CPU usage percentage"""
        return psutil.cpu_percent(interval=1)

    def get_memory_info(self):
        """Get memory usage information"""
        mem = psutil.virtual_memory()
        total_gb = round(mem.total / (1024**3), 1)  # Convert to GB
        return mem.percent, total_gb

    def get_temperature(self):
        """Get Raspberry Pi's temperature"""
        try:
            with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
                temp = float(f.read().strip()) / 1000
            return temp
        except:
            return 0

    def get_nvme_size(self):
        """Get NVME physical size in GB"""
        try:
            if not os.path.exists("/dev/nvme0n1"):
                return None

            # Read disk size from /sys/block/nvme0n1/size
            # This gives number of sectors, each sector is 512 bytes
            with open("/sys/block/nvme0n1/size", "r") as f:
                sectors = int(f.read().strip())
                size_gb = round((sectors * 512) / (1024**3), 1)
            return size_gb
        except Exception as e:
            print(f"Get NVME size error: {e}")
            return None

    def get_root_device(self):
        """Get the device where root (/) is mounted"""
        try:
            with open('/proc/mounts', 'r') as f:
                for line in f:
                    device, mount_point, *_ = line.split()
                    if mount_point == '/':
                        return device
            return None
        except Exception as e:
            print(f"Get root device error: {e}")
            return None

    def get_storage_info(self):
        """Get storage information for root directory and NVME"""
        try:
            # Get root directory information
            root_disk = psutil.disk_usage('/')
            root_total_gb = round(root_disk.total / (1024**3), 1)
            root_used_percent = root_disk.percent

            # Check if root is on NVME
            root_device = self.get_root_device()

            is_root_nvme = root_device is not None and 'nvme' in root_device.lower()

            # Get NVME physical size if exists
            nvme_size = self.get_nvme_size()
            nvme_info = (True, nvme_size) if nvme_size is not None else None

            return {
                'is_root_nvme': is_root_nvme,
                'root_used_percent': root_used_percent,
                'root_total_gb': root_total_gb,
                'nvme_info': nvme_info
            }
        except Exception as e:
            print(f"Storage info error: {e}")
            return None

    def get_system_language(self):
        default_lang = "en_US"
        config_path = "/userdata/system/batocera.conf"
        try:
            with open(config_path) as f:
                for line in f:
                    if line.startswith("#system.language="):
                        return default_lang
                    elif line.startswith("system.language="):
                        return line.split("=")[1].strip()

        except Exception as e:
            print(f"get system language error: {e}")
            return None

    def send_to_oled(self, x, y, message):
        """Send data to OLED display"""
        try:
            # Build data packet: x coordinate, y coordinate, string content
            data = [x, y] + list(message.encode('ascii'))
            self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)
            time.sleep(0.01)  # Wait for data processing
        except Exception as e:
            print(f"Send data error: {e}")

    def send_big_to_oled(self, x, y, message):
        """Send data to OLED display"""
        try:
            # Build data packet: x coordinate, y coordinate, string content
            data = [x, y] + list(message.encode('ascii'))
            self.bus.write_i2c_block_data(self.i2c_address, 0x01, data)
            time.sleep(0.01)  # Wait for data processing
        except Exception as e:
            print(f"Send data error: {e}")

    def send_type_to_oled(self, x, y, message):
        """Send data to OLED in a typed out style"""
        try:
            # Count message length
            message_length = len(message)
            # Set message index
            message_index = 0
            # Send message to screen one character at a time
            for _ in range(message_length):
                # Assemble data package containing the character at message index
                data = [x, y] + list(message[message_index].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)
                time.sleep(0.1)  # Wait for data processing
                #Advance message index
                message_index += 1
                #wrap around logic.
                # If current positionion is near the edge, wrap around to the next row
                if x >= 103:
                    x = 0
                    y += 1
                else:
                # Move to the next space (6 pixels for this character size)
                    x += 6
                #if row goes past the last row (6), wrap around to the top
                if y >= 6:
                    y = 0   

        except Exception as e:
            print(f"Send type error: {e}")

    def send_type_big_to_oled(self, x, y, message):
        """Send data to OLED in a typed out style"""
        try:
            # Count message length
            message_length = len(message)
            # Set message index
            message_index = 0
            # Send message to screen one character at a time
            for _ in range(message_length):
                # Assemble data package containing the character at message index
                data = [x, y] + list(message[message_index].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x01, data)
                time.sleep(0.1)  # Wait for data processing
                # Advance message index
                message_index += 1

                #wrap around logic. Character spacing 8
                # If current positionion is near the edge, wrap around to the next row
                if x >= 100:
                    x = 0
                    y += 2
                else:
                # Move to the next space (8 pixels for this character size)
                    x += 8
                #if row goes past the last row (6), wrap around to the top
                if y >= 6:
                    y = 0    

        except Exception as e:
            print(f"Send type big error: {e}")

    def send_pan_to_oled(self, x, y, message):
        """Send data to OLED thats longer than 19 characters. Pans and then resets to beginning"""
        # NOTE : Make this your last send command as it will hold up everything else
        try:
            # Count message length
            message_length = len(message) + 1
            # Set message index
            start = 0		
            stop = 19

            while True:
                # Assemble data package containing the character at message index
                data = [x, y] + list(message[start:stop].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)
                time.sleep(0.2)  # Wait for data processing
                # Advance start
                start += 1
                # Advance stop
                stop +=1
                if stop == message_length:
                    time.sleep(2.0)
                    data = [x, y] + list(message[0:19].encode('ascii'))
                    # Send data
                    self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)            
                    time.sleep(0.1)  # Wait for data processing
                    break
            return
            
        except Exception as e:
            print(f"Send pan error: {e}")

    def send_pan_big_to_oled(self, x, y, message):
        """Send data to OLED thats longer than 14 characters. Pans and then resets to beginning"""
        # NOTE : Make this your last send command as it will hold up everything else
        try:
            # Count message length
            message_length = len(message) + 1
            # Set message index
            start = 0		
            stop = 14

            while True:
                # Assemble data package containing the character at message index
                data = [x, y] + list(message[start:stop].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x01, data)
                time.sleep(0.2)  # Wait for data processing
                # Advance start
                start += 1
                # Advance stop
                stop +=1
                if stop == message_length:
                    time.sleep(2.0)
                    data = [x, y] + list(message[0:14].encode('ascii'))
                    # Send data
                    self.bus.write_i2c_block_data(self.i2c_address, 0x01, data)            
                    time.sleep(0.1)  # Wait for data processing
                    break
            return
            
        except Exception as e:
            print(f"Send pan big error: {e}")


    def send_scroll_to_oled(self, x, y, message):
        """Send data to OLED thats longer than 19 characters. scrolls twice with three spaces between"""
        # NOTE : Make this your last send command as it will hold up everything else
        try:

            # Count message length
            message_length = len(message)
            origional = message
            message = message + "   "
            counter = message_length * 2 + 7

            while True:
                # Assemble data package containing the character at message index
                if message_length <= 19:
                    data = [x, y] + list(origional[0:19].center(19).encode('ascii'))
                else:
                    data = [x, y] + list(message[0:19].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)
                time.sleep(0.2)  # Wait for data processing
                message = message[1:] + message[0]
                counter -= 1

                if counter == 0:
                    break

            return
            
        except Exception as e:
            print(f"Send scroll big error: {e}")



    def send_scroll_big_to_oled(self, x, y, message):
        """Send data to OLED thats longer than 14 characters. scrolls twice with three spaces between"""
        # NOTE : Make this your last send command as it will hold up everything else
        try:

            # Count message length
            message_length = len(message)
            origional = message
            message = message + "   "
            counter = message_length * 2 + 7

            while True:
                # Assemble data package containing the character at message index
                if message_length <= 14:
                    data = [x, y] + list(origional[0:14].center(14).encode('ascii'))
                else:
                    data = [x, y] + list(message[0:14].encode('ascii'))
                # Send data
                self.bus.write_i2c_block_data(self.i2c_address, 0x01, data)
                time.sleep(0.2)  # Wait for data processing
                message = message[1:] + message[0]
                counter -= 1

                if counter == 0:
                    break

            return
            
        except Exception as e:
            print(f"Send scroll big error: {e}")


    def send_progress_to_oled(self, y, progress):
        """Send data to OLED display"""
        try:
            data = [0xFF, 0xF0, y, progress]
            self.bus.write_i2c_block_data(self.i2c_address, 0x00, data)
            time.sleep(0.01)  # Wait for data processing
        except Exception as e:
            print(f"Send progress error: {e}")

    def clear_screen(self):
        """Clear OLED screen"""
        try:
            self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFF])
            time.sleep(0.01)
        except Exception as e:
            print(f"Clear screen error: {e}")

    def check_nvme_error(self):
        """Check NVME error status"""
        try:
            if not os.path.exists("/dev/nvme0n1"):
                return False

            # Check system log for NVME errors
            import subprocess
            cmd = "dmesg | grep -i 'nvme' | grep -i 'error\\|warning' | tail -n 1"
            result = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            # If we found any error/warning messages in recent log
            if result.stdout:
                return True

            # Additional check: read SMART data if available
            smart_cmd = "nvme smart-log /dev/nvme0n1"
            smart_result = subprocess.run(smart_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if smart_result.returncode == 0:
                # Check for critical warnings in SMART data
                if b"critical_warning" in smart_result.stdout and b": 0" not in smart_result.stdout:
                    return True

            return False
        except Exception as e:
            print(f"Check NVME error status error: {e}")
            return False

    def send_nvme_status(self):
        """Send NVME status via I2C"""
        try:
            # Check if it's time to update NVME error status (every 60 seconds)
            current_time = time.time()
            if current_time - self.last_nvme_check_time >= 60:
                self.nvme_error_status = self.check_nvme_error()
                self.last_nvme_check_time = current_time

            if not os.path.exists("/dev/nvme0n1"):
                # No NVME, send 0xFF, 0xFD
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFD])
            elif self.nvme_error_status:
                # NVME exists but has errors/warnings, send 0xFF, 0xFB
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFB])
            else:
                # NVME exists and no errors, send 0xFF, 0xFC
                self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFC])
            time.sleep(0.01)  # Wait for data processing
        except Exception as e:
            print(f"Send NVME status error: {e}")


    def check_shutdown_signal(self):
        """Check if shutdown signal is received via I2C"""
        try:
            # Read one byte from I2C device with command 0xFF
            status = self.bus.read_byte_data(self.i2c_address, 0xFF)
            return status == 0
        except Exception as e:
            print(f"Check shutdown signal error: {e}")
            return False

    def check_screensaver_status(self):
        try:
            if self.read_scratch("STATUS") == "1":            
                return True
            else:
                return False

        except Exception as e:
            print(f"check screensaver status error: {e}")
            return None


    def system_shutdown(self):
        """Perform system shutdown"""
        try:
            print("Shutdown signal received, sending confirmation...")
            # Send clear screen and shutdown confirmation signal
            self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFF])
            time.sleep(1.0)  # Wait a bit to ensure the signal is sent

            self.send_type_big_to_oled(24, 0, f"THE ONLY")
            self.send_type_big_to_oled(0, 2, f" WINNING MOVE")
            self.send_type_big_to_oled(0, 4, f"IS NOT TO PLAY")
            time.sleep(2.0)
            self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFF]) #clears screen
            time.sleep(0.1)

            # Not needed (sends shutdown to case board) left for reference
            #self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFE])
            #time.sleep(0.1)  # Wait a bit to ensure the signal is sent

            print("System will shutdown now...")
            open('/tmp/shutdown.please', 'w').close() #to ensure this file is made. needed by service script
            import subprocess
            subprocess.run(["batocera-es-swissknife", "--shutdown"])

        except Exception as e:
            print(f"System shutdown error: {e}")


    def write_scratch(self, x, y):
        try:
            update = f"{x}={y}\n"
            search = f"{x}="    
            with open("/tmp/elecrow.scratch", "r") as file:
                lines = file.readlines()
            for i, line in enumerate(lines):
                if line.startswith(search):
                    lines[i] = (update)
                    break
            with open("/tmp/elecrow.scratch", "w") as file:
                file.writelines(lines)

        except Exception as e:
            print(f"write scratch error: {e}")


    def read_scratch(self, x):
        try:
            with open("/tmp/elecrow.scratch", "r") as file:
                for line in file:
                    line = line.strip()
                    if "=" in line:
                        key, value = line.split("=", 1)
                        if key == (x):
                            key_value = value
                            return key_value 

        except Exception as e:
            print(f"read scratch error: {e}")



#####################################################################


    def run(self):
        """Main running loop"""

        #One time intro
        self.bus.write_i2c_block_data(self.i2c_address, 0x00, [0xFF, 0xFF])
        self.send_big_to_oled(0, 0, f"BATOCERA".center(14))
        time.sleep(1.0)
        self.send_type_to_oled(50, 3, f"The")
        self.send_type_to_oled(22, 4, f"Retro Gaming")
        self.send_type_to_oled(8, 5, f"Operating System")
        
        region = self.get_system_language()
        display_cycle = 4  # Track current display content (set to what screen you want to start on)
        cycle_reset = 5 # sets when display_cycle resets to zero (set to number of screens being used)
        cycle_start_time = time.time()  # Record current cycle start time
        game_lockout = 0
        temp_lockout = 0
        skip_draw = 0
        empty_line = " ".ljust(19)  # Empty line for clearing unused lines

        #create scratch file for Batocera features
        es_name = "null"
        es_system = "null"

        if os.path.exists("/tmp/elecrow.scratch"):
            os.remove("/tmp/elecrow.scratch") #Delete old copy 
        with open("/tmp/elecrow.scratch", "a", encoding="utf-8") as file:
            file.write("NAME=null\n")
            file.write("SYSTEM=null\n")
            file.write(f"REGION={region}\n")
            file.write(f"STATUS=0\n")
            file.write("UPDATE=0\n")

            
        while True:
            try:
                # Check shutdown signal first
                if self.check_shutdown_signal():
                    self.system_shutdown()
                    break  # Exit the loop after initiating shutdown

                #Check if screensaver is active
                if display_cycle != 0:
                    if self.check_screensaver_status():
                        skip_draw = 1
                    else:
                        skip_draw = 0

                # Send NVME status first
                self.send_nvme_status()
                current_time = time.time()
                # Switch display content based on cycle
                if display_cycle < 2:
                    # First two cycles (CPU/Memory and Storage) show for 8 seconds
                    if current_time - cycle_start_time >= 8:
                        cycle_start_time = current_time
                        display_cycle = (display_cycle + 1) % cycle_reset # Advance display_cycle, reset to 0 at cycle_reset
                        if display_cycle != 0:
                            self.clear_screen()
                else:
                    # remaining cycles show for 5 seconds
                    if current_time - cycle_start_time >= 5:
                        cycle_start_time = current_time
                        display_cycle = (display_cycle + 1) % cycle_reset # Advance display_cycle, reset to 0 at cycle_reset
                        if display_cycle != 0:
                            self.clear_screen()

                if skip_draw == 0:

                    if display_cycle == 0:
                        # Display CPU and memory information screen
                        cpu_usage = self.get_cpu_usage()
                        mem_usage, mem_total = self.get_memory_info()

                        cpu_msg = f"CPU:{cpu_usage:.1f}%".ljust(19)
                        mem_msg = f"MEM:{mem_usage:.1f}% => {mem_total}G".ljust(19)

                        self.send_to_oled(0, 0, cpu_msg)
                        self.send_progress_to_oled(1, int(cpu_usage))
                        self.send_to_oled(0, 2, empty_line)
                        self.send_to_oled(0, 3, mem_msg)
                        self.send_progress_to_oled(4, int(mem_usage))
                        self.send_to_oled(0, 5, empty_line)

                    elif display_cycle == 1:
                        # Display storage information screen
                        storage_info = self.get_storage_info()
                        temp_lockout = 0 # For next screen
                        if storage_info:
                            if storage_info['is_root_nvme']:
                                nvme_msg = f"NVME:{storage_info['root_used_percent']:.1f}% => {storage_info['root_total_gb']}G".ljust(19)
                                self.send_to_oled(0, 1, nvme_msg)
                                self.send_progress_to_oled(2, int(storage_info['root_used_percent']))
                            else:
                                sd_msg = f"SD:{storage_info['root_used_percent']:.1f}% => {storage_info['root_total_gb']}G".ljust(19)
                                self.send_to_oled(0, 1, sd_msg)
                                self.send_progress_to_oled(2, int(storage_info['root_used_percent']))

                                if storage_info['nvme_info']:
                                    exists, total_gb = storage_info['nvme_info']
                                    nvme_msg = f"NVME => {total_gb}G".ljust(19)
                                else:
                                    nvme_msg = "NVME not installed".ljust(19)
                                self.send_to_oled(0, 4, nvme_msg)

                    elif display_cycle == 2:
                        # Display temperature information screen
                        temperature = self.get_temperature()
                        #temperature = 85 #for testing
                        temp_msg = f"TEMP: {temperature:.1f}C".center(14)  # Center align for big font display
                        self.send_big_to_oled(0, 1, temp_msg)  # Display in the middle of the screen
                        self.send_progress_to_oled(3, int(temperature))
                        if temp_lockout == 0:
                            temp_lockout = 1
                            self.send_to_oled(66, 4, f"^") #60c - fan on
                            self.send_to_oled(89, 4, f"^") #80 - CPU throttle

                    elif display_cycle == 3:
                        # Display system time screen
                        current_datetime = time.localtime()

                        game_lockout = 0 #this is for the next screen

                        if region == "en_US":
                            #US format
                            date_msg = time.strftime("  %h %d %Y", current_datetime).ljust(14)
                            time_msg = time.strftime("   %I:%M %p", current_datetime).ljust(14)
                        else:
                            #International format
                            date_msg = time.strftime("  %Y/%m/%d", current_datetime).ljust(14)
                            time_msg = time.strftime("     %H:%M", current_datetime).ljust(14)

                        self.send_big_to_oled(0, 1, date_msg)
                        self.send_big_to_oled(0, 3, time_msg)

                    else:  # display_cycle == 4
                        # Display user custom pannel
                        #check for update to scratch file
                        if game_lockout == 0:
                            if self.read_scratch("UPDATE") == "1":
                                es_name = self.read_scratch("NAME")
                                es_system = self.read_scratch("SYSTEM")
                                self.write_scratch("UPDATE", "0")

                        if es_name == "null" or "":
                            game_lockout = 1
                            self.send_big_to_oled(0, 0, f"BATOCERA".center(14))
                            self.send_to_oled(50, 3, f"The")
                            self.send_to_oled(22, 4, f"Retro Gaming")
                            self.send_to_oled(8, 5, f"Operating System")

                        else:
                            game_lockout = 1
                            sys_length = len(es_system)
 
                            if sys_length <= 14:
                                system_centered = es_system.center(14)
                            else:
                                system_centered = es_system.center(19)

                            self.send_to_oled(20, 0, f"NOW PLAYING")
                            self.send_to_oled(35, 3, f"SYSTEM")
                            if sys_length <= 14: 
                                self.send_big_to_oled(0, 4, system_centered)
                            else:
                                self.send_to_oled(0, 5, system_centered)
                            self.send_scroll_big_to_oled(0, 1, es_name)
                        

                # Update interval
                time.sleep(1)  # Reduce update interval for smoother display

            except Exception as e:
                print(f"Runtime error: {e}")
                time.sleep(5)

if __name__ == "__main__":
    monitor = RPiSystemMonitor()
    monitor.run()

EOF


### pi_tower_gen_1

IFS='' read -r -d '' file_f << "EOF"
#!/bin/bash
#VERSION=2.3

case "$1" in
    start)
	    python3 /userdata/system/elecrow.py &
		;;
	stop)
		killall python3 /userdata/system/elecrow.py &
        # Check if stop is due to reboot
        if [ -f /tmp/reboot.please ]; then
            i2ctransfer -y 0 w3@0x2d 0x00 0xff 0xff #bash version of sending the clear screen trigger
            sleep 0.1
        # Check if stop is due to shutdown
        elif [ -f /tmp/shutdown.please ]; then
            sleep 1
            i2ctransfer -y 0 w3@0x2d 0x00 0xff 0xff #bash version of sending the clear screen trigger
            sleep 0.1
            i2ctransfer -y 0 w3@0x2d 0x00 0xff 0xfe #bash version of sending the shutdown trigger
        fi
        ;;
esac

EOF


###### Start of actual script


    # Check if scripts exsist, if not make needed directories and create files
 
    echo " "
    echo " "
    echo "Checking for scripts..."

    # getgame.sh
    if [[ ! -f "/userdata/system/configs/emulationstation/scripts/game-start/get_game.sh" ]]; then
        echo "Installing /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh"
        mkdir /userdata/system/configs/emulationstation/scripts/game-start/
        touch /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
        printf "%s\n" "$file_a" > /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
        chmod +x /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
    fi

    # send_start.sh
    if [[ ! -f "/userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh" ]]; then
        echo "Installing /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh"
        mkdir /userdata/system/configs/emulationstation/scripts/screensaver-start/
        touch /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
        printf "%s\n" "$file_b" > /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
        chmod +x /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
    fi

    # send_stop.sh
    if [[ ! -f "/userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh" ]]; then
        echo "Installing /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh"
        mkdir /userdata/system/configs/emulationstation/scripts/screensaver-stop/
        touch /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
        printf "%s\n" "$file_c" > /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
        chmod +x /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
    fi

    # get_system.sh
    if [[ ! -f "/userdata/system/scripts/get_system.sh" ]]; then
        echo "Installing /userdata/system/scripts/get_system.sh"
        mkdir /userdata/system/scripts/
        touch /userdata/system/scripts/get_system.sh
        printf "%s\n" "$file_d" > /userdata/system/scripts/get_system.sh
        chmod +x /userdata/system/scripts/get_system.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/scripts/get_system.sh
    fi

    # elecrow.py
    if [[ ! -f "/userdata/system/elecrow.py" ]]; then
        echo "Installing /userdata/system/elecrow.py"
        touch /userdata/system/elecrow.py
        printf "%s\n" "$file_e" > /userdata/system/elecrow.py
        chmod +x /userdata/system/elecrow.py
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/elecrow.py
    fi

    # pi_tower_gen_1
    if [[ ! -f "/userdata/system/services/pi_tower_gen_1" ]]; then
        echo "Installing /userdata/system/services/pi_tower_gen_1"
        touch /userdata/system/services/pi_tower_gen_1
        printf "%s\n" "$file_f" > /userdata/system/services/pi_tower_gen_1
        chmod +x /userdata/system/services/pi_tower_gen_1
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/services/pi_tower_gen_1
    fi

    # Check if scripts are up to date and update if needed

    echo " "
    echo "Checking for updates..."

    # get_game.sh
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh"
        truncate -s 0 /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
        printf "%s\n" "$file_a" > /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/game-start/get_game.sh
    fi

    # send-start.sh
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh"
        truncate -s 0 /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
        printf "%s\n" "$file_b" > /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/screensaver-start/send_start.sh
    fi

    # send-stop.sh
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh"
        truncate -s 0 /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
        printf "%s\n" "$file_c" > /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/configs/emulationstation/scripts/screensaver-stop/send_stop.sh
    fi

    # get_system.sh
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/scripts/get_system.sh)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/scripts/get_system.sh"
        truncate -s 0 /userdata/system/scripts/get_system.sh
        printf "%s\n" "$file_d" > /userdata/system/scripts/get_system.sh
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/scripts/get_system.sh
    fi

    # elecrow.py
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/elecrow.py)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/elecrow.py"
        truncate -s 0 /userdata/system/elecrow.py
        printf "%s\n" "$file_e" > /userdata/system/elecrow.py
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/elecrow.py
    fi

    # pi_tower_gen_1
    check_value=$(awk -F= '/^#VERSION=/ {print $2}' /userdata/system/services/pi_tower_gen_1)
    if awk -v v1="$check_value" -v v2="$new_version" 'BEGIN {exit !(v1 < v2)}'; then
        echo "Updating /userdata/system/services/pi_tower_gen_1"
        truncate -s 0 /userdata/system/services/pi_tower_gen_1
        printf "%s\n" "$file_f" > /userdata/system/services/pi_tower_gen_1
        sed -i "s|^\(#VERSION[[:blank:]]*=[[:blank:]]*\).*|\1$new_version|" /userdata/system/services/pi_tower_gen_1
    fi


    # Check for dtoverlay=i2c0 in /boot/config.txt
    echo " "
    echo "Checking /boot/config.txt ..."
    if ! grep -q "dtoverlay=i2c0" /boot/config.txt; then
        echo "Adding dtoverlay=i2c0 to /boot/config.txt"
        mount -o remount,rw /boot
        printf "dtoverlay=i2c0\n" >> /boot/config.txt
        batocera-services enable pi_tower_gen_1
        echo " "
        echo " "
        echo "Installation complete. You will need to reboot"
        echo " "
    else
        batocera-services enable pi_tower_gen_1
        batocera-services start pi_tower_gen_1
        echo " "
        echo " "
        echo "Installation/update complete."
        echo " "
    fi

    read -r -p "Press any key." -n 1
    