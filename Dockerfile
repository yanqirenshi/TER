##### ################################################################
#####
#####  API サーバーのための Dockerfile
#####
#####   Build
#####   =====
#####    docker build -t ter -f Dockerfile .
#####
#####   Run
#####   ===
#####    docker run -it -d --name ter ter
#####    docker exec -it ter bash
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
# https://github.com/yanqirenshi/Dockerfiles/blob/master/Dockerfile.Base
FROM renshi/base


##### ################################################################
#####   Make Directory of glpgs-hooligan
##### ################################################################
USER cl-user
WORKDIR /home/cl-user

RUN mkdir -p /home/cl-user/prj/ter


##### ################################################################
#####   Copy project files & directories
##### ################################################################
USER cl-user
WORKDIR /home/cl-user

COPY --chown=cl-user:cl-users api/  /home/cl-user/prj/ter/api/
COPY --chown=cl-user:cl-users core/ /home/cl-user/prj/ter/core/


##### ################################################################
#####   Create Symbolic link
##### ################################################################
USER cl-user
WORKDIR /home/cl-user

RUN ln -s /home/cl-user/prj/ter/api/ter.api.asd /home/cl-user/.asdf/ter.api.asd
RUN ln -s /home/cl-user/prj/ter/core/ter.asd    /home/cl-user/.asdf/ter.asd


##### ################################################################
#####   Directories
##### ################################################################
USER cl-user
WORKDIR /home/cl-user

RUN echo 'export TER_API_SERVER=woo' >> ~/.bashrc
ENV TER_API_SERVER woo

RUN echo 'export TER_API_PORT=55555' >> ~/.bashrc
ENV TER_API_PORT 55555

RUN echo 'export TER_API_SESSION_NAME=ter.session' >> ~/.bashrc
ENV TER_API_SESSION_NAME ter.session

RUN echo 'export TER_DIR_GRAPH_COMMON=/home/cl-user/var/ter/graph/common' >> ~/.bashrc
ENV TER_DIR_GRAPH_COMMON /home/cl-user/var/ter/graph/common

RUN echo 'export TER_DIR_GRAPH_CAMPUS=/home/cl-user/var/ter/graph/campus' >> ~/.bashrc
ENV TER_DIR_GRAPH_CAMPUS /home/cl-user/var/ter/graph/campus

RUN echo 'export TER_DIR_GRAPH_SCHEMA=/home/cl-user/var/ter/graph/schema' >> ~/.bashrc
ENV TER_DIR_GRAPH_SCHEMA /home/cl-user/var/ter/graph/schema


##### ################################################################
#####   Start API Server
##### ################################################################
USER cl-user
WORKDIR /home/cl-user/prj/ter/api

ENTRYPOINT ["ros", "ter-api.ros"]
