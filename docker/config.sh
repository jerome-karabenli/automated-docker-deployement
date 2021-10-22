# REQUIERED VARIABLES
ENV="dev" # "dev" | "prod" on dev https is not used
PROJECT_NAME="kebab" # give a name for docker-compose project must be lowercase

BUILD_FRONT="true" # if true nginx container is used for front deployement
FRONT_PORT="5000" # this is only if BUILD_FRONT is true and ENV is dev, on PROD env used ports are 80 and 443

BUILD_BACK="true" # if true chosen database & nodeJS container is used for back deployement
DB_CHOICE="postgres" # choose between "postgres" and "mongo"
DB_USERNAME="ochalet"
DB_PASSWORD="ochalet"
DB_URI_ENV_NAME="DATABASE_URL" # set here the same env variable name for db uri as in your original .env file

BUILD_REDIS="true" # set this to true if your api use redis
REDIS_URI_ENV_NAME="REDIS_URL" # set here the same env variable name for redis uri as in your original .env file

API_PORT_ENV_NAME="PORT" # set here the same env variable name for API PORT as in your original .env file
API_PORT="3000"

# OPTIONAL VARIABLES

ENABLE_OPTIONS="true" # set this to true to activate options

## use sqitch for db structure only available on sql databases. If you want to restore backuped dump file use seeding option instead.
ENABLE_SQITCH=""
SQITCH_PROJECT_NAME="ochalet" # you must provide the same project name as in sqitch.plan
PATH_TO_SQITCH_FOLDER="../api/migrations" # I suppose your sqitch top-dir is in your github repo in api folder if is not change this path

## seeding or backup database
ENABLE_SEEDING="true"
PATH_TO_SEEDING_FILE="../api/data" # adapt this path to your project
SEEDING_FILE_NAME="postgres2021-10-14-22_24.sql" # give the name of your seeding or backup file

## setup cronjob for periodical dump
ENABLE_DUMP_CRON="true"
CRONJOB_SCHEDULE="*/1 * * * *" # set your desired schedule as cron style
DELETE_OLDER_THAN_DAYS="3" # set number of days you want to keep dump files

## send db dump to another server via ssh for backup cronjob option must be activated
ENABLE_BACKUP_SSH=""
BACKUP_SERVER_SSH_URI="" # this is your ssh connection uri
BACKUP_SERVER_SSH_PORT="" # set your ssh server port. Default is 22.
PATH_ON_BACKUP_SERVER="" # path in your backup server where to store dump files



#-----------------------------------------------------------------------------------------------
#EXPORT


export ENV
export ENABLE_OPTIONS
export PROJECT_NAME

export BUILD_FRONT
export FRONT_PORT

export BUILD_BACK
export DB_CHOICE
export DB_USERNAME
export DB_PASSWORD
export DB_URI_ENV_NAME

export BUILD_REDIS
export REDIS_URI_ENV_NAME

export API_PORT_ENV_NAME
export API_PORT

export ENABLE_SQITCH
export SQITCH_PROJECT_NAME
export PATH_TO_SQITCH_FOLDER

export ENABLE_SEEDING
export PATH_TO_SEEDING_FILE
export SEEDING_FILE_NAME

export ENABLE_DUMP_CRON
export CRONJOB_SCHEDULE
export DELETE_OLDER_THAN_DAYS

export ENABLE_BACKUP_SSH
export BACKUP_SERVER_SSH_URI
export BACKUP_SERVER_SSH_PORT
export PATH_ON_BACKUP_SERVE