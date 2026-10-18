#!/usr/bin/env python3
#Batocera service For Elecrow PiTower Gen 1
#Adaptation of origional PiOS script from Elecrow
#VERSION=2.2
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
            # Not needed (sends shutdown signal) left for reference
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
            print(f"write to scratch error: {e}")


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
            print(f"write to scratch error: {e}")



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
            file.write("UPDATE=0\n")
            
        while True:
            try:
                # Check shutdown signal first
                if self.check_shutdown_signal():
                    self.system_shutdown()
                    break  # Exit the loop after initiating shutdown

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
                        #self.send_to_oled(55, 4, f"|") #50c
                        self.send_to_oled(66, 4, f"^") #60c - fan on/low
                        self.send_to_oled(66, 5, f"L")
                        self.send_to_oled(74, 4, f"^") #67.5 - fan med
                        self.send_to_oled(74, 5, f"M")                   
                        self.send_to_oled(83, 4, f"^") #75 - fan high
                        self.send_to_oled(83, 5, f"H")                    
                        self.send_to_oled(89, 4, f"^") #80 - CPU throttle
                        self.send_to_oled(89, 5, f"**")                        
                        self.send_to_oled(94, 4, f"^") #85 - CPU max throttle

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
