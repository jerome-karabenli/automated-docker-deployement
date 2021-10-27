# OUTPUT COLORING VARIABLES
green_text=`tput setaf 2`
red_text=`tput setaf 1`
reset_color=`tput sgr0`

# -----------------------------------------------------------------------------------------------------#
# VARIABLES PATERN
ssh_uri_pattern='^[a-zA-Z0-9_-]+@[a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9]+$'
env_pattern='^[dD][eE][vV]|^[pP][rR][oO][dD]'
true_pattern='^[tT].*|^[yY].*'
number_pattern='^[0-9]+$'
db_choice_pattern='^[mM]ongo|^[pP]ostgres'
string_underscore_dash_pattern='^[a-zA-Z_-]+$'
string_underscore_pattern='^[a-zA-Z_]+$'
string_underscore_only_lowercase_pattern='^[a-z_]+$'
cronjob_schedule_pattern='^([0-9\/\*,-]+ ){4}[0-9\/\*,-]+$'
path_pattern='^/[a-zA-Z0-9/_.\-]+$'
dev_pattern='^[dD][eE][vV]'
prod_pattern='^[pP][rR][oO][dD]'

#-------------------------------------------------------------------------------------------------------------------#
#Config file confirmation before run

source ./config.sh; 

if [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ $ENABLE_SEEDING =~ $true_pattern ]]; then 
        SEEDING_FILE_PATH=$(find ../api -name $SEEDING_FILE_NAME) 
    fi
    if [[ $ENABLE_SQITCH =~ $true_pattern ]]; then
        SQITCH_CONF_FILE_EXIST=$(find ../api -name sqitch.conf)
        SQITCH_CONF_FILE_PARENT_DIR=$(dirname -- "$SQITCH_CONF_FILE_EXIST")
    fi
ENV_FILE_EXIST=$(find ../api -name .env -o -name .ENV)
fi

# GLOBAL VARIABLES CHECK
[[ ! $ENV =~ $env_pattern ]] && echo "$red_text ENV MUST BE dev OR prod$reset_color" && exit
[[ -z $PROJECT_NAME ]] || [[ ! $PROJECT_NAME =~ $string_underscore_only_lowercase_pattern ]] && echo "$red_text PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ WITH NO SPACE AND WITHOUT NUMBER$reset_color" && exit

# FRONT VARIABLES CHECK
if [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $dev_pattern ]]; then
    [[ -z $FRONT_PORT ]] || [[ ! $FRONT_PORT =~ $number_pattern ]] && echo -e "$red_text\nFRONT PORT MUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

if [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then
    [[ -z $DOMAIN_NAME ]] && echo -e "$red_text\nIN PROD ENV DOMAIN NAME MUST BE PROVIDED$reset_color" && exit
fi

# BACK VARIABLES CHECK
if [[ $BUILD_BACK =~ $true_pattern ]]; then

    [ -z $ENV_FILE_EXIST ] && echo -e "$red_text\n ANY ENV FILE WAS FOUND WITH NAME .env or .ENV in api folder" && exit
    [[ ! $DB_CHOICE =~ $db_choice_pattern ]] && echo "$red_text DB CHOICE MUST BE mongo OR postgres$reset_color" && exit
    [[ -z $DB_USERNAME ]] || [[ -z $DB_PASSWORD ]] && echo "$red_text DB USERNAME AND DB PASSWORD MUST BE PROVIDED$reset_color" && exit
    [[ ! $DB_USERNAME =~ $string_underscore_dash_pattern ]] && echo -e "$red_text\nDB USERNAME ERROR \nMUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit    
    [ -z $(grep "$DB_URI_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $DB_URI_ENV_NAME ]] || [[ ! $DB_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text DB URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
    [ -z $(grep "$API_PORT_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $API_PORT_ENV_NAME ]] || [[ ! $API_PORT_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
    [[ -z $API_PORT ]] || [[ ! $API_PORT =~ $number_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

# REDIS VARIABLE CHECK
if [[ $BUILD_REDIS =~ $true_pattern ]]; then
    [ -z $(grep "$REDIS_URI_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $REDIS_URI_ENV_NAME ]] || [[ ! $REDIS_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text REDIS URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
fi

# SQITCH OPTION VARIABLES CHECK
if [[ $ENABLE_SQITCH =~ $true_pattern ]]; then
    [ -z $SQITCH_CONF_FILE_EXIST ] && echo -e "$red_text\n ANY sqitch.conf FILE WAS FOUND in api folder" && exit
fi

# SEEDING OPTION VARIABLES CHECK
if [[ $ENABLE_SEEDING =~ $true_pattern ]]; then
    [[ -z $SEEDING_FILE_PATH ]] && echo -e "$red_text\nSEEDING FILE NAME ERROR \nMUST BE EXISTING FILE in api folder$reset_color" && exit
fi

# DUMP CRON OPTION VARIABLES CHECK
if [[ $ENABLE_DUMP_CRON =~ $true_pattern ]]; then
    [[ ! $CRONJOB_SCHEDULE =~ $cronjob_schedule_pattern ]] && echo -e "$red_text\nCRON JOB SCHEDULE ERROR \nMUST BE VALID CRON SCHEDULE WITH NO SPACE$reset_color" && exit
    [[ ! $DELETE_OLDER_THAN_DAYS =~ $number_pattern ]] && echo -e "$red_text\nDELETE OLDER THAN DAYS ERROR \nMUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

# SSH BACKUP OPTION VARIABLES CHECK
if [[ $ENABLE_BACKUP_SSH =~ $true_pattern ]]; then
    [[ ! $BACKUP_SERVER_SSH_URI =~ $ssh_uri_pattern ]] && echo -e "$red_text\nSSH SERVER URI ERROR \nMUST BE VALID URI WITH NO SPACE$reset_color" && exit
    [[ ! $BACKUP_SERVER_SSH_PORT =~ $number_pattern ]] && echo -e "$red_text\nSSH PORT ERROR \nMUST BE NUMBER WITH NO SPACE$reset_color" && exit
    [[ ! $PATH_ON_BACKUP_SERVER =~ $path_pattern ]] && echo -e "$red_text\nBACKUP SERVER PATH ERROR \nMUST BE VALID ABSOLUTE PATH AND NOT ROOT /$reset_color" && exit
fi 


if [[ $ENV =~ $dev_pattern ]]; then
    while true; do
        read -p "demo mode ? It works only in local env y/n " yn
        case $yn in
            [Yy]* ) DEMO_MODE="true"; break;;
            [Nn]* ) DEMO_MODE="false"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi


#---------------------------------------------------------------------------------------------------------------------------#
# DO NOT TOUCH THIS VARIABLE
mongo_pattern='^[mM]ongo'
postgres_pattern='^[pP]ostgres'

if [[ $DB_CHOICE =~ $mongo_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@mongo:27017/admin"
elif [[ $DB_CHOICE =~ $postgres_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@postgres:5432/$DB_USERNAME"
fi



#-------------------------------------------------------------------------------------------------------------
# .env FILES POPULATION FOR docker-compose.yml
if [[ ! -d ./environement ]]; then mkdir ./environement; fi
[ $? -ne 0 ] && echo -e "$red_text\nenvironement folder creation error, try to create folder by yourself and try again$reset_color" && exit


if [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ $BUILD_REDIS =~ $true_pattern ]]; then
        echo -e "$REDIS_URI_ENV_NAME=redis://redis:6379\n$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    else
        echo -e "$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    fi

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then
        echo -e "$DB_URI_ENV_NAME=postgres://$DB_URI" >> ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit

        echo -e "POSTGRES_USER=$DB_USERNAME\nPOSTGRES_PASSWORD=$DB_PASSWORD" > ./environement/.db.env
        [ $? -ne 0 ] && echo -e "$red_text\ndb env file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./environement/.db.env ] && [ ! -s ./environement/.db.env ] && echo "$red_text ERROR on population of environnement/.db.env file$reset_color" && exit
    
    elif  [[ $DB_CHOICE =~ $mongo_pattern ]]; then

        echo -e "$DB_URI_ENV_NAME=mongo://$DB_URI" >> ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit

        echo -e "MONGO_INITDB_ROOT_USERNAME=$DB_USERNAME\nMONGO_INITDB_ROOT_PASSWORD=$DB_PASSWORD" > ./environement/.db.env
        [ $? -ne 0 ] && echo -e "$red_text\ndb env file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./environement/.db.env ] && [ ! -s ./environement/.db.env ] && echo "$red_text ERROR on population of environnement/.db.env file$reset_color" && exit

    fi  

    if [[ $ENV =~ $prod_pattern ]]; then 
        echo -e "NODE_ENV=production" >> ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    else
        echo " " >> ./environement/.api.env && sed -i '4c NODE_ENV=' ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    fi

fi

#-------------------------------------------------------------------------------------------------------------
# DEPLOYEMENT


# API DEPLOYEMENT 
if [[ $BUILD_BACK =~ $true_pattern ]]; then

    sed -i "42c\        - $API_PORT:$API_PORT" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit

    if [[ $BUILD_REDIS =~ $true_pattern ]]; then
        docker-compose -p $PROJECT_NAME up -d redis
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME down -v && docker rmi -f api_dev && exit 
    fi

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then

        docker-compose -p $PROJECT_NAME up -d postgres
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME down -v && docker rmi -f api_dev && exit 

        POSTGRES_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep postgres | awk '{print $1}')    

    elif [[ $DB_CHOICE =~ $mongo_pattern ]];then

        docker-compose -p $PROJECT_NAME up -d mongo
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME down -v && docker rmi -f api_dev && exit 
    
        MONGO_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep mongo | awk '{print $1}')    

    fi    

    if [[ $ENV =~ $dev_pattern ]]; then

        sed -i "37c\        target: dev" docker-compose.yml
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit
        
        docker-compose -p $PROJECT_NAME up -d api
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured when restarting api_dev service in compose file$reset_color" && exit    

        echo -e "$green_text\nAPI DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $API_PORT$reset_color"

    elif [[ $ENV =~ $prod_pattern ]];then

        sed -i "37c\        target: prod" docker-compose.yml
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit        
        
        docker-compose -p $PROJECT_NAME up -d api
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured when restarting api_dev service in compose file$reset_color" && exit    

        docker image prune --filter label=stage=api_dev --force
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

        docker rmi node:lts-alpine
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        

        echo -e "$green_text\nAPI DEPLOYED ON PRODUCTION ENV WITH SUCCESS ON PORT $API_PORT$reset_color"
    fi 


fi

# FRONT DEPLOYEMENT
if [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $dev_pattern ]]; then

    sed -i "48c\        target: dev" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit
            
    sed -i "50c\        - $FRONT_PORT:80" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev setting port in compose file$reset_color" && exit    

    if [[ -n $(sed -n 51p docker-compose.yml | grep 443) ]]; then sed -i '51d' docker-compose.yml; fi

    docker-compose -p $PROJECT_NAME up -d front
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME rm -sf front_dev && exit    

    echo -e "$green_text\nFRONT DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $FRONT_PORT$reset_color"
elif [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then

    sed -i "4c\    server_name $DOMAIN_NAME;" nginx/nginx.prod.conf
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev setting port in compose file$reset_color" && exit    

    sed -i "48c\        target: prod" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit    

    sed -i "50c\        - 80:80\n        - 443:443" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev setting port in compose file$reset_color" && exit 

    docker-compose -p $PROJECT_NAME up -d front
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

    docker image prune --filter label=stage=front_dev --force
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

    docker rmi nginx:stable-alpine
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

    echo -e "$green_text\nFRONT DEPLOYED ON PROD ENV WITH SUCCESS ON PORT 80 AND 443$reset_color"

fi

if [[ $DEMO_MODE =~ $true_pattern ]]; then

    FRONT_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep front | awk '{print $1}')      
    API_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep api | awk '{print $1}')  

    FRONT_CONTAINER_IP=$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{.IPAddress}}{{end}}' $FRONT_CONTAINER_NAME)
    
    API_CONTAINER_IP=$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{.IPAddress}}{{end}}' $API_CONTAINER_NAME)
        
    docker exec -it $FRONT_CONTAINER_NAME sh -c 'sed -i "44c\    <h3>Front container ip $(hostname -i)</h3>" /bin/www/index.html && sed -i "45c\    <h3>Front container id $(hostname)</h3>" /bin/www/index.html'  
    docker exec -it $FRONT_CONTAINER_NAME sh -c "sed -i '8c\            const apiUrl = \"$API_CONTAINER_IP\"' /bin/www/index.html" 
    docker exec -it $FRONT_CONTAINER_NAME sh -c "sed -i '9c\            const apiPort = $API_PORT' /bin/www/index.html" 


fi


#------------------------------------------------------------------------------------------------------------
#OPTIONS

# SETUP SQITCH TO DEPLOY DATABASE STRUCTURE
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_SQITCH =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]] && [[ $DB_CHOICE =~ $postgres_pattern ]]; then

    POSTGRES_CONTAINER_IP=$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{.IPAddress}}{{end}}' $POSTGRES_CONTAINER_NAME)
    [ $? -ne 0 ] || [[ -z $POSTGRES_CONTAINER_IP ]] && echo -e "$red_text\nGet postgres container ip ERROR$reset_color" && exit    
    
    ACTUAL_ABSOLUTE_PATH=$(realpath .)
    [ $? -ne 0 ] || [[ -z $ACTUAL_ABSOLUTE_PATH ]] && echo -e "$red_text\nGet absolute path of docker folder ERROR$reset_color" && exit    

    curl -s -L https://git.io/JJKCn -o sqitch > /dev/null && chmod +x sqitch && mv sqitch $SQITCH_CONF_FILE_PARENT_DIR && cd $SQITCH_CONF_FILE_PARENT_DIR && ./sqitch target add docker db:pg://$DB_USERNAME:$DB_PASSWORD@$POSTGRES_CONTAINER_IP:5432/$DB_USERNAME && ./sqitch deploy docker && ./sqitch target remove docker && rm sqitch && cd $ACTUAL_ABSOLUTE_PATH
    [ $? -ne 0 ] && echo -e "$red_text\nsqitch execution error, try to create file by yourself and try again$reset_color" && exit
     
    if [[ $ENV =~ $prod_pattern ]]; then docker rmi sqitch/sqitch:latest > /dev/null; fi

    echo -e "$green_text\nDATABASE STRUCTURE DEPLOYEMENT WITH SQITCH SUCCESSFULLY DONE$reset_color"
else echo "sqitch option not used"
fi


# SETUP SEEDING OPTION
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_SEEDING =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then
      
        docker cp $SEEDING_FILE_PATH $POSTGRES_CONTAINER_NAME:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of seeding file inside postgres database container$reset_color" && exit
   
        docker exec -i $POSTGRES_CONTAINER_NAME sh -c "psql -f /$SEEDING_FILE_NAME postgres://$DB_URI && rm /$SEEDING_FILE_NAME"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of seeding file inside postgres database container$reset_color" && exit

        echo -e "$green_text\nPOSTGRESQL DATABASE SEEDING SUCCESSFULLY DONE$reset_color"  
    else
        docker cp $SEEDING_FILE_PATH $MONGO_CONTAINER_NAME:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of seeding file inside postgres database container$reset_color" && exit
   
        docker exec -i $MONGO_CONTAINER_NAME sh -c "mongorestore -f /$SEEDING_FILE_NAME postgres://$DB_URI && rm /$SEEDING_FILE_NAME"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of seeding file inside postgres database container$reset_color" && exit

        echo -e "$green_text\nMONGODB DATABASE SEEDING SUCCESSFULLY DONE$reset_color"   
    fi
else echo "seeding option not used"
fi


# SETUP CRON SCHEDULING DB DUMP OPTION
if [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ ! -d ./modules ]]; then mkdir ./modules; fi
    [ $? -ne 0 ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit
    [ ! -d ./modules ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit


    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then

        echo -e "DATE=\$(date +%F-%H_%M)\n/usr/bin/pg_dump postgres://$DB_URI >> /home/postgres_$PROJECT_NAME\_\$DATE.sql\n/usr/bin/find /home/ -type f -mtime +$DELETE_OLDER_THAN_DAYS -exec rm -- '{}' \;" > ./modules/cron.sh
        [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit

        sed -i "3c RUN apk add --update --no-cache postgresql-client && rm  -rf /tmp/* /var/cache/apk/* > /dev/null" ./dockerFiles/utils.Dockerfile
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    

    else
        echo -e "DATE=\$(date +%F-%H_%M)\n/usr/bin/mongodump mongo://$DB_URI >> /home/mongo_$PROJECT_NAME\_\$DATE.json\n/usr/bin/find /home/ -type f -mtime +$DELETE_OLDER_THAN_DAYS -exec rm -- '{}' \;" > ./modules/cron.sh
        [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit

        sed -i "3c RUN apk add --update --no-cache mongo-client && rm  -rf /tmp/* /var/cache/apk/* > /dev/null" ./dockerFiles/utils.Dockerfile
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    
   
    fi 



    sed -i "4c COPY ./docker/modules/cron.sh ." ./dockerFiles/utils.Dockerfile
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit 

    echo " " >> ./dockerFiles/utils.Dockerfile
    sed -i "5c RUN echo \"$CRONJOB_SCHEDULE /root/cron.sh >> /root/cron.log\" > cron.txt && /usr/bin/crontab cron.txt && rm cron.txt && chmod 755 cron.sh" ./dockerFiles/utils.Dockerfile
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    
   


else echo "cron dump option not used"
fi


#SETUP SENDING DUMPED BACKUP FILE OVER SSH IF TRUE
if [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_BACKUP_SSH =~ $true_pattern  ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ -n $BACKUP_SERVER_SSH_PASSWORD ]]; then

    echo " " >> ./modules/cron.sh && sed -i "4c  /usr/bin/sshpass -p $BACKUP_SERVER_SSH_PASSWORD /usr/bin/rsync -aqrhe \"/usr/bin/ssh -o StrictHostKeyChecking=no -p $BACKUP_SERVER_SSH_PORT\" /home/ $BACKUP_SERVER_SSH_URI:$PATH_ON_BACKUP_SERVER" ./modules/cron.sh
    [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit

    echo " " >> ./dockerFiles/utils.Dockerfile
    sed -i "7c RUN apk add --update --no-cache openssh-client rsync sshpass && rm  -rf /tmp/* /var/cache/apk/* > /dev/null" ./dockerFiles/utils.Dockerfile
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    

    echo -e "timeout 3 sh -c 'sshpass -p $BACKUP_SERVER_SSH_PASSWORD ssh -o StrictHostKeyChecking=no -p $BACKUP_SERVER_SSH_PORT -q $BACKUP_SERVER_SSH_URI exit'; if [[ \$? -ne 0 ]]; then echo 'CANNOT ESTABLISH CONNECTION' && exit 1; else echo 'CONNECTION ESTABLISHED' && exit 0; fi
    " > ./modules/ssh-check.sh
    [ $? -ne 0 ] && echo -e "$red_text\nssh-check module file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./modules/ssh-check.sh ] && [ ! -s ./modules/ssh-check.sh ] && echo -e "$red_text\nssh-check module file creation error, try to create file by yourself and try again$reset_color" && exit

    else

    echo " " >> ./modules/cron.sh && sed -i "4c  /usr/bin/rsync -aqrhe \"/usr/bin/ssh -o StrictHostKeyChecking=no -p $BACKUP_SERVER_SSH_PORT\" /home/ $BACKUP_SERVER_SSH_URI:$PATH_ON_BACKUP_SERVER" ./modules/cron.sh
    [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit

    echo " " >> ./dockerFiles/utils.Dockerfile
    sed -i "7c RUN apk add --update --no-cache openssh-client rsync && rm  -rf /tmp/* /var/cache/apk/* > /dev/null && echo | ssh-keygen -P ''" ./dockerFiles/utils.Dockerfile
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    

    echo -e "timeout 3 sh -c 'ssh -o StrictHostKeyChecking=no -p $BACKUP_SERVER_SSH_PORT -q $BACKUP_SERVER_SSH_URI exit'; if [[ \$? -ne 0 ]]; then echo 'CANNOT ESTABLISH CONNECTION' && exit 1; else echo 'CONNECTION ESTABLISHED' && exit 0; fi
    " > ./modules/ssh-check.sh
    [ $? -ne 0 ] && echo -e "$red_text\nssh-check module file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./modules/ssh-check.sh ] && [ ! -s ./modules/ssh-check.sh ] && echo -e "$red_text\nssh-check module file creation error, try to create file by yourself and try again$reset_color" && exit

    fi


    echo " " >> ./dockerFiles/utils.Dockerfile
    sed -i "8c COPY ./docker/modules/ssh-check.sh ." ./dockerFiles/utils.Dockerfile
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on setting run command in utils dockerfile file$reset_color" && exit    

    docker-compose -p $PROJECT_NAME up -d utils > /dev/null
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on starting utils service with build of utils image$reset_color" && exit    
    UTILS_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep utils | awk '{print $1}')

    echo -e "$green_text\nCRON SCHEDULE FOR DB DUMP SUCCESSFULLY DONE$reset_color"

    if [[ -z $BACKUP_SERVER_SSH_PASSWORD ]]; then

        echo "${green_text}COPY THIS KEY INTO YOUR authorized_keys FILE${reset_color}"
        echo "${green_text}----------------------------------------------------------------------------"
        docker exec -it $UTILS_CONTAINER_NAME sh -c "cat ~/.ssh/id_rsa.pub"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on starting utils service with build of utils image$reset_color" && exit    

        echo "----------------------------------------------------------------------------${reset_color}"

        while true; do
            read -p "Type yes when key is copied ?  " yn
            case $yn in
                [Yy]* ) break;;
            * ) echo "Please answer yes or no.";;
            esac
        done
    fi 

    docker exec -it $UTILS_CONTAINER_NAME sh -c "sh /root/ssh-check.sh" > /dev/null
    if [ $? -ne 0 ]; then
        echo "${red_text}SSH CONNECTION CANNOT BE ESTABLISHED WITH YOUR BACKUP SERVER${reset_color}"
    else
        echo "${green_text}SSH CONNECTION ESTABLISHED WITH YOUR BACKUP SERVER${reset_color}"
    fi

elif [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern  ]] && [[ ! $ENABLE_BACKUP_SSH =~ $true_pattern  ]]; then
    sed -i "8d" ./dockerFiles/utils.Dockerfile
    sed -i "7d" ./dockerFiles/utils.Dockerfile
    sed -i "4d" ./modules/cron.sh

    docker-compose -p $PROJECT_NAME up -d utils > /dev/null
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on starting utils service with build of utils image$reset_color" && exit    
    UTILS_CONTAINER_NAME=$(docker-compose -p $PROJECT_NAME ps | grep utils | awk '{print $1}')

    echo -e "$green_text\nCRON SCHEDULE FOR DB DUMP SUCCESSFULLY DONE$reset_color" 

else echo "ssh server backup option not used"
fi

if [[ $ENV =~ $prod_pattern ]] && [[ $ENABLE_OPTIONS =~ $true_pattern ]]; then
    docker rmi alpine:latest
fi


if [[ ! $ENABLE_OPTIONS =~ $true_pattern ]] || [[ ! $ENABLE_DUMP_CRON =~ $true_pattern ]]; then

    DUMP_FILES_VOLUME_NAME=$(docker volume ls | grep $PROJECT_NAME.dump | awk '{print $2}')
  
    docker volume rm $DUMP_FILES_VOLUME_NAME > /dev/null
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on removing unused volumes$reset_color" && exit    

fi
