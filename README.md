# MARZ-REVERSE-PROXY ([Russian](/README_RU.md))
<p align="center"><a href="#"><img src="./media/marz.png" alt="Image" width="400" height="300"></a></p>

-----

### Proxy using VLESS-TCP-XTLS-Vision and VLESS-TCP-REALITY (Steal from yourself) behind reverse-proxy NGINX
This script is designed to quickly and easily set up a hidden proxy server, with masking via NGINX. In this variant, all incoming requests are handled by NGINX, and the server acts as a proxy server only if the request contains the correct path (URI). This increases security and helps to hide the true purpose of the server.

> [!IMPORTANT]
>  This script has been tested on Debian 12 in a KVM virtualization environment. You will need your own domain, which needs to be bound to Cloudflare for it to work correctly. It is recommended to run the script as root on a freshly installed system.

> [!NOTE]
> The script is configured according to routing rules for users in Russia.

### Setting up cloudflare
1. Upgrade the system and reboot the server.
2. Configure Cloudflare:
   - Bind your domain to Cloudflare.
   - Add the following DNS records:

| Type  | Name             | Content          | Proxy status  |
| ----- | ---------------- | ---------------- | ------------- |
| A     | your_domain_name | your_server_ip   | DNS only      |
| CNAME | www              | your_domain_name | DNS only      |
   
3. SSL/TLS settings in Cloudflare:
   - Go to SSL/TLS > Overview and select Full for the Configure option.
   - Set the Minimum TLS Version to TLS 1.3.
   - Enable TLS 1.3 (true) under Edge Certificates.

-----

### Includes:
  
1. Xray server configuration with MARZBAN:
   - VLESS-TCP-XTLS-Vision и VLESS-TCP-REALITY (Steal from yourself).
   - Connection of subscription for automatic configuration updates.
   - [Marzban custom subcription](https://github.com/x0sina/marzban-sub).
   - [Marzban torrent blocker](https://github.com/kutovoys/marzban-torrent-blocker).
2. Configuring NGINX reverse proxy on port 443.
3. Providing security:
   - Automatic system updates via unattended-upgrades.
4. Configuring Cloudflare SSL certificates with automatic updates to secure connections.
5. Configuring WARP to protect traffic.
6. Enabling BBR - improving the performance of TCP connections.
7. Configuring UFW (Uncomplicated Firewall) for access control.
8. Configuring SSH, to provide the minimum required security.
9. Disabling IPv6 to prevent possible vulnerabilities.
10. Encrypting DNS queries using systemd-resolved (Dot) or AdGuard Home (DoH-Dot).
11. Selecting a random website from an array to add an extra layer of privacy and complexity for traffic analysis.

-----

### Installation of MARZ-RP:

To begin configuring the server, simply run the following command in a terminal:
```sh
bash <(curl -Ls https://github.com/cortez24rus/marz-reverse-proxy/raw/refs/heads/main/marz-rp-install-server.sh)
```

### Selecting and installing a random template for the website:
```sh
bash <(curl -Ls https://github.com/cortez24rus/marz-reverse-proxy/raw/refs/heads/main/marz-rp-random-site.sh)
```

The script will then prompt you for the necessary configuration information:

![image](https://github.com/user-attachments/assets/dc60caee-1b01-40c9-a344-e0a67ebfc2ee)

### Note: 
- Once the configuration is complete, the script will display all the necessary links and login information for the MARZBAN administration panel.
- All configurations can be modified as needed due to the flexibility of the settings.

-----

## If this program was useful for you, please give it a star ⭐

-----

## Stargazers over time
[![Stargazers over time](https://starchart.cc/cortez24rus/marz-reverse-proxy.svg?variant=adaptive)](https://starchart.cc/cortez24rus/marz-reverse-proxy)
