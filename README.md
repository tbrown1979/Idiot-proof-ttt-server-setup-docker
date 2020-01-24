Idiot-proof TTT linux Server installation using Docker
===================================
Supporting Addons using Steam collections

## Before you begin

1. Go to the [Steam Workshop](https://steamcommunity.com/workshop/browse/?appid=4000&searchtext=ttt&childpublishedfileid=0&browsesort=trend&section=collections) and choose a collection you like.
You can also create your own.

2. Get an [Steam API Key](https://steamcommunity.com/dev/apikey) by entering anything to the Domain Field. (Email/Server IP or like, an actual domain that isn't in use already)

3. Get a Server with a linux installed on it (I'm using debian in this example).

# Your first start

You can use [this Guide](https://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers) to set up a safe server. Keep in mind that you have to allow ports 27015 and 27005.

Now that you have a secure server we can start. SSH on the server and [install docker](https://docs.docker.com/install/)
and wget:


```
~$ sudo apt-get install docker.io wget
```

I encourage you to find you more about Docker!

Now download my clean TTT image:

```
~$ sudo docker pull fosefx/ttt-server
```

It's 8GB+ big, so this might take a while

To create a customized version you first need to run the image with certain parameters.
To make it as easy as possible I wrote a script, you can download:

```
~$ wget https://raw.githubusercontent.com/FoseFx/Idiot-proof-ttt-server-setup-docker/master/run.sh
~$ chmod +x run.sh
```

First get the image's id using
```
~$ sudo docker images
```
And copy it. Now execute the script.
```
~$ sudo sh run.sh <imageID> <your API Key> <your collection's ID>
```

You can find your collections ID at the end of it's URL (`https://steamcommunity.com/sharedfiles/filedetails/?id=XXXXXXXXXX`)

Now this will take a while, depending on the amount of addons that need to be downloaded to the server.


When the last line prints something with `VAC` you can close the server again using `Ctrl + C`

## Change the config files
At this point in time you can edit the config files which are now in the following directory:

`/var/lib/docker/volumes/garrysmod/_data`
(you can change your directory using the `cd` command, `cd ..` will elevate you one folder level)

You can find examples all over the internet.

## Add Workshop.lua

Now locate this folder:

`/var/lib/docker/volumes/garrysmod/_data/lua/autorun/server`

And create a `workshop.lua` (`sudo touch /var/lib/docker/volumes/garrysmod/_data/lua/autorun/server/workshop.lua`).
Here you have to copy the output of [this generator in](https://csite.io/tools/gmod-universal-workshop).


(`cd ~` after that)
## Create a unique image

Create a [dockerhub](https://hub.docker.com) account and `sudo docker login` with your credentials.

Your Container should be listed here: `sudo docker container list -a`.

To create a unique image for your configuration type

```
~$ sudo docker commit <CONTAINER ID> <dockerhub username>/<some name>
```

Now push it to the docker hub where you can pull it from anytime.
```
~$ sudo docker push <dockerhub username>/<some name>
```

## Cleaning

1. Stop and remove the 'old' container
    - `sudo docker stop <containerID>`
    - `sudo docker rm <containerID>`
2. Remove the old image
    - get the image `sudo docker images`
    - remove it `sudo docker rmi <image ID>`
3. Remove the old Volume
    - `sudo docker volume rm garrysmod`
4. Start new Container
    - `sudo sh run.sh <new image's ID>`
    
## Attach

See nothing? That's good. The container is now in 'detached mode'. 
To interact with the console use
```
~$ sudo docker ps
~$ sudo docker attach <container ID>
```
### READ THIS FIRST!
Using `Ctrl + C` you will `Stop the server`!
When you want to detach from the container without stopping it use:
`Ctrl + P` followed by `Ctrl + Q`.

When you see your bash input you are safe to `exit`, the server will stay!

When the Server stopped you can restart it using
```
~$ sudo docker container -a
~$ sudo docker restart <image>
```

You can remove all containers using
```
sudo docker rm $(docker container list -q)
```

# Redeploy

So your server shut down or you want to start another one.
Because you now have a unique Docker Image uploaded to DockerHub
you just have to reinstall Docker, login and start the server.

```
~$ sudo apt-get install docker.io wget
~$ wget https://raw.githubusercontent.com/FoseFx/Idiot-proof-ttt-server-setup-docker/master/run.sh
~$ chmod +x run.s
```

Now use `docker login` again to login and then 
``` 
~$ sudo docker pull <dockerhub username>/<some name>
```

Start the server with `sudo sh run.sh <image ID>` and your done.


This Guide is based on [this repository](https://github.com/suchipi/gmod-server-docker/)

