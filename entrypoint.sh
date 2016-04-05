#!/bin/bash
set -e


MMS_API_KEY=${MMS_API_KEY:-}
MMS_GROUP_ID=${MMS_GROUP_ID:-}


sed 's/mmsApiKey=/mmsApiKey='"${MMS_API_KEY}"'\nmmsGroupId='"${MMS_GROUP_ID}"'/g' -i /etc/mongodb-mms/monitoring-agent.config
sed 's/mmsApiKey=/mmsApiKey='"${MMS_API_KEY}"'\nmmsGroupId='"${MMS_GROUP_ID}"'/g' -i /etc/mongodb-mms/backup-agent.config

appStart () {
  # start supervisord
  echo "Starting supervisord..."
  exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the gitlab server (default)"
  echo " [command]          - Execute the specified linux command eg. bash."
}


case ${1} in
  app:start)
    appStart
    ;;
  *)
    if [[ -x $1 ]]; then
      $1
    else
      prog=$(which $1)
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0
