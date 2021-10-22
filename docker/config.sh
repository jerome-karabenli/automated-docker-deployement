# REQUIERED VARIABLES
ENV="" # "dev" | "prod" on dev https is not used
PROJECT_NAME="" # give a name for docker-compose project must be lowercase

BUILD_FRONT="" # if true nginx container is used for front deployement
FRONT_PORT="" # this is only if BUILD_FRONT is true and ENV is dev, on PROD env used ports are 80 and 443

BUILD_BACK="" # if true redis & chosen database & nodeJS container is used for back deployement
DB_CHOICE="" # choose between "postgres" and "mongo"
DB_USERNAME=""
DB_PASSWORD=""

DB_URI_ENV_NAME="" # set here the same env variable name for db uri as in your original .env file
REDIS_URI_ENV_NAME="" # set here the same env variable name for redis uri as in your original .env file

API_PORT_ENV_NAME="" # set here the same env variable name for API PORT as in your original .env file
API_PORT=""

# OPTIONAL VARIABLES

ENABLE_OPTIONS="" # set this to true to activate options

## use sqitch for db structure only available on sql databases. If you want to restore backuped dump file use seeding option instead.
ENABLE_SQITCH=""
SQITCH_PROJECT_NAME="" # you must provide the same project name as in sqitch.plan
PATH_TO_SQITCH_FOLDER="" # I suppose your sqitch top-dir is in your github repo in api folder if is not change this path

## seeding or backup database
ENABLE_SEEDING=""
PATH_TO_SEEDING_FILE="" # adapt this path to your project
SEEDING_FILE_NAME="" # give the name of your seeding or backup file

## setup cronjob for periodical dump
ENABLE_DUMP_CRON=""
CRONJOB_SCHEDULE="" # set your desired schedule as cron style
DELETE_OLDER_THAN_DAYS="" # set number of days you want to keep dump files

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