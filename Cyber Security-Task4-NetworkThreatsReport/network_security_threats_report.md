# Research Report: Common Network Security Threats

## Introduction

Network security threats are a constant operational reality for anyone managing systems connected to the internet. Because modern infrastructures rely heavily on interconnected services, cloud environments, and remote access, the attack surface is wide. Threats matter because a single misconfiguration, unpatched vulnerability, or compromised credential can bring down critical infrastructure, leak sensitive data, and cause massive financial losses. Analyzing these vectors helps administrators build proper defenses rather than just reacting after an incident occurs.

---

## 1. Denial of Service (DoS) and Distributed Denial of Service (DDoS) Attacks

### How It Works
* **Denial of Service (DoS):** A DoS attack typically originates from a single system aiming to exhaust a target's resources (CPU, memory, or network bandwidth). This is often done by flooding a server with malformed packets, excessive connection requests (like SYN floods), or resource-heavy application queries until the service crashes or stops responding to legitimate users.
* **Distributed Denial of Service (DDoS):** A DDoS attack scales this concept up significantly. Instead of a single machine, the attacker uses a botnet—thousands of compromised systems (such as IoT devices, home routers, or infected servers) spread across the globe—to bombard the target simultaneously. Because the traffic comes from countless distinct IP addresses, it is much harder to block without accidentally cutting off legitimate users.

### Real-World Example
One of the most notable DDoS attacks occurred in October 2016 against Dyn, a major DNS provider. A botnet built using the Mirai malware infected hundreds of thousands of insecure consumer devices with default passwords. The resulting flood of traffic knocked out major sites like Twitter, Reddit, Netflix, and GitHub across large parts of the internet.

### Impact
* Complete service outages for web applications, APIs, or customer portals.
* Loss of revenue during downtime and costly incident response efforts.
* Distraction tactics where a DDoS flood is used as a smokescreen while attackers attempt a quieter data breach elsewhere.

### Mitigation Strategies
1. **Rate Limiting:** Configuring firewalls and web servers to drop or throttle connections from clients exceeding a reasonable number of requests per second.
2. **Cloud Scrubbing Centers:** Routing traffic through providers like Cloudflare, AWS Shield, or Akamai, which absorb massive traffic spikes and filter out malicious packets before they hit your core servers.
3. **Anycast Routing:** Distributing DNS or web traffic across multiple geographically diverse data centers so that a regional flood doesn't overwhelm a single point of failure.

---

## 2. Man-in-the-Middle (MITM) Attacks

### How It Works
A Man-in-the-Middle attack happens when an unauthorized third party places themselves between a client and a server. Both parties think they are talking directly to each other, but the attacker is actually intercepting, reading, and potentially modifying all data passing through. This is commonly done on local networks using ARP poisoning, or by setting up rogue Wi-Fi access points that mimic legitimate networks.

### Real-World Example
An attacker sets up an open Wi-Fi hotspot in a coffee shop named "Free Public Wi-Fi." When users connect, the attacker uses packet-sniffing tools like Wireshark or ARP spoofing utilities to capture unencrypted HTTP traffic, session cookies, and login credentials as they pass through the wireless gateway.

### Impact
* Theft of plain-text passwords, session tokens, and personal data.
* Session hijacking, allowing the attacker to take over active user accounts.
* Silent tampering with transferred files or bank transaction details.

### Mitigation Strategies
1. **Enforce HTTPS (TLS):** Ensuring all web applications use strict Transport Layer Security (TLS) so that even if traffic is intercepted, it remains completely encrypted and unreadable.
2. **Use VPNs on Untrusted Networks:** Mandating Virtual Private Networks when connecting via public Wi-Fi to tunnel all traffic through an encrypted gateway.
3. **Certificate Pinning and HSTS:** Implementing HTTP Strict Transport Security (HSTS) and pinning valid certificates in mobile/desktop apps to prevent fake certificate acceptance.

---

## 3. IP Spoofing

### How It Works
IP spoofing involves altering the source IP address headers in transmitted network packets. Because standard IP routing only looks at the destination address to forward packets, routers initially accept packets without verifying if the source IP is legitimate. Attackers use this trick to masquerade as a trusted internal host, bypass IP-based access control lists (ACLs), or conceal their true location during network scans and reflection attacks.

### Real-World Example
IP spoofing is heavily relied upon in reflection-based DDoS attacks (like NTP or DNS amplification). An attacker sends small requests to open servers with a forged source IP address set to the victim's IP, causing those servers to reply with massive data payloads directly to the victim, overwhelming them.

### Impact
* Circumvention of perimeter firewalls that rely strictly on source IP trust relationships.
* Concealment of the true origin of network probes or malicious scans.
* Disruption of TCP sequence tracking and session integrity.

### Mitigation Strategies
1. **Ingress and Egress Filtering (BCP 38):** Configuring network boundary routers to drop packets whose source IP addresses do not match the legitimate subnet assigned to that network interface.
2. **Cryptographic Protocols:** Utilizing IPsec or higher-layer cryptographic authentication that verifies packet authenticity rather than trusting raw IP headers.
3. **Switch Security Features:** Enabling features like Dynamic ARP Inspection (DAI) and IP Source Guard on enterprise network switches to block spoofed local traffic.

---

## 4. (Bonus) DNS Poisoning / DNS Spoofing

### How It Works
DNS poisoning targets how computers resolve domain names into numerical IP addresses. An attacker injects false address records into the cache of a DNS resolver. When users on that network try to visit a specific website, the poisoned cache redirects them to a malicious server controlled by the attacker instead of the real destination.

### Real-World Example
The Kaminsky DNS vulnerability discovered in 2008 exposed a critical flaw in how DNS servers handled transaction IDs. It allowed attackers to rapidly spoof DNS responses and poison caching servers, forcing entire domains to resolve to rogue servers.

### Impact
* Mass redirection of users to convincing phishing sites or malware distribution hubs.
* Interception of corporate email and web traffic without the user's knowledge.
* Severe damage to organizational reputation and customer trust.

### Mitigation Strategies
1. **Deploying DNSSEC (DNS Security Extensions):** Implementing cryptographic digital signatures on DNS records so resolvers can verify that the data hasn't been tampered with.
2. **Using Hardened Public Resolvers:** Utilizing modern DNS resolvers (such as Cloudflare's 1.1.1.1 or Google's 8.8.8.8) that randomize source ports and transaction IDs to prevent cache injection.
3. **Regular Patching:** Keeping DNS server software updated to protect against known protocol implementation flaws.

---

## Comparison Table

| Attack Vector | Who is at Risk? | Difficulty to Execute | Ease of Mitigation |
| :--- | :--- | :--- | :--- |
| **DoS / DDoS** | Public-facing web servers, APIs, e-commerce platforms | Low to Moderate (botnets can be rented cheaply) | Moderate to High (requires external scrubbing services) |
| **Man-in-the-Middle (MITM)** | Users on public Wi-Fi, legacy apps using unencrypted protocols | Moderate (requires local network access or ARP manipulation) | Moderate (mitigated by strict HTTPS and VPN usage) |
| **IP Spoofing** | Networks lacking proper boundary filtering, legacy TCP services | High (requires deep packet crafting and network positioning) | Moderate (requires router configuration like BCP 38) |
| **DNS Poisoning** | Vulnerable local DNS caching servers, end-user systems | High (requires precise timing and protocol exploitation) | Moderate (solved by widespread adoption of DNSSEC) |

---

## Conclusion: Key Takeaways for a Network Administrator

1. **Layer Your Defenses (Defense-in-Depth):** No single tool stops every threat. Firewalls, encrypted protocols, intrusion detection systems, and proper routing rules must work together.
2. **Visibility is Essential:** Regularly scanning your network (using tools like Nmap) and monitoring traffic baselines lets you catch anomalies or unauthorized devices before they turn into major incidents.
3. **Configuration Hygiene Matters:** Simple administrative tasks—like enforcing packet filtering, keeping firmware updated, and moving away from legacy unencrypted protocols—eliminate a huge percentage of everyday network risks.

---

## References

1. **National Institute of Standards and Technology (NIST):** Special Publication 800-83, *Guide to Malware Incident Prevention and Handling for Desktops and Laptops*.
2. **Cybersecurity and Infrastructure Security Agency (CISA):** *Understanding and Mitigating Denial-of-Service Attacks*.
3. **MITRE ATT&CK Framework:** *Techniques for Network Denial of Service and Spoofing (TA0005 / TA0040)*.
4. **SANS Institute Reading Room:** *Defending Against Man-in-the-Middle and Spoofing Attacks in Enterprise Networks*.
