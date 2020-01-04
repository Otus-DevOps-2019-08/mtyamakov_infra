#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
#Add systemd unit 
tee /lib/systemd/system/reddit-app.service << EOF
[Unit]
Description=Reddit Application Service

[Service]
WorkingDirectory=/home/m.tyamakov/reddit
ExecStart=/usr/local/bin/puma
Restart=always
RestartSec=10
SyslogIdentifier=reddit-app

[Install]
WantedBy=multi-user.target
EOF
#Start application
systemctl enable reddit-app
systemctl start reddit-app

