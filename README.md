
---

# Winderella – Mirroring Wind Hazard Detection System

Winderella is a low-cost, real-time wind hazard detection and visualization system designed to provide **hyperlocal, accessible, and reliable wind monitoring**, especially for disaster-prone communities.

The system transforms invisible wind risks into **visible, easy-to-understand alerts**, helping communities prepare for and respond to extreme weather conditions such as typhoons.

---

## Overview

Winderella addresses key limitations in existing weather monitoring systems:

* Lack of **barangay-level (micro-local) data**
* High cost of traditional weather stations (₱50,000–₱200,000)
* Dependence on **internet and power infrastructure**
* Limited accessibility for everyday citizens

By combining **hardware sensors and software visualization**, Winderella delivers real-time insights even in low-resource environments .

---

## Key Features

* **Hyperlocal Wind Monitoring** – Provides localized, real-time wind data
* **Offline Capability** – Works even during brownouts or internet outages
* **Visual Hazard Indicators** – Converts wind data into intuitive visual alerts
* **Ultra Low-Cost** – Built for less than ₱1,000
* **User-Friendly** – Accessible for children, elderly, and non-technical users
* **Portable & Deployable** – Lightweight and easy to install anywhere 

---

## How It Works

### System Flow

**Input → Process → Output**

1. **Input**

   * Wind energy captured using a DC motor (acting as a simple anemometer)

2. **Process**

   * Arduino reads sensor data
   * Data processed locally and optionally sent to a backend (Python)

3. **Output**

   * LED indicators for immediate visual feedback
   * Web/mobile dashboard (Flutter) for monitoring and analysis 

---

## Tech Stack

### Hardware

* Arduino (e.g., Arduino Uno)
* DC motor (wind sensor)
* LEDs (visual indicators)
* Basic electronic components

### Software

* Python (backend / data processing)
* Flutter (mobile/web interface)
* Web dashboard (optional monitoring system)

---

## Use Cases

Winderella is designed for communities vulnerable to extreme weather:

* Barangays and LGUs (Local Government Units)
* Disaster Risk Reduction and Management (DRRM) teams
* Farmers and agricultural areas
* Coastal and upland communities
* Schools and evacuation centers 

---

## Advantages Over Existing Systems

| Existing Systems            | Winderella                |
| --------------------------- | ------------------------- |
| Regional forecasts only     | Barangay-level monitoring |
| Expensive weather stations  | Ultra low-cost (< ₱1,000) |
| Requires internet           | Works offline             |
| Complex data interpretation | Visual, intuitive alerts  |
| Limited accessibility       | Community-friendly        |

---

## SDG Alignment

Winderella supports **United Nations Sustainable Development Goal 11 (SDG 11): Sustainable Cities and Communities** by:

* Enhancing disaster preparedness
* Reducing risk and damage from natural hazards
* Enabling data-driven local decision-making
* Providing affordable and scalable infrastructure 

---

## Future Improvements

* IoT integration for centralized monitoring
* Geo-mapping and barangay-level alert systems
* Integration with DRRM databases
* Multi-sensor deployments across communities
* Smart dashboards for predictive analytics 

---

## Project Vision

> “We make invisible danger visible.
> We empower barangays to become disaster-ready.
> We protect Filipino lives and dreams.” 

---

## Author

**Aundreka Perez**
Project Developer

---

## License

This project is intended for educational and community development purposes. Licensing can be added based on deployment or distribution needs.

---

