import socket
import struct
import matplotlib.pyplot as plt
from collections import deque

# UDP configuration
UDP_IP = "0.0.0.0"
UDP_PORT = 5005

# Store the latest 100 samples
values = deque(maxlen=100)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))
sock.settimeout(0.1)

plt.ion()

fig, ax = plt.subplots()
line, = ax.plot([], [])

ax.set_title("FPGA Real-Time ADC Data")
ax.set_xlabel("Sample Number")
ax.set_ylabel("ADC Value")
ax.grid(True)

print("Waiting for FPGA UDP data on port 5005...")

try:
    while True:
        try:
            packet, address = sock.recvfrom(2048)

            # Expected format: one unsigned 16-bit big-endian sample
            if len(packet) >= 2:
                values.append(value)

                line.set_data(range(len(values)), list(values))
                ax.relim()
                ax.autoscale_view()
                plt.pause(0.01)

                print("Received:", value)

        except socket.timeout:
            plt.pause(0.01)

except KeyboardInterrupt:
    print("Receiver stopped.")

finally:
    sock.close()
    plt.close("all")