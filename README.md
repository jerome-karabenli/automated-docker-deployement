# AUTOMATED API/FRONTEND DEPLOYEMENT WITH DOCKER 

### USED TOOLS
<p float="left">
<img width="55" src="https://raw.githubusercontent.com/devicons/devicon/2ae2a900d2f041da66e950e4d48052658d850630/icons/bash/bash-original.svg" alt="nodejs logo" />
<img width="50" src="https://raw.githubusercontent.com/devicons/devicon/9f4f5cdb393299a81125eb5127929ea7bfe42889/icons/docker/docker-original-wordmark.svg" alt="docker logo" />
<img width="55" src="https://raw.githubusercontent.com/devicons/devicon/7a4ca8aa871d6dca81691e018d31eed89cb70a76/icons/nodejs/nodejs-original-wordmark.svg" alt="nodejs logo" />
<img width="50" src="https://raw.githubusercontent.com/devicons/devicon/7a4ca8aa871d6dca81691e018d31eed89cb70a76/icons/express/express-original-wordmark.svg" alt="express logo" />
<img width="50" src="https://raw.githubusercontent.com/devicons/devicon/7a4ca8aa871d6dca81691e018d31eed89cb70a76/icons/mongodb/mongodb-original-wordmark.svg" alt="mongodb logo" />
<img width="50" src="https://raw.githubusercontent.com/devicons/devicon/2ae2a900d2f041da66e950e4d48052658d850630/icons/postgresql/postgresql-original-wordmark.svg" alt="docker logo" />
<img width="50" src="https://raw.githubusercontent.com/devicons/devicon/2ae2a900d2f041da66e950e4d48052658d850630/icons/redis/redis-original-wordmark.svg" alt="docker logo" />
<img height="50" width="60" src="https://sqitch.org/img/sqitch-logo.svg" alt="docker logo" />
<img height="50" width="70" src="https://www.linode.com/wp-content/uploads/2021/01/Linode-Logo-Black.svg" alt="docker logo" />

</p>

### WHAT IS THIS PROJECT
This is a personnal project, I made this for learning __bash scripting__ and have deeper knowledges with __[docker](https://docs.docker.com/get-docker/)__. And also for my personal usage for deployement.

I wanted to be able to deploy quickly and securly any API or frontend with simple conf file. 

This is thinked for __[nodeJS](https://nodejs.org/en/)__ backend and __[postgresql](https://www.postgresql.org/)__ or __[mongodb](https://www.mongodb.com/fr-fr)__ database and optionnaly with __[redis](https://redis.io/)__ database for caching. 

I made this project in 1 week, I learned bash scripting in same time, before this my knowledges about bash was very limited. It's not perfect or usable in prod env I guess but it works ! 

### WHAT DOES THIS PROJECT
#### MAIN
- API deployement using nodeJS
- frontend deployement using nginx container
- database deployement (mongo or postgres and/or redis)

#### OPTIONAL MODULES
All optional modules are included in project and can be activated with conf file
- [sqitch](https://sqitch.org/) for sql database versioning
- database seeding (works on both mongo and postgres)
- scheduled backup for database with cron
- sending database dump files over ssh to another server for storage and security

### TESTED OS ENV

- ubuntu 21.04
- debian 10
- macos BigSur (you need to have homebrew installed to be able to install [coreutils](https://formulae.brew.sh/formula/coreutils) and [gnu_sed](https://formulae.brew.sh/formula/gnu-sed))

I also test on cloud with debian 10 vm with [linode](https://www.linode.com/)

### PREREQUIST
- have docker engine or desktop installed
- have some dev skills
- your api files/folder must be in `api` folder
- your frontend build files must be in `front/build` folder
- if you want to use it with ssl certs, they must be in `ssl` folder
  

### HOW ITS WORKS
- You just need to populate `conf.sh` file, there is a lot of comments in this file for help. 
- Need to be in `docker` folder and type `bash automated-docker-deploy.sh` or `sudo bash automated-docker-deploy.sh` in case of your docker installation need `sudo`
 
Just be careful with __`.dockerignore`__ file, not forgot to adapt it for your usage.

It's my first bash script, so it's not perfect at all ! 

If you have any suggestion feel free to open an issue. 