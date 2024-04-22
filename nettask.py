import subprocess

def ping_scan():
    for ping in range(1, 10):
        address = f"127.0.0.{ping}"
        res = subprocess.call(['ping', '-c', '3', address])
        if res == 0:
            print(f"Ping to {address} OK")
        elif res == 2:
            print(f"No response from {address}")
        else:
            print(f"Ping to {address} failed!")

# Run the ping scan
ping_scan()
