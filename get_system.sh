#!/bin/bash

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