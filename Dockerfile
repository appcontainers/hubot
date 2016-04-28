############################################################
# Dockerfile to build a Hubot NodeJS 4.2 Base Container
# Based on: node:4.2.4
# DATE: 12/29/2015
############################################################

# Set the base image in namespace/repo format. 
# To use repos that are not on the docker hub use the example.com/namespace/repo format.
FROM node:4.2.4

# File Author / Maintainer
MAINTAINER Rich Nason rnason@sciquest.com

###################################################################
#*************************  APP VERSIONS  *************************
###################################################################


###################################################################
#***************  OVERRIDE ENABLED ENV VARIABLES  *****************
###################################################################

# Standard Options
ENV OWNER hubot
ENV HUBOT_NAME hubot
ENV DESCRIPTION "Company Chat Robot"
ENV ADAPTER_NAME slack

# Slack Options
ENV HUBOT_SLACK_TOKEN ''
ENV HUBOT_SLACK_TEAM ''
ENV HUBOT_SLACK_NAME ''

# Google Options
ENV GTALK_API_KEY ''

# Hipchat Options
ENV HUBOT_HIPCHAT_TOKEN ''
ENV HUBOT_HIPCHAT_JABBERID ''
ENV HUBOT_HIPCHAT_NAME ''
ENV HUBOT_HIPCHAT_PASSWORD ''
ENV HUBOT_HIPCHAT_ROOMS ''

ENV WHITELIST_DOMAINS domain.tld 
ENV TERMTAG HUBOT

###################################################################
#******************  ADD REQUIRED APP FILES  **********************
###################################################################


###################################################################
#*******************  UPDATES & PRE-REQS  *************************
###################################################################


###################################################################
#**********************  CENTOS/RHEL  *****************************
###################################################################

# Update and install wget, so we can get the key
RUN apt-get -y update && \
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt-get -y install git make libssl-dev libexpat1-dev sudo vim && \

# Remove yum cache this bad boy can be 150MBish
apt-get clean && \
rm -fr /var/lib/apt/lists/*

###################################################################
#*******************  APPLICATION INSTALL  ************************
###################################################################

# Make a user for hubot (yo requires uid/gid 501)
RUN groupadd -g 501 hubot && \
useradd -m -u 501 -g 501 hubot && \
usermod -s /bin/bash hubot

ADD external-scripts.json /opt/hubot/external-scripts.modified
ADD pluginlist /opt/hubot/pluginlist

# Install npm
RUN npm cache clear && \
npm install -g npm@2 && \
npm install -g yo generator-hubot coffee-script node-gyp rebuild

# Set User Permissions
RUN chown -R hubot:hubot /home/hubot && \
chown -R hubot:hubot /opt/hubot

###################################################################
#******************  POST DEPLOY CLEAN UP  ************************
###################################################################

###################################################################
#*****************  CONFIGURE START ITEMS  ************************
###################################################################

ADD runconfig /tmp/.runconfig.sh

# Set boot items
RUN chmod 777 /tmp/.runconfig.sh && \
echo "/tmp/./.runconfig.sh" >> /root/.bashrc && \
echo "[ -f /tmp/.runconfig.sh ] && rm -fr /tmp/.runconfig.sh" >> /root/.bashrc

# Set the user to hubot
USER hubot

# Put the runconfig in the user profile as well
RUN echo "/tmp/./.runconfig.sh" >> /home/hubot/.bashrc && \
echo "[ -f /tmp/.runconfig.sh ] && rm -fr /tmp/.runconfig.sh" >> /home/hubot/.bashrc

WORKDIR /opt/hubot

RUN cd /opt/hubot && \
npm install hubot hubot-diagnostics hubot-help hubot-suggest \
hubot-hipchat node-xmpp-client node-xmpp-server node-xmpp-component hubot-slack hubot-gtalk \
hubot-redis-brain hubot-pugme hubot-rules hubot-shipit

CMD /bin/bash

###################################################################
#****************  EXPOSE APPLICATION PORTS  **********************
###################################################################

EXPOSE 8080

###################################################################
#*******************  OPTIONAL / LEGACY  **************************
###################################################################
