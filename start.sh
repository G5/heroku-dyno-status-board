#!/bin/bash
rerun -- bundle exec thin start -p 4567 --ssl --ssl-key-file=ssl/server.key --ssl-cert-file=./ssl/server.crt -R config.ru