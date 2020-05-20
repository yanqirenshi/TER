#!/bin/sh

CONFIG_FILE=/var/www/TER/web/config.js

echo "const _CONFIG = {"                        >  $CONFIG_FILE
echo "    api : {"                              >> $CONFIG_FILE
echo "        scheme: '${API_SCHEME}',"         >> $CONFIG_FILE
echo "        host: '${API_HOST}',"             >> $CONFIG_FILE
echo "        port: '${API_PORT}',"             >> $CONFIG_FILE
echo "        path: {"                          >> $CONFIG_FILE
echo "            prefix: '${API_PATH_PREFIX}'" >> $CONFIG_FILE
echo "        }"                                >> $CONFIG_FILE
echo "    },"                                   >> $CONFIG_FILE
echo "    auth: {"                              >> $CONFIG_FILE
echo "        sign: {"                          >> $CONFIG_FILE
echo "                in: {"                    >> $CONFIG_FILE
echo "                    url: '/sign/in'"      >> $CONFIG_FILE
echo "                },"                       >> $CONFIG_FILE
echo "        },"                               >> $CONFIG_FILE
echo "    },"                                   >> $CONFIG_FILE
echo "};"                                       >> $CONFIG_FILE
