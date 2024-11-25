mkdir /etc/haproxy/certs
cat /etc/letsencrypt/live/${domain}/fullchain.pem /etc/letsencrypt/live/${domain}/privkey.pem > /etc/haproxy/certs/${domain}.pem

cat > /etc/haproxy/haproxy.cfg <<EOF
global
        # Uncomment to enable system logging
        # log /dev/log local0
        # log /dev/log local1 notice
        log /dev/log local2 warning
        lua-load /etc/haproxy/auth.lua
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Mozilla Intermediate
        # ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305
        # ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        # ssl-default-bind-options prefer-client-ciphers no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets
        # ssl-default-server-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305
        # ssl-default-server-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        # ssl-default-server-options no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets

        # Mozilla Modern
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options prefer-client-ciphers no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets
        ssl-default-server-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-server-options no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets

        # You must first generate DH parameters - [ openssl dhparam -out /etc/haproxy/dhparam.pem 2048 ]
        ssl-dh-param-file /etc/haproxy/dhparam.pem

defaults
        mode http
        log global
        option tcplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000

frontend haproxy-tls
        mode tcp
        timeout client 1h
        bind :::443 v4v6 ssl crt /etc/haproxy/certs/${domain}.pem alpn h2,http/1.1
        acl host_ip hdr(host) -i ${serverip}
        tcp-request content reject if host_ip
        tcp-request inspect-delay 5s
        tcp-request content accept if { req_ssl_hello_type 1 }
        use_backend http-sub if { path /${subspath} } || { path_beg /${subspath}/ }
        use_backend %[lua.trojan_auth]
        default_backend http

backend trojan
        mode tcp
        timeout server 1h
        server sing-box 127.0.0.1:10443

backend http
        mode http
        timeout server 1h
        http-request auth unless { http_auth(mycredentials) }
        http-request redirect code 301 location https://${redirect}/
        server nginx 127.0.0.1:11443

backend http-sub
        mode http
        timeout server 1h
        server nginx 127.0.0.1:11443

userlist mycredentials
EOF

systemctl enable haproxy.service
haproxy -f /etc/haproxy/haproxy.cfg -c
systemctl restart haproxy.service
}
