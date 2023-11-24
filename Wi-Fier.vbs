import subprocess

def get_wifi_signal_strength(interface="wlan0"):
    try:
        command = "iwconfig " + interface
        result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        # Parsing the result to extract signal strength
        signal_strength_index = result.find("Signal level=")
        if signal_strength_index != -1:
            signal_strength = result[signal_strength_index + len("Signal level="):].split(" ")[0]
            return signal_strength
        else:
            return "Signal level not found."
    except subprocess.CalledProcessError as e:
        return "Error: " + str(e)

if __name__ == "__main__":
    signal_strength = get_wifi_signal_strength()
    print("Wi-Fi Signal Strength: " + signal_strength)
