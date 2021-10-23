green_text=`tput setaf 2`
red_text=`tput setaf 1`
reset_color=`tput sgr0`

# -----------------------------------------------------------------------------------------------------#
# VARIABLE PATERN
ssh_uri_pattern='^[a-zA-Z0-9_-]+@[a-zA-Z0-9_\-\.]+\.[a-zA-Z]+$'
env_pattern='^[dD][eE][vV]|^[pP][rR][oO][dD]'
true_pattern='^[tT].*|^[yY].*'
number_pattern='^[0-9]+$'
db_choice_pattern='^[mM]ongo|^[pP]ostgres'
string_underscore_dash_pattern='^[a-zA-Z_-]+$'
string_underscore_pattern='^[a-zA-Z_]+$'
string_underscore_only_lowercase_pattern='^[a-z_]+$'
cronjob_schedule_pattern='^([0-9\/\*,-]+ ){4}[0-9\/\*,-]+$'
path_pattern='^/[a-zA-Z0-9/_.\-]+$'


#-------------------------------------------------------------------------------------------------------------------#
#Config file confirmation before run

source ./config.sh; 

SEEDING_FILE_PATH=$(find ../api -name $SEEDING_FILE_NAME)
SQITCH_FOLDER_PATH=$(find ../api -name $SQITCH_MIGRATIONS_FOLDER_NAME)
SQITCH_PLAN_FILE_EXIST=$(find ../api -name sqitch.plan)
ENV_FILE_EXIST=$(find ../api -name .env -o -name .ENV)

[[ ! $ENV =~ $env_pattern ]] && echo "$red_text ENV MUST BE dev OR prod$reset_color" && exit
[[ -z $PROJECT_NAME ]] || [[ ! $PROJECT_NAME =~ $string_underscore_only_lowercase_pattern ]] && echo "$red_text PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ WITH NO SPACE AND WITHOUT NUMBER$reset_color" && exit

if [[ $BUILD_FRONT =~ $true_pattern ]]; then
    [[ -z $FRONT_PORT ]] || [[ ! $FRONT_PORT =~ $number_pattern ]] && echo -e "$red_text\nFRONT PORT MUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

if [[ $BUILD_BACK =~ $true_pattern ]]; then

    [ -z $ENV_FILE_EXIST ] && echo -e "$red_text\n ANY ENV FILE WAS FOUND WITH NAME .env or .ENV in api folder" && exit
    [[ ! $DB_CHOICE =~ $db_choice_pattern ]] && echo "$red_text DB CHOICE MUST BE mongo OR postgres$reset_color" && exit
    [[ -z $DB_USERNAME ]] || [[ -z $DB_PASSWORD ]] && echo "$red_text DB USERNAME AND DB PASSWORD MUST BE PROVIDED$reset_color" && exit
    [[ ! $DB_USERNAME =~ $string_underscore_dash_pattern ]] && echo -e "$red_text\nDB USERNAME ERROR \nMUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit    
    [ -z $(grep "$DB_URI_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $DB_URI_ENV_NAME ]] || [[ ! $DB_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text DB URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
    [ -z $(grep "$API_PORT_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $API_PORT_ENV_NAME ]] || [[ ! $API_PORT_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
    [[ -z $API_PORT ]] || [[ ! $API_PORT =~ $number_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

if [[ $BUILD_REDIS =~ $true_pattern ]]; then
    [ -z $(grep "$REDIS_URI_ENV_NAME" $ENV_FILE_EXIST) ] || [[ -z $REDIS_URI_ENV_NAME ]] || [[ ! $REDIS_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text REDIS URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE AND MUST BE PRESENT IN YOUR .env FILE$reset_color" && exit
fi

if [[ $ENABLE_SQITCH =~ $true_pattern ]]; then
    [ -z $SQITCH_PLAN_FILE_EXIST ] || [ -z $(grep "$SQITCH_PROJECT_NAME" $SQITCH_PLAN_FILE_EXIST) ] && echo -e "$red_text\n ANY SQITCH PLAN FILE WAS FOUND in api folder OR sqitch.plan doesn't contain given sqitch project name" && exit
    [[ -z $SQITCH_PROJECT_NAME ]] || [[ ! $SQITCH_PROJECT_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text SQITCH PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ OR - WITH NO SPACE AND WITHOUT NUMBER$reset_color" && exit
    [[ -z $SQITCH_FOLDER_PATH ]] && echo -e "$red_text\nSQITCH FOLDER PATH VARIABLE ERROR \nMUST BE VALID PATH WITH EXISTING FOLDER AND NOT FILE$reset_color" && exit
fi

if [[ $ENABLE_SEEDING =~ $true_pattern ]]; then
    [[ -z $SEEDING_FILE_PATH ]] && echo -e "$red_text\nSEEDING FILE NAME ERROR \nMUST BE EXISTING FILE$reset_color" && exit
fi

if [[ $ENABLE_DUMP_CRON =~ $true_pattern ]]; then
    [[ ! $CRONJOB_SCHEDULE =~ $cronjob_schedule_pattern ]] && echo -e "$red_text\nCRON JOB SCHEDULE ERROR \nMUST BE VALID CRON SCHEDULE WITH NO SPACE$reset_color" && exit
    [[ ! $DELETE_OLDER_THAN_DAYS =~ $number_pattern ]] && echo -e "$red_text\nDELETE OLDER THAN DAYS ERROR \nMUST BE NUMBER WITH NO SPACE$reset_color" && exit
fi

if [[ $ENABLE_BACKUP_SSH =~ $true_pattern ]]; then
    [[ ! $BACKUP_SERVER_SSH_URI =~ $ssh_uri_pattern ]] && echo -e "$red_text\nSSH SERVER URI ERROR \nMUST BE VALID URI WITH NO SPACE$reset_color" && exit
    [[ ! $BACKUP_SERVER_SSH_PORT =~ $number_pattern ]] && echo -e "$red_text\nSSH PORT ERROR \nMUST BE NUMBER WITH NO SPACE$reset_color" && exit
    [[ ! $PATH_ON_BACKUP_SERVER =~ $path_pattern ]] && echo -e "$red_text\nBACKUP SERVER PATH ERROR \nMUST BE VALID ABSOLUTE PATH AND NOT ROOT /$reset_color" && exit
fi      

# DO NOT TOUCH THIS VARIABLE

mongo_pattern='^[mM]ongo'
postgres_pattern='^[pP]ostgres'

if [[ $DB_CHOICE =~ $mongo_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@mongo:27017/admin"
elif [[ $DB_CHOICE =~ $postgres_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@postgres:5432/$DB_USERNAME"
fi


#-------------------------------------------------------------------------------------------------------------------#
#SETUP shorcuts for managing containers without relauching this looooooong script
PATH_TO_COMPOSE_FILE=$(realpath ./docker-compose.yml)
[[ ! -f $PATH_TO_COMPOSE_FILE ]] || [[ ! -s $PATH_TO_COMPOSE_FILE ]] && echo -e "$red_text\nDOCKER COMPOSE FILE NOT HERE$reset_color" && exit

# if directory doesn't exist it be created here
if [[ ! -d ./shortcuts ]]; then mkdir ./shortcuts; fi
[ $? -ne 0 ] && echo -e "$red_text\nshortcuts folder creation error, try to create folder by yourself and try again$reset_color" && exit

# be careful this command gonna kill all your containers and remove all atached volumes and related images
echo "docker-compose -f $PATH_TO_COMPOSE_FILE -p $PROJECT_NAME down -v --rmi all" > ./shortcuts/remove-all.sh && chmod +x ./shortcuts/remove-all.sh
[ $? -ne 0 ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit
[ ! -f ./shortcuts/remove-all.sh ] && [ ! -s ./shortcuts/remove-all.sh ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit

# this command stop and rebuild api on dev env
echo "docker-compose -f $PATH_TO_COMPOSE_FILE -p $PROJECT_NAME rm -sf api_dev && docker rmi api_dev && docker-compose -f $PATH_TO_COMPOSE_FILE -p $PROJECT_NAME up -d api_dev" > ./shortcuts/stop-rebuild-api.sh && chmod +x ./shortcuts/stop-rebuild-api.sh
[ $? -ne 0 ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit
[ ! -f ./shortcuts/stop-rebuild-api.sh ] && [ ! -s ./shortcuts/stop-rebuild-api.sh ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit


# TODO api-stop-rebuild shorcut + front-stop-rebuild shortcut

#-------------------------------------------------------------------------------------------------------------
# .env FILES POPULATION FOR docker-compose.yml
if [[ ! -d ./environement ]]; then mkdir ./environement; fi
[ $? -ne 0 ] && echo -e "$red_text\nenvironement folder creation error, try to create folder by yourself and try again$reset_color" && exit


if [[ $BUILD_BACK =~ $true_pattern ]] && [[ $DB_CHOICE =~ $postgres_pattern ]]; then

    sed -i "52c\        - $API_PORT:$API_PORT" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit    


    echo -e "POSTGRES_USER=$DB_USERNAME\nPOSTGRES_PASSWORD=$DB_PASSWORD" > ./environement/.db.env
    [ $? -ne 0 ] && echo -e "$red_text\ndb env file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./environement/.db.env ] && [ ! -s ./environement/.db.env ] && echo "$red_text ERROR on population of environnement/.db.env file$reset_color" && exit
    
    if [[ $BUILD_REDIS =~ $true_pattern ]]; then
        echo -e "$DB_URI_ENV_NAME=postgres://$DB_URI\n$REDIS_URI_ENV_NAME=redis://redis:6379\n$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    else
        echo -e "$DB_URI_ENV_NAME=postgres://$DB_URI\n$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
        [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
        [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit
    fi

elif [[ $BUILD_BACK =~ $true_pattern ]] && [[ $DB_CHOICE =~ $mongo_pattern ]]; then
    #todo same logic for mongo database

    sed -i "51c\        - $API_PORT:$API_PORT" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit    

    echo -e "MONGO_INITDB_ROOT_USERNAME=$DB_USERNAME\nMONGO_INITDB_ROOT_PASSWORD=$DB_PASSWORD" > ./environement/.db.env
    [ $? -ne 0 ] && echo -e "$red_text\ndb env creation error, try to create file by yourself and try again$reset_color" && exit    
    [ ! -f ./environement/.db.env ] || [ ! -s ./environement/.db.env ] && echo "$red_text ERROR on population of environnement/.db.env file$reset_color" && exit

    echo -e "$DB_URI_ENV_NAME=mongo://$DB_URI \n$REDIS_URI_ENV_NAME=redis://redis:6379\n$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
    [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit

fi

#-------------------------------------------------------------------------------------------------------------
# DEPLOYEMENT
dev_pattern='^[dD][eE][vV]'
prod_pattern='^[pP][rR][oO][dD]'

# API DEPLOYEMENT 
# todo refacto to have mongo database option
if [[ $BUILD_BACK =~ $true_pattern ]] && [[ $ENV =~ $dev_pattern ]]; then

    if [[ $BUILD_REDIS =~ $true_pattern ]]; then
    docker-compose -p $PROJECT_NAME up -d redis postgres api_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME down -v && docker rmi -f api_dev && exit 
    else
    docker-compose -p $PROJECT_NAME up -d postgres api_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME down -v && docker rmi -f api_dev && exit 
    fi

    docker-compose -p $PROJECT_NAME restart api_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured when restarting api_dev service in compose file$reset_color" && exit    

    echo -e "$green_text\nAPI DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $API_PORT$reset_color"

elif [[ $BUILD_BACK =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then
    # todo adapt dev logic to prod
    docker-compose -p $PROJECT_NAME up -d redis postgres api_prod
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_prod and databases deployement with compose file$reset_color" && exit    

    docker-compose -p $PROJECT_NAME restart api_prod
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured when restarting api_dev service in compose file$reset_color" && exit    

    docker image rm node:lts-alpine
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on delete of base nodeJS image$reset_color" && exit    

    echo -e "$green_text\nAPI DEPLOYED ON PRODUCTION ENV WITH SUCCESS ON PORT $API_PORT$reset_color"

fi

# FRONT DEPLOYEMENT
if [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $dev_pattern ]]; then

    sed -i "67c\        - $FRONT_PORT:80" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev setting port in compose file$reset_color" && exit    

    docker-compose -p $PROJECT_NAME up -d front_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev deployement with compose file$reset_color" && docker-compose -p $PROJECT_NAME rm -sf front_dev && exit    

    echo -e "$green_text\nFRONT DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $FRONT_PORT$reset_color"
elif [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then

    #todo finish this part
    docker-compose -p $PROJECT_NAME up -d front_prod
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

    docker image rm node:lts-alpine
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
    echo -e "$green_text\nFRONT DEPLOYED ON PROD ENV WITH SUCCESS ON PORT 80 AND 443$reset_color"

fi


#------------------------------------------------------------------------------------------------------------
#OPTIONS

# SETUP SQITCH TO DEPLOY DATABASE STRUCTURE
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_SQITCH =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then
    sleep 1

    if [[ ! -d ./modules ]]; then mkdir ./modules; fi
    [ $? -ne 0 ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit
    [ ! -d ./modules ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit

    echo -e "apt-get update > /dev/null && apt-get install sqitch -y > /dev/null && sqitch init $SQITCH_PROJECT_NAME --target db:pg://$DB_USERNAME:$DB_PASSWORD@postgres:5432/$DB_USERNAME && sqitch deploy" > ./modules/sqitch.sh
    [ $? -ne 0 ] && echo -e "$red_text\nsqitch module file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./modules/sqitch.sh ] && [ ! -s ./modules/sqitch.sh ] && echo -e "$red_text\nsqitch module file creation error, try to create file by yourself and try again$reset_color" && exit
    
    docker-compose -p $PROJECT_NAME up -d utils
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on build and run utils service in compose file$reset_color" && exit

    docker cp ./modules/sqitch.sh $PROJECT_NAME\_utils_1:/
    if [ $? -ne 0 ]; then
    docker cp ./modules/sqitch.sh $PROJECT_NAME-utils-1:/
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of sqitch.sh file in utils container$reset_color" && exit
    fi


    docker cp $SQITCH_FOLDER_PATH/. $PROJECT_NAME\_utils_1:/
    if [ $? -ne 0 ]; then
    docker cp $SQITCH_MIGRATIONS_FOLDER_NAME/. $PROJECT_NAME-utils-1:/
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of sqitch migrations folder in utils container$reset_color" && exit    
    fi

    docker exec -i $PROJECT_NAME\_utils_1 bash -c "bash sqitch.sh"
    if [ $? -ne 0 ]; then
    docker exec -i $PROJECT_NAME-utils-1 bash -c "bash sqitch.sh"
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of sqitch.sh script inside utils container$reset_color" && exit
    fi

    docker-compose -p $PROJECT_NAME rm -sf utils
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on stopping and removing of utils container$reset_color" && exit

    echo -e "$green_text\nDATABASE STRUCTURE DEPLOYEMENT WITH SQITCH SUCCESSFULLY DONE$reset_color"
else echo "sqitch option not used"
fi


# SETUP SEEDING OPTION
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_SEEDING =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then
    sleep 1

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then

        

        docker cp $SEEDING_FILE_PATH $PROJECT_NAME\_postgres_1:/
        if [ $? -ne 0 ]; then
        docker cp $SEEDING_FILE_PATH $PROJECT_NAME-postgres-1:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of seeding file inside postgres database container$reset_color" && exit
        fi


        docker exec -i $PROJECT_NAME\_postgres_1 sh -c "psql -f /$SEEDING_FILE_NAME postgres://$DB_URI && rm /$SEEDING_FILE_NAME"
        if [ $? -ne 0 ]; then
        docker exec -i $PROJECT_NAME-postgres-1 sh -c "psql -f /$SEEDING_FILE_NAME postgres://$DB_URI && rm /$SEEDING_FILE_NAME"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of seeding file inside postgres database container$reset_color" && exit
        fi

        echo -e "$green_text\nPOSTGRES DATABASE SEEDING SUCCESSFULLY DONE$reset_color"  
    else
        # todo same thing for mongo database
        docker cp $PATH_TO_SEEDING_FILE/$SEEDING_FILE_NAME $PROJECT_NAME\_mongo_1:/
        docker exec -i $PROJECT_NAME\_mongo_1 sh -c "mongo -f /$SEEDING_FILE_NAME mongo://$DB_URI && rm /$SEEDING_FILE_NAME"   
    fi
else echo "seeding option not used"
fi


# SETUP CRON SCHEDULING DB DUMP OPTION
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then

    if [[ ! -d ./modules ]]; then mkdir ./modules; fi
    [ $? -ne 0 ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit
    [ ! -d ./modules ] && echo -e "$red_text\nmodules folder creation error, try to create folder by yourself and try again$reset_color" && exit

    docker-compose -p $PROJECT_NAME up -d utils
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on build and run utils service in compose file$reset_color" && exit

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then

        echo -e "DATE=\$(date +%F-%H_%M)\npg_dump postgres://$DB_URI > /home/postgres\$DATE.sql\nfind /home/ -type f -ctime +$DELETE_OLDER_THAN_DAYS -execdir rm -- '{}' \;" > ./modules/cron.sh
        [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        
        docker cp ./modules/cron.sh $PROJECT_NAME\_utils_1:/
        if [ $? -ne 0 ]; then
        docker cp ./modules/cron.sh $PROJECT_NAME-utils-1:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of cron.sh file in utils container$reset_color" && exit
        fi

        docker exec -it $PROJECT_NAME\_utils_1 bash -c "apt-get update > /dev/null && apt-get install cron postgresql-client -y > /dev/null && touch dump_cron && echo \"$CRONJOB_SCHEDULE /bin/sh /cron.sh >> /cron.log 2>&1\" > dump_cron && crontab dump_cron && rm dump_cron && service cron restart"
        if [ $? -ne 0 ]; then
        docker exec -it $PROJECT_NAME-utils-1 bash -c "apt-get update > /dev/null && apt-get install cron postgresql-client -y > /dev/null && touch dump_cron && echo \"$CRONJOB_SCHEDULE /bin/sh /cron.sh >> /cron.log 2>&1\" > dump_cron && crontab dump_cron && rm dump_cron && service cron restart"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of commands for cronjob inside utils container$reset_color" && exit
        fi
       
        echo -e "$green_text\nCRON SCHEDULE FOR DB DUMP SUCCESSFULLY DONE$reset_color"  
    else
        # todo same logic for mongo database
        echo -e "DATE=$(date +%F-%H_%M)\n pg_dump postgres://$DB_URI > /home/postgres\$DATE.sql\nfind /home/ -type f -ctime +$DELETE_OLDER_THAN_DAYS -execdir rm -- '{}' \;" > ./modules/cron.sh
        [ $? -ne 0 ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        [ ! -f ./modules/cron.sh ] && [ ! -s ./modules/cron.sh ] && echo -e "$red_text\ncron module file creation error, try to create file by yourself and try again$reset_color" && exit
        
        docker cp ./modules/cron.sh $PROJECT_NAME\_utils_1:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of cron.sh file in utils container$reset_color" && exit

        docker exec -i $PROJECT_NAME\_utils_1 sh -c "apt-get update > /dev/null && apt-get install cron -y > /dev/null && touch dump_cron && echo \"$CRONJOB /bin/sh /dump.sh >> /dump.log 2>&1\" >> dump_cron && crontab dump_cron && rm dump_cron && service cron restart"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of commands for cronjob inside utils container$reset_color" && exit
       
        echo -e "$green_text\nCRON SCHEDULE FOR DB DUMP SUCCESSFULLY DONE$reset_color"
   
    fi 
else echo "cron dump option not used"
fi


#SETUP SENDING DUMPED BACKUP FILE OVER SSH
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern ]] && [[ $ENABLE_BACKUP_SSH =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then
    
    docker exec -i $PROJECT_NAME\_utils_1 bash -c "apt-get update && apt-get install rsync openssh-server -y > /dev/null && echo | ssh-keygen -P ''"
    if [ $? -ne 0 ]; then
    docker exec -i $PROJECT_NAME-utils-1 bash -c "apt-get update && apt-get install rsync openssh-server -y > /dev/null && echo | ssh-keygen -P ''"
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of commands for ssh setup inside utils container$reset_color" && exit
    fi

    echo "${green_text}COPY THIS KEY INTO YOUR authorized_keys FILE${reset_color}"
    echo "${green_text}----------------------------------------------------------------------------${reset_color}"
    docker exec -it $PROJECT_NAME\_utils_1 bash -c "cat ~/.ssh/id_rsa.pub"
    if [ $? -ne 0 ]; then
    docker exec -it $PROJECT_NAME-utils-1 bash -c "cat ~/.ssh/id_rsa.pub"
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of commands for showing ssh id_rsa.pub inside utils container$reset_color" && exit
    fi
    echo "${green_text}----------------------------------------------------------------------------${reset_color}"

    while true; do
        read -p "Type yes when key is copied ?  " yn
        case $yn in
            [Yy]* ) break;;
        * ) echo "Please answer yes or no.";;
        esac
    done

else echo "send dump file over ssh option not used"
fi


if [[ ! $ENABLE_OPTIONS =~ $true_pattern ]] || [[ ! $ENABLE_DUMP_CRON =~ $true_pattern ]]; then
  
    docker volume rm $PROJECT_NAME\_dump_files
    if [ $? -ne 0 ]; then
    docker volume rm $PROJECT_NAME-dump-files
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on removing unused volumes$reset_color" && exit    
    fi
fi


UNTAGED_IMAGES=$(docker images -f dangling=true -q)
[ $? -ne 0 ] && echo -e "$red_text\nUNTAGED IMAGES VARIABLE ERROR$reset_color" && exit

COMPOSE_IMAGES=$(docker-compose -p $PROJECT_NAME images -q)
[ $? -ne 0 ] && echo -e "$red_text\nCOMPOSE IMAGES VARIABLE ERROR$reset_color" && exit

if [[ -n ${COMPOSE_IMAGES[*]} ]] && [[ -n ${UNTAGED_IMAGES[*]} ]]; then
    for UNTAGED_IMAGE_ID in $UNTAGED_IMAGES; do
        if [[ ${COMPOSE_IMAGES[*]} =~ $UNTAGED_IMAGE_ID ]]; then

            BINGO=$(docker ps --filter ancestor=$UNTAGED_IMAGE_ID | awk '{ print $1 }' | grep [0-9] )
            [ $? -ne 0 ] && echo -e "$red_text\nBINGO VARIABLE ERROR$reset_color" && exit
            echo $BINGO

            docker stop $BINGO && docker rm $BINGO
            [ $? -ne 0 ] && echo -e "$red_text\nSTOP AND REMOVE BINGO$reset_color" && exit

            docker rmi -f $UNTAGED_IMAGE_ID
            [ $? -ne 0 ] && echo -e "$red_text\nDOCKER RMI BINGO ERROR$reset_color" && exit

        fi
    done

fi