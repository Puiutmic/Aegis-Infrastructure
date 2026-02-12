# Aegis: My Over-Engineered Home Lab

![Aegis Architecture](Aegis.jpg)

### Hi, I'm David 
I'm a Cybernetics Student at ASE Bucharest with a passion for DevOps and Infrastructure.

"Aegis" is my attempt to build a production-grade infrastructure on hardware that belongs in a museum. Instead of paying for cloud credits, I wanted to learn how to secure, monitor, and automate a server from scratch, dealing with real-world constraints like limited RAM and CPU cycles.

---

## Why I built this?
I wanted to move beyond "it works on my machine." My goal was to create a server that is:
1.  **Secure by default** (Zero-Trust, no open ports).
2.  **Self-healing** (Automated maintenance).
3.  **Visible** (If it breaks, I want to see a graph of *why*).

## The Hardware (The Real Challenge)
The heart of this operation is an **Intel Pentium G3258** with **4GB of RAM**.
Running a full monitoring stack + web services on a dual-core CPU from 2014 forced me to be extremely efficient with Docker resource limits and image optimization.

## Architecture & Tech Stack

Everything runs on **Ubuntu Server**, orchestrated via **Docker Compose**.

### Security & Networking (Zero-Trust)
I didn't want to expose my home router to the internet via Port Forwarding. It felt unsafe.
* **Tailscale Mesh VPN:** I set up a mesh network where devices connect directly (peer-to-peer).
* **ACLs (Access Control Lists):** I configured strict rules. My phone can see the dashboard, but public traffic can *only* hit the specific web container.
* **The "Funnel":** I use Tailscale Funnel as an ingress controller to expose internal apps securely via HTTPS without messing with dynamic DNS or router configs.

### Observability (My Favorite Part)
I need to know if the Pentium is melting.
* **Prometheus** scrapes metrics every 15 seconds.
* **Grafana** visualizes CPU load, RAM usage, and container health.
* **Node Exporter** gives me the raw hardware data.

### Automation
I wrote Bash scripts (managed by Cron) to handle the boring stuff:
* `maintenance.sh`: Automatically updates system packages and cleans up unused Docker images/volumes to save disk space.
* Log rotation ensures the drive doesn't fill up overnight.

---

## "It works now, but..." (Challenges I faced)
* **The "OOM" Killer:** Initially, Grafana + Prometheus ate all the RAM. I had to tweak the scraping intervals and retention policies to make it stable on 4GB.
* **Public Access:** I wanted to host a static site for a project (Valentine's Day surprise), but keeping it secure was tricky. I used **Tailscale Funnel** to isolate that specific container from the rest of my internal network.

## How to run it
If you have an old laptop or PC gathering dust, here is how you can replicate my stack:

```bash
# Clone the repo
git clone [https://github.com/Puiutmic/aegis-infrastructure.git](https://github.com/Puiutmic/aegis-infrastructure.git)

# Spin up the containers
docker compose up -d
