import tkinter as tk
from tkinter import messagebox
import speedtest

def test_speed():
    try:
        st = speedtest.Speedtest()
        st.download()
        st.upload()
        
        download_speed = st.results.download / 1_000_000  # Convert to Mbps
        upload_speed = st.results.upload / 1_000_000      # Convert to Mbps
        ping = st.results.ping

        download_label.config(text=f"Download Speed: {download_speed:.2f} Mbps")
        upload_label.config(text=f"Upload Speed: {upload_speed:.2f} Mbps")
        ping_label.config(text=f"Ping: {ping:.2f} ms")

    except Exception as e:
        messagebox.showerror("Error", f"Failed to test speed: {e}")

# Set up the GUI
root = tk.Tk()
root.title("Internet Speed Test")
root.geometry("300x200")

# Add a label to display the speeds
download_label = tk.Label(root, text="Download Speed: --- Mbps", font=("Arial", 12))
download_label.pack(pady=10)

upload_label = tk.Label(root, text="Upload Speed: --- Mbps", font=("Arial", 12))
upload_label.pack(pady=10)

ping_label = tk.Label(root, text="Ping: --- ms", font=("Arial", 12))
ping_label.pack(pady=10)

# Add a button to trigger the speed test
test_button = tk.Button(root, text="Test Speed", command=test_speed, font=("Arial", 12), bg="lightblue")
test_button.pack(pady=20)

# Run the Tkinter main loop
root.mainloop()
