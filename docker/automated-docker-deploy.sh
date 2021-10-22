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

while true; do
    read -p "$green_text DO YOU WANT TO RUN PROMPTED VARIABLES SELECTION, IF NOT config.sh FILE$red_text MUST$reset_color$green_text BE EDITED MANUALY ?$reset_color y/n " yn
    case $yn in
        [Yy]* ) 
            
            while [[ ! $ENV =~ $env_pattern ]] && echo "Choose env ? dev/prod "; do
                read -p "desired environement=" ENV
            done 

            while [[ ! $PROJECT_NAME =~ $string_underscore_only_lowercase_pattern ]] && echo "Choose project name for Docker, must be lowercase"; do
                read -p "project name=" PROJECT_NAME
            done           
            
            while true; do
                read -p "do you want build back ? y/n " yn
                case $yn in
                    [Yy]* )
  
                    while [[ ! $DB_CHOICE =~ $db_choice_pattern ]] && echo "Choose db: mongo/postgres"; do
                        read -p "database choice=" DB_CHOICE
                    done
                    while [[ -z $DB_USERNAME ]] || [[ ! $DB_USERNAME =~ $string_underscore_dash_pattern ]] && echo "Choose database username. database username accept only string with optional dash and underscore"; do
                        read -p "db username=" DB_USERNAME
                    done
                    while [[ -z $DB_PASSWORD ]] && echo "Choose db password"; do
                        read -p "db password=" DB_PASSWORD
                    done
                    while [[ -z $DB_URI_ENV_NAME ]] || [[ ! $DB_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "Set same DB URI env name as in your .env file $red_text DB URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color"; do
                        read -p "database uri env name=" DB_URI_ENV_NAME
                    done
                    while [[ -z $REDIS_URI_ENV_NAME ]] || [[ ! $REDIS_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "Set same REDIS URI env name as in your .env file $red_text REDIS URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color"; do
                        read -p "redis uri env name=" REDIS_URI_ENV_NAME
                    done
                    while [[ -z $API_PORT_ENV_NAME ]] || [[ ! $API_PORT_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "Set same PORT env name as in your .env file $red_text API PORT ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color"; do
                        read -p "api port env name=" API_PORT_ENV_NAME
                    done
                    while [[ -z $API_PORT ]] || [[ ! $API_PORT =~ $number_pattern ]] && echo "Choose API port $red_text API PORT MUST BE NUMBER WITH NO SPACE$reset_color"; do
                        read -p "api port=" API_PORT
                    done

                    BUILD_BACK="true"
                    
                    break;;
                    [Nn]* ) BUILD_BACK="false" break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done

            while true; do
                read -p "do you want build front ? y/n " yn
                case $yn in
                    [Yy]* ) 
                    while [[ -z $FRONT_PORT ]] || [[ ! $FRONT_PORT =~ $number_pattern ]] && echo -e "Choose front port"; do
                        read -p "value=" FRONT_PORT
                    done
                    BUILD_FRONT="true"
                    break;;
                    [Nn]* ) BUILD_FRONT="false" break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
            
            if [[ $BUILD_BACK =~ $true_pattern ]]; then
                while true; do
                read -p "do you want enable optional modules ? y/n " yn
                case $yn in
                    [Yy]* ) 
                    ENABLE_OPTIONS="true"
                    while true; do
                    read -p "do you want enable sqitch structure deploy, only available on postgres database ? y/n " yn
                    case $yn in
                        [Yy]* ) 

                        ENABLE_SQITCH="true";
                        while [[ -z $SQITCH_PROJECT_NAME ]] || [[ ! $SQITCH_PROJECT_NAME =~ $string_underscore_dash_pattern ]] && echo "set exact same project name as in your sqitch.plan file $red_text SQITCH PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ OR - WITH NO SPACE AND WITHOUT NUMBER$reset_color"; do
                            read -p "sqitch project name=" SQITCH_PROJECT_NAME
                        done

                        while [[ ! -d $PATH_TO_SQITCH_FOLDER ]] && echo -e "$red_text\nMUST BE VALID PATH WITH EXISTING FOLDER AND NOT FILE$reset_color"; do
                            read -p "path to sqitch migrations folder=" PATH_TO_SQITCH_FOLDER
                        done
                        
                        break;;
                        [Nn]* ) ENABLE_SQITCH="false"; break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                    done

                    while true; do
                    read -p "do you want enable database seeding ? y/n " yn
                    case $yn in
                        [Yy]* ) 
                        ENABLE_SEEDING="true"; 
                        while [[ ! -d $PATH_TO_SEEDING_FILE ]] && echo -e "$red_text\nSEEDING FILE FOLDER PATH \nMUST BE VALID PATH NOT FILE$reset_color"; do
                            read -p "path to seeding file folder=" PATH_TO_SEEDING_FILE
                        done

                        while [[ ! -f $PATH_TO_SEEDING_FILE$SEEDING_FILE_NAME ]] && [[ ! -f "$PATH_TO_SEEDING_FILE/$SEEDING_FILE_NAME" ]] && echo -e "$red_text\nSEEDING FILE NAME \nMUST BE EXISTING FILE$reset_color"; do
                            read -p "seeding file name=" SEEDING_FILE_NAME
                        done
                        
                        break;;
                        [Nn]* ) ENABLE_SEEDING="false"; break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                    done

                    while true; do
                    read -p "do you want enable cron for database dump ? y/n " yn
                    case $yn in
                        [Yy]* )

                        ENABLE_DUMP_CRON="true"; 
                        while [[ ! $CRONJOB_SCHEDULE =~ $cronjob_schedule_pattern ]] && echo -e "$red_text\nSet cronjob schedule \nMUST BE VALID CRON SCHEDULE WITH NO SPACE$reset_color"; do
                            read -p "cronjob schedule=" CRONJOB_SCHEDULE
                        done
                        while [[ ! $DELETE_OLDER_THAN_DAYS =~ $number_pattern ]] && echo -e "$red_text\nSet number of days to keep dumped files, this gonna delete older than this value files \nMUST BE NUMBER WITH NO SPACE$reset_color"; do
                            read -p "number of days to keep=" DELETE_OLDER_THAN_DAYS
                        done
                        break;;
                        [Nn]* ) ENABLE_DUMP_CRON="false"; break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                    done

                    if [[ $ENABLE_DUMP_CRON =~ $true_pattern ]];then
                        while true; do
                        read -p "do you want enable sending database dump file over ssh to another server every cron job ? y/n " yn
                        case $yn in
                            [Yy]* ) 
                            ENABLE_BACKUP_SSH="true"; 
                            
                            break;;
                            [Nn]* ) ENABLE_BACKUP_SSH="false"; break;;
                            * ) echo "Please answer yes or no.";;
                        esac
                    done
                    fi
                    
                    break;;
                    [Nn]* ) ENABLE_OPTIONS="false"; break;;
                    * ) echo "Please answer yes or no.";;
                esac
                done 
            else ENABLE_OPTIONS="false"
            fi

        break;;
        [Nn]* ) source ./config.sh; 
        
                [[ ! $ENV =~ $env_pattern ]] && echo "$red_text ENV MUST BE dev OR prod$reset_color" && exit
                [[ -z $PROJECT_NAME ]] || [[ ! $PROJECT_NAME =~ $string_underscore_only_lowercase_pattern ]] && echo "$red_text PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ WITH NO SPACE AND WITHOUT NUMBER$reset_color" && exit

                if [[ $BUILD_FRONT =~ $true_pattern ]]; then
                    [[ -z $FRONT_PORT ]] && [[ ! $FRONT_PORT =~ $number_pattern ]] && echo -e "$red_text\nFRONT PORT MUST BE NUMBER WITH NO SPACE$reset_color" && exit
                fi

                if [[ $BUILD_BACK =~ $true_pattern ]]; then
                    [[ ! $DB_CHOICE =~ $db_choice_pattern ]] && echo "$red_text DB CHOICE MUST BE mongo OR postgres$reset_color" && exit
                    [[ -z $DB_USERNAME ]] || [[ -z $DB_PASSWORD ]] && echo "$red_text DB USERNAME AND DB PASSWORD MUST BE PROVIDED$reset_color" && exit
                    [[ ! $DB_USERNAME =~ $string_underscore_dash_pattern ]] && echo -e "$red_text\nDB USERNAME ERROR \nMUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit    
                    [[ -z $DB_URI_ENV_NAME ]] || [[ ! $DB_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text DB URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit
                    [[ -z $REDIS_URI_ENV_NAME ]] || [[ ! $REDIS_URI_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text REDIS URI ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit
                    [[ -z $API_PORT_ENV_NAME ]] || [[ ! $API_PORT_ENV_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE STRING WITH OPTIONAL _ OR - AND NO SPACE$reset_color" && exit
                    [[ -z $API_PORT ]] || [[ ! $API_PORT =~ $number_pattern ]] && echo "$red_text API PORT ENV NAME MUST BE NUMBER WITH NO SPACE$reset_color" && exit
                fi

                if [[ $ENABLE_SQITCH =~ $true_pattern ]]; then
                    [[ -z $SQITCH_PROJECT_NAME ]] || [[ ! $SQITCH_PROJECT_NAME =~ $string_underscore_dash_pattern ]] && echo "$red_text SQITCH PROJECT NAME MUST BE STRING CONTAINING OPTIONAL _ OR - WITH NO SPACE AND WITHOUT NUMBER$reset_color" && exit
                    [[ ! -d $PATH_TO_SQITCH_FOLDER ]] && echo -e "$red_text\nSQITCH FOLDER PATH VARIABLE ERROR \nMUST BE VALID PATH WITH EXISTING FOLDER AND NOT FILE$reset_color" && exit
                fi

                if [[ $ENABLE_SEEDING =~ $true_pattern ]]; then
                    [[ ! -d $PATH_TO_SEEDING_FILE ]] && echo -e "$red_text\nSEEDING FOLDER PATH ERROR \nMUST BE VALID PATH NOT FILE$reset_color" && exit
                    [[ ! -f $PATH_TO_SEEDING_FILE$SEEDING_FILE_NAME ]] && [[ ! -f "$PATH_TO_SEEDING_FILE/$SEEDING_FILE_NAME" ]] && echo -e "$red_text\nSEEDING FILE NAME ERROR \nMUST BE EXISTING FILE$reset_color" && exit
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
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done 


# DO NOT TOUCH THIS VARIABLE

mongo_pattern='^[mM]ongo'
postgres_pattern='^[pP]ostgres'

if [[ $DB_CHOICE =~ $mongo_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@mongo:27017/admin"
elif [[ $DB_CHOICE =~ $postgres_pattern ]]; then
    DB_URI="$DB_USERNAME:$DB_PASSWORD@postgres:5432/$DB_USERNAME"
fi

PATH_TO_DOCKER_FOLDER=$(pwd)


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
echo "docker-compose -p $PROJECT_NAME rm -sf api_dev && docker rmi api_dev && docker-compose -p $PROJECT_NAME up -d api_dev" > ./shortcuts/stop-rebuild-api.sh && chmod +x ./shortcuts/stop-rebuild-api.sh
[ $? -ne 0 ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit
[ ! -f ./shortcuts/stop-rebuild-api.sh ] && [ ! -s ./shortcuts/stop-rebuild-api.sh ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit


# this command stop and rebuild front on dev env
echo "../launcher.sh" > ./shortcuts/stop-rebuild-front.sh && chmod +x ./shortcuts/stop-rebuild-front.sh
[ $? -ne 0 ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit
[ ! -f ./shortcuts/stop-rebuild-api.sh ] && [ ! -s ./shortcuts/stop-rebuild-api.sh ] && echo -e "$red_text\nstop-all.sh file in shortcuts folder error$reset_color" && exit


# UNTAGED_IMAGES=$(docker images -f dangling=false -q)
# COMPOSE_IMAGES=$(docker-compose -p $PROJECT_NAME images -q)

# if [[ -n ${COMPOSE_IMAGES[*]} ]] && [[ -n ${UNTAGED_IMAGES[*]} ]]; then
#     for UNTAGED_IMAGE_ID in $UNTAGED_IMAGES; do
#         if [[ ${COMPOSE_IMAGES[*]} =~ $UNTAGED_IMAGE_ID ]]; then

#             BINGO=$(docker ps --filter ancestor=$UNTAGED_IMAGE_ID | awk '{ print $1 }' | grep [0-9] )
#             docker stop $BINGO && docker rm $BINGO
#             docker image rm -f $UNTAGED_IMAGE_ID
#         fi
#     done

# fi




# TODO api-stop-rebuild shorcut + front-stop-rebuild shortcut



#-------------------------------------------------------------------------------------------------------------
# .env FILES POPULATION FOR docker-compose.yml
if [[ ! -d ./environement ]]; then mkdir ./environement; fi
[ $? -ne 0 ] && echo -e "$red_text\nenvironement folder creation error, try to create folder by yourself and try again$reset_color" && exit

if [[ $BUILD_BACK =~ $true_pattern ]] && [[ $DB_CHOICE =~ $postgres_pattern ]]; then

    sed -i "51c\        - $API_PORT:$API_PORT" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev setting port in compose file$reset_color" && exit    


    echo -e "POSTGRES_USER=$DB_USERNAME\nPOSTGRES_PASSWORD=$DB_PASSWORD" > ./environement/.db.env
    [ $? -ne 0 ] && echo -e "$red_text\ndb env file creation error, try to create file by yourself and try again$reset_color" && exit
    [ ! -f ./environement/.db.env ] && [ ! -s ./environement/.db.env ] && echo "$red_text ERROR on population of environnement/.db.env file$reset_color" && exit
    
    echo -e "$DB_URI_ENV_NAME=postgres://$DB_URI\n$REDIS_URI_ENV_NAME=redis://redis:6379\n$API_PORT_ENV_NAME=$API_PORT" > ./environement/.api.env
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    
    [ ! -f ./environement/.api.env ] || [ ! -s ./environement/.api.env ] && echo "$red_text ERROR on population of environnement/.api.env file$reset_color" && exit

elif [[ $BUILD_BACK =~ $true_pattern ]] && [[ $DB_CHOICE =~ $mongo_pattern ]]; then

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
if [[ $BUILD_BACK =~ $true_pattern ]] && [[ $ENV =~ $dev_pattern ]]; then

    docker-compose -p $PROJECT_NAME up -d redis postgres api_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on api_dev and databases deployement with compose file$reset_color" && exit    

    docker-compose -p $PROJECT_NAME restart api_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured when restarting api_dev service in compose file$reset_color" && exit    

    echo -e "$green_text\nAPI DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $API_PORT$reset_color"

elif [[ $BUILD_BACK =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then
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

    sed -i "66c\        - $FRONT_PORT:80" docker-compose.yml
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev setting port in compose file$reset_color" && exit    

    docker-compose -p $PROJECT_NAME up -d front_dev
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on front_dev deployement with compose file$reset_color" && exit    

    echo -e "$green_text\nFRONT DEPLOYED ON DEV ENV WITH SUCCESS ON PORT $FRONT_PORT$reset_color"
elif [[ $BUILD_FRONT =~ $true_pattern ]] && [[ $ENV =~ $prod_pattern ]]; then

    docker-compose -p $PROJECT_NAME up -d front_prod
    [ $? -ne 0 ] && echo -e "$red_text\napi env file creation error, try to create file by yourself and try again$reset_color" && exit    

    docker-compose -p $PROJECT_NAME restart api_prod
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
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of sqitch.sh file in utils container$reset_color" && exit

    docker cp $PATH_TO_SQITCH_FOLDER/. $PROJECT_NAME\_utils_1:/
    if [ $? -ne 0 ]; then
    docker cp $PATH_TO_SQITCH_FOLDER. $PROJECT_NAME\_utils_1:/
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of sqitch migrations folder in utils container$reset_color" && exit    
    fi

    docker exec -i $PROJECT_NAME\_utils_1 bash -c "bash sqitch.sh"
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of sqitch.sh script inside utils container$reset_color" && exit

    docker-compose -p $PROJECT_NAME rm -sf utils
    [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on stopping and removing of utils container$reset_color" && exit

    echo -e "$green_text\nDATABASE STRUCTURE DEPLOYEMENT WITH SQITCH SUCCESSFULLY DONE$reset_color"
else echo "sqitch option not used"
fi


# SETUP SEEDING OPTION
if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_SEEDING =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then
    sleep 1

    if [[ $DB_CHOICE =~ $postgres_pattern ]]; then
        if [ -f $PATH_TO_SEEDING_FILE$SEEDING_FILE_NAME ]; then
        docker cp $PATH_TO_SEEDING_FILE$SEEDING_FILE_NAME $PROJECT_NAME\_postgres_1:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of seeding file inside postgres database container$reset_color" && exit
        else
        docker cp $PATH_TO_SEEDING_FILE/$SEEDING_FILE_NAME $PROJECT_NAME\_postgres_1:/
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of seeding file inside postgres database container$reset_color" && exit
        fi
        docker exec -i $PROJECT_NAME\_postgres_1 sh -c "psql -f /$SEEDING_FILE_NAME postgres://$DB_URI && rm /$SEEDING_FILE_NAME"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of seeding file inside postgres database container$reset_color" && exit
        echo -e "$green_text\nPOSTGRES DATABASE SEEDING SUCCESSFULLY DONE$reset_color"  
    else
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
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on copy of cron.sh file in utils container$reset_color" && exit

        docker exec -it $PROJECT_NAME\_utils_1 bash -c "apt-get update > /dev/null && apt-get install cron postgresql-client -y > /dev/null && touch dump_cron && echo \"$CRONJOB_SCHEDULE /bin/sh /cron.sh >> /cron.log 2>&1\" > dump_cron && crontab dump_cron && rm dump_cron && service cron restart"
        [ $? -ne 0 ] && echo -e "$red_text\nERROR: occured on execution of commands for cronjob inside utils container$reset_color" && exit
       
        echo -e "$green_text\nCRON SCHEDULE FOR DB DUMP SUCCESSFULLY DONE$reset_color"  
    else
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


# SETUP SENDING DUMPED BACKUP FILE OVER SSH
# if   [[ $ENABLE_OPTIONS =~ $true_pattern ]] && [[ $ENABLE_DUMP_CRON =~ $true_pattern ]] && [[ $ENABLE_BACKUP_SSH =~ $true_pattern ]] && [[ $BUILD_BACK =~ $true_pattern ]]; then
    
#     if [[ $DB_CHOICE =~ $postgres_pattern ]]; then
        

#         echo -e "$green_text\nPOSTGRES DATABASE SEEDING SUCCESSFULLY DONE$reset_color"  
#     else
   
#     fi 
# else echo "send dump file over ssh option not used"
# fi