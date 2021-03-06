## Debian based Customizable Hubot Container - 779 MB - Updated 05/10/2016

***This container is built from node:4.2.4***  
***This build must run off of nothing higher than node 4.2, running the build on node 5 / npm3 breaks dependancies (stringprep, hubot-hipchat)***

># Description:

***Hubot is your company's robot. Install him in your company to dramatically improve and reduce employee efficiency.***

GitHub, Inc., wrote the first version of Hubot to automate their company chat room. Hubot knew how to deploy the site, automate a lot of tasks, and be a source of fun in the company. Eventually he grew to become a formidable force in GitHub. But he led a private, messy life. So github rewrote him.

Today's version of Hubot is open source, written in CoffeeScript on Node.js, and easily deployed on platforms like Heroku. More importantly, Hubot is a standardized way to share scripts between everyone's robots.

[Official Hubot Site:](https://hubot.github.com)
[Github repository of this build:](https://github.com/appcontainers/hubot)

This containers purpose is to get a customizable hubot instance up and running with a single docker run statement. The container is built with environment variables that allow the user to plug in custom values which will allow the container to configure itself on first run. This will give the user a fully customized experience just as if you set up hubot on your own from scratch. The image has the gtalk, slack and hipchat adapters installed to allow integration into these 3 main chat systems.


># Container Variables:

The container is built to allow several configurable variables to be passed in at run time. The values are as follows:

### Standard Options
 - OWNER - This is the user on the system that owns the hubot binary / directories. It should run off the hubot user.
 - HUBOT_NAME - This is the name that you choose for your hubot chat robot
 - DESCRIPTION - Quick description of what your robot is or what it will do.
 - ADAPTER_NAME - This is the adapater that hubot will use to connect to your chat service. gtalk, slack, and hipchat are built in
 - WHITELIST_DOMAINS - Domain list allowed to connect to the listening hubot interface on the hubot server.

### Slack Options
 - HUBOT_SLACK_TOKEN - The token generated on slack that hubot will use to connect to your slack service
 - HUBOT_SLACK_TEAM - The team that hubot will be part of when connected to your slack service. This is your team.slack.com team name.
 - HUBOT_SLACK_NAME - The name of the slack user that hubot will bind to in your chat service.

### Google Options
- GTALK_API_KEY - The token generated on google that hubot will use to connect to your gtalk service

### Hipchat Options
- HUBOT_HIPCHAT_TOKEN - The token generated on hipchat that hubot will use to connect to the hipchat service
- HUBOT_HIPCHAT_JABBERID - The user id (id@chat.hipchat.com) identifier that tells hubot what hipchat user to bind to
- HUBOT_HIPCHAT_NAME - The name of the hipchat user that hubot will bind to in your chat service.
- HUBOT_HIPCHAT_PASSWORD - The password of the created hipchat user that hubot will use to connect to the hipchat service
- HUBOT_HIPCHAT_ROOMS - The room listing that hubot will be added to in your hipchat service.


># Running the Container to connect to slack:

```bash
docker run -d -it \
--name hubot -h hubot \
--restart always \
-p 8008:8008 \
-e ADAPTER_NAME=slack \
-e HUBOT_SLACK_TOKEN=paste_token_here \
-e HUBOT_SLACK_TEAM=paste_your_team_here \
-e HUBOT_SLACK_NAME=paste_slack_hubot_user_here \
appcontainers/hubot
```


># Running the Container to connect to hipchat:

```bash
docker run -d -it \
--name hubot -h hubot \
--restart always \
-p 8008:8008 \
-e ADAPTER_NAME=hipchat \
-e HUBOT_HIPCHAT_TOKEN=paste_token_here \
-e HUBOT_HIPCHAT_JABBERID=paste_your_hipchatuser_id@chat.hipchat.com_id_here \
-e HUBOT_HIPCHAT_NAME=paste_hipchat_hubot_user_here \
-e HUBOT_HIPCHAT_PASSWORD=paste_hipchat_user_password_here \
appcontainers/hubot
```

*These examples will assume the following*

- OWNER = hubot
- HUBOT_NAME = hubot
- DESCRIPTION = "Company Chat Robot"

Setting any of the above values will tell the container to replace the default values already set within the container with the values that are supplied at runtime. For example, if you pass in -e HUBOT_NAME=tester then hubot will be pre named and respond as tester instead of hubot.

These examples will start a new container named hubot. The restart policy will be set to always, meaning that if the container crashes unexpectedly, it will automatically kick itself back off. At this point your app is fully configured and you need just check your chat service to ensure that the hubot user has connected successfully. Once connected you can test that the chat robot is working correctly by typing @hubot ping in a chat channel. Hubot should respond with the message Pong.


># Included Scripts:

The following scripts are built into hubot with this build

 - hubot-diagnostics - Hubot scripts for diagnosing hubot
 - hubot-help - Allow hubot to show you all available installed script options by typing hubot help
 - hubot-suggest - If you send hubot a PM with something it doesn not understand, it will offer suggestions.
 - hubot-hipchat - Hubot HipChat Connector
 - hubot-slack - Hubot Slack Connector
 - hubot-gtalk - Hubot Google Talk Connector
 - hubot-redis-brain - Allows hubot to communicate with a redis instance. If redis is not set up, it will run a local instance.
 - hubot-pugme - Extends hubot to send a pug image if you type @hubot pug me
 - hubot-rules - Extends hubot to send back robot rules by typing @hubot the rules
 - hubot-shipit - Extends hubot to send back a ship it squirrel meme by typing @hubot ship it
 - hubot-yourface - Extends hubot to randomly respond with your face digs at users based on what they were chatting about
 - hubot-codinglove - Extends hubot to pull random development memes when typing @hubot joy or @hubot love
 - hubot-humanity - Extends hubot to dish out cards against humanity phrases when typing @hubot card me or @hubot card 2
 - hubot-meme - Extends hubot to eaily allow meme generation by typing the content of the meme such as @hubot one does not simply create a meme
 - hubot-gitlab - Extends hubot to control and gather data from an installed and configured gitlab instance
 - hubot-jenkins - Extends hubot to control and gather data from an installed and configured jenkins instance.

># Adding additional functionality scripts to hubot:

There are 2 ways to extend hubot functionality, one with new scripts built in, the other ad hoc while the contianer is already up and running.

># Building a new docker image with custom scripts:

Fork this project on github https://github.com/appcontainers/hubot and add the scripts you would like to include in the pluginlist file.
Next, open the external-scripts.json file, and add the scripts to the json list.
Thats it!! now build your new container image with `docker build -t yourcompany/hubot` .
This will give you a new docker container with all of your scripts already included and installed.

># Adding custom scripts to an existing container:

Attach to hubot by using `docker exec -it -u root hubot /bin/bash` and hitting enter twice. Hit `CTL C` to kill the running hubot process. Navigate to the hubot folder /opt/hubot. Find the module for the script that you would like to add on the NPM site, and install the module by typing npm install hubot-script_name. Once npm installs the script, then edit the "external-scripts.json" file, and adding the newly installed script to the end of the list. Don't forget to add a comma to the element above the new entry. Every element in the json array should have a value except for the last value.

```json
[
  "hubot-help",  
  "hubot-diagnostics",
  "hubot-suggest",
  "hubot-rules",
  "hubot-redis-brain",
  "hubot-pugme",
  "hubot-shipit",
  "hubot-script_name"
]
```

Once completed, you can restart hubot by running `bin/hubot --adapter $ADAPTER_NAME`. That should run the hubot process again with the newly installed extension script. At this point you can exit the container. DO not type exit (which would shut down the container), but instead use the detach key combination of `CTL P` + `CTL Q`.

># Launching the Container via docker-compose:

Copy the text below and paste it into a file named docker-compose.yml. Then you can navigate to the directory and provided that you have docker-compose installed, just issue the following command in order to launch off the application stack:

#### Remember to substitute your chat service values with the value examples in the compose syntax below before running it.

`docker-compose up -d`

__NOTE: If you need assistance setting up docker-compose please visit [http://www.appcontainers.com](http://www.appcontainers.com/installing-and-deploying-containers-using-docker-compose/) to watch the tutorial or read about the installation process.__

>## Slack:

```bash
robot:
  image: appcontainers/hubot
  hostname: hubot
  mem_limit:2048m
  stdin_open: true
  tty: true
  restart: always
  ports:
  - "8008:8008"
  environment:
  - OWNER=hubot
  - HUBOT_NAME=HUBOT
  - DESCRIPTION=Resistance is futile....
  - ADAPTER_NAME=slack
  - HUBOT_SLACK_TOKEN=1234-12345678910-abcd1234efghijklmn56opqr
  - HUBOT_SLACK_TEAM=your-team
  - HUBOT_SLACK_NAME=Hubot
  - GTALK_API_KEY=''
  - HUBOT_HIPCHAT_TOKEN=''
  - HUBOT_HIPCHAT_JABBERID=''
  - HUBOT_HIPCHAT_NAME=''
  - HUBOT_HIPCHAT_PASSWORD=''
  - HUBOT_HIPCHAT_ROOMS=''
  - HUBOT_JENKINS_URL=http://jenkins.yourcompany.tld:8080
  - HUBOT_JENKINS_AUTH=hubot:hubot123456
  - HUBOT_GITLAB_URL=http://gitlab.yourcompany.tld
  - HUBOT_GITLAB_ACCESSKEY=gitlab_access_key_here
  - WHITELIST_DOMAINS=''
```

>## Hipchat:

```bash
rebot:
  image: appcontainers/hubot
  hostname: hubot
  mem_limit:2048m
  stdin_open: true
  tty: true
  restart: always
  ports:
  - "8008:8008"
  environment:
  - OWNER=hubot
  - HUBOT_NAME=HUBOT
  - DESCRIPTION=Resistance is futile....
  - ADAPTER_NAME=hipchat
  - SLACK_ADAPTER_TOKEN=''
  - SLACK_TEAM=''
  - SLACK_BOT_NAME=''
  - GTALK_API_KEY=''
  - HUBOT_HIPCHAT_TOKEN=1234567890123abcdefghijklmnopq
  - HUBOT_HIPCHAT_JID=12345_1234567@chat.hipchat.com
  - HUBOT_HIPCHAT_NAME=hubot
  - HUBOT_HIPCHAT_PASSWORD=123456789101
  - HUBOT_HIPCHAT_ROOMS=''
  - HUBOT_JENKINS_URL=http://jenkins.yourcompany.tld:8080
  - HUBOT_JENKINS_AUTH=hubot:hubot123456
  - HUBOT_GITLAB_URL=http://gitlab.yourcompany.tld
  - HUBOT_GITLAB_ACCESSKEY=gitlab_access_key_here
  - WHITELIST_DOMAINS=''
```


__NOTE: The hipchat JID is a combination of your company identifier along with the hubot user id which can be found on the hipchat web site when you are logged in.__


># Dockerfile Change-log:

    01/09/2016 - Hubot Container Created
    05/10/2016 - Added scripts and method to easily add new scripts.


># Verification

```bash
------------------------
Test Standalone Version
------------------------
docker run -it \
--name hubot \
-h hubot \
-p 8008:8008 \
appcontainers/hubot

# Attach to container and navigate to /opt/hubot/bin
hubot
```
