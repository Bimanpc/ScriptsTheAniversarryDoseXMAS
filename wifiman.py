import tkinter as tk
from tkinter import messagebox
import subprocess
import os

class WifiManager:
    def __init__(self, root):
        self.root = root
        self.root.title("Wi-Fi Manager")
        self.root.geometry("400x300")

        # Frame for Wi-Fi networks
        self.networks_frame = tk.Frame(root)
        self.networks_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Label for network list
        self.networks_label = tk.Label(self.networks_frame, text="Available Networks:")
        self.networks_label.pack(anchor=tk.W)

        # Listbox to display networks
        self.networks_listbox = tk.Listbox(self.networks_frame, height=10)
        self.networks_listbox.pack(fill=tk.BOTH, expand=True)

        # Connect button
        self.connect_button = tk.Button(root, text="Connect", command=self.connect_to_network)
        self.connect_button.pack(pady=10)

        # Entry for password
        self.password_label = tk.Label(root, text="Password:")
        self.password_label.pack(anchor=tk.W)
        self.password_entry = tk.Entry(root, show="*")
        self.password_entry.pack(fill=tk.X, padx=10)

        # Refresh and status
        self.refresh_button = tk.Button(root, text="Refresh Networks", command=self.scan_networks)
        self.refresh_button.pack(pady=10)
        self.status_label = tk.Label(root, text="Status: Not connected")
        self.status_label.pack(anchor=tk.W, padx=10)

        # Initial scan
        self.scan_networks()

    def scan_networks(self):
        self.networks_listbox.delete(0, tk.END)
        try:
            # Use 'netsh wlan show networks' command for Windows
            result = subprocess.check_output("netsh wlan show networks", shell=True).decode('utf-8')
            networks = [line.split(": ")[1] for line in result.split("\n") if "SSID" in line]
            for network in networks:
                self.networks_listbox.insert(tk.END, network)
        except Exception as e:
            messagebox.showerror("Error", f"Failed to scan networks.\n{e}")

    def connect_to_network(self):
        selected_network = self.networks_listbox.get(tk.ACTIVE)
        password = self.password_entry.get()
        if not selected_network:
            messagebox.showwarning("No Network Selected", "Please select a network to connect.")
            return

        # Create a Wi-Fi profile to connect
        profile_xml = f"""
        <WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
            <name>{selected_network}</name>
            <SSIDConfig>
                <SSID>
                    <name>{selected_network}</name>
                </SSID>
            </SSIDConfig>
            <connectionType>ESS</connectionType>
            <connectionMode>auto</connectionMode>
            <MSM>
                <security>
                    <authEncryption>
                        <authentication>WPA2PSK</authentication>
                        <encryption>AES</encryption>
                        <useOneX>false</useOneX>
                    </authEncryption>
                    <sharedKey>
                        <keyType>passPhrase</keyType>
                        <protected>false</protected>
                        <keyMaterial>{password}</keyMaterial>
                    </sharedKey>
                </security>
            </MSM>
        </WLANProfile>
        """
        
        try:
            # Save the profile XML temporarily
            profile_path = "wifi_profile.xml"
            with open(profile_path, "w") as f:
                f.write(profile_xml)

            # Add the profile
            subprocess.run(f'netsh wlan add profile filename="{profile_path}"', shell=True)

            # Connect to the network
            connect_command = f'netsh wlan connect name="{selected_network}"'
            subprocess.run(connect_command, shell=True)

            # Update the status label
            self.status_label.config(text=f"Status: Connected to {selected_network}")
            os.remove(profile_path)  # Clean up
        except Exception as e:
            messagebox.showerror("Connection Error", f"Failed to connect to network.\n{e}")

# Run the application
if __name__ == "__main__":
    root = tk.Tk()
    app = WifiManager(root)
    root.mainloop()
