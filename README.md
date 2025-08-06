# ROS Boat Control Panel

Real-time dashboard for monitoring and controlling autonomous boats via ROS communication.

## Overview

Flutter-based control panel application for ROS operated boats/submarines. Provides real-time visualization of boat telemetry data including attitude, speed, compass heading, battery status, rudder angle, and navigation parameters through TCP socket communication with ROS systems.

## Features

**Main gauges:**
- Attitude indicator (pitch/roll with artificial horizon)
- Speed gauge with control slider
- Digital compass with ship outline
- Battery voltage monitor
- Rudder angle indicator

**Status info:**
- Course over ground
- GPS position
- Water depth
- Connection status
- Control mode switching

**Controls:**
- External joystick toggle
- Manual/auto mode
- Real-time parameter tweaking
- Socket connection management

## Tech stack

- Flutter/Dart frontend
- Riverpod for state management
- GoRouter for navigation
- TCP socket communication (port 8765)
- JSON data format

## Requirements

**Desktop:**
- Flutter SDK 3.0+
- Works on Windows/Linux/macOS

**Boat side:**
- ROS system running TCP server on port 8765
- Network connection to control station

**Data format expected:**
```json
{
  "pitch": 12.5,
  "roll": -3.2,
  "speed": 45.0,
  "battery_voltage": 11.8,
  "rudder_angle": 15.0,
  "yaw": 180.0
}
```

## Getting started

```bash
git clone https://github.com/PawelG1/ROSBoatControlPanel.git
cd ROSBoatControlPanel
flutter pub get
flutter run
```

For socket testing:
```bash
flutter run lib/test_ws.dart
```

## Usage

1. Launch the application
2. Navigate to Connection Settings
3. Enter boat's IP address
4. Click Connect
5. Monitor live data on Dashboard

Default settings:
- Port: 8765
- IP: 192.168.1.1 (configure for your boat's IP)

## ROS integration

ROS side requires TCP server sending JSON data. Example Python implementation:

```python
import socket
import json
import time

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('0.0.0.0', 8765))
server.listen(1)

while True:
    client, addr = server.accept()
    while True:
        data = {
            "pitch": get_pitch(),
            "roll": get_roll(),
            "speed": get_speed(),
            "battery_voltage": get_battery(),
            "rudder_angle": get_rudder_angle()
        }
        message = json.dumps(data) + '\n'
        client.send(message.encode())
        time.sleep(0.1)
```

Recommended data rate: 10-50Hz for smooth updates.

## Testing

Built-in socket testing tool:
```bash
flutter run lib/test_ws.dart
```

Features raw message monitoring, JSON parsing verification, and connection status tracking.

## Project structure

```
lib/
├── main.dart                     # App entry point
├── routes.dart                   # Navigation setup
├── screens/
│   ├── dashboard_screen.dart     # Main dashboard
│   └── connection_screen.dart    # Connection setup
├── widgets/
│   ├── dashboard_card.dart       # Reusable gauge container
│   ├── battery_ind.dart          # Battery indicator
│   ├── rudderAngleIndicator.dart # Rudder position
│   ├── menuSideBar.dart          # Side navigation
│   └── gauges/                   # All gauge widgets
├── services/
│   └── socketService.dart        # ROS communication
└── providers/                    # State management
```

## Contributing

Submit issues or pull requests via GitHub. Code reviews and improvements welcome.

## Roadmap

Planned features:
- Historical data charts
- GPS map view

## License

MIT License
