##### ################################################################
#####
#####  API サーバーのための Dockerfile
#####
#####   Build
#####   =====
#####    docker build -t renshi/ter -f Dockerfile .
#####
#####   Run
#####   ===
#####     docker run  -it -p 55555:55555 renshi/ter
#####     docker run  -d  -p 55555:55555 renshi/ter
#####     docker exec -it renshi/ter /bin/bash
#####     docker run  -it renshi/ter /bin/bash
#####
#####   Variables
#####   =========
#####    API-PORT : 55555
#####    API-SESSION-NAME : ter.session
#####    DIR-GRAPH-COMMON :
#####    DIR-GRAPH-CAMPUS :
#####    DIR-GRAPH-SCHEMA :
#####
##### ################################################################
FROM renshi/strobolights

MAINTAINER Renshi <yanqirenshi@gmail.com>


##### ################################################################
#####   libs
##### ################################################################
USER appl-user
WORKDIR /home/appl-user/prj/libs

RUN git clone https://github.com/yanqirenshi/plist-printer
RUN git clone https://github.com/yanqirenshi/parser.schema.rb.git

RUN ln -s /home/appl-user/prj/libs/plist-printer/plist-printer.asd       /home/appl-user/.asdf/plist-printer.asd
RUN ln -s /home/appl-user/prj/libs/parser.schema.rb/parser.schema.rb.asd /home/appl-user/.asdf/parser.schema.rb.asd


##### ################################################################
#####   Appl : Git Clone
##### ################################################################
USER appl-user
WORKDIR /home/appl-user/prj
RUN git clone https://github.com/yanqirenshi/plist-printer

RUN git clone https://github.com/yanqirenshi/TER.git

RUN ln -s /home/appl-user/prj/TER/api/ter.api.asd /home/appl-user/.asdf/ter.api.asd
RUN ln -s /home/appl-user/prj/TER/core/ter.asd    /home/appl-user/.asdf/ter.asd


##### ################################################################
#####   Appl : Copy
##### ################################################################
# USER appl-user
# WORKDIR /home/appl-user/prj
# 
# RUN mkdir -p /home/appl-user/prj/TER
# 
# COPY --chown=appl-user:appl-users ./  /home/appl-user/prj/TER/
# 
# RUN ln -s /home/appl-user/prj/TER/api/ter.api.asd /home/appl-user/.asdf/ter.api.asd
# RUN ln -s /home/appl-user/prj/TER/core/ter.asd    /home/appl-user/.asdf/ter.asd
#
#
##### ################################################################
#####   Main
##### ################################################################
USER appl-user
WORKDIR /home/appl-user/prj/TER/docker

RUN mkdir -p /home/appl-user/var/log/TER

CMD ["./ter.sh"]
