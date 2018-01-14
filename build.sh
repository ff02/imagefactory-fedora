KICKSTART="fedora-cloud-minimal.ks"
TEMPLATE="fedora.tdl"
LOGFILE="/tmp/imagefactory_build.log"
CONFIGFILE="./imagefactory.conf"

function log() {
  echo "### ${1}"
}

sudo imagefactory --config ${CONFIGFILE} base_image --file-parameter install_script ${KICKSTART} ${TEMPLATE} --parameter offline_icicle true  2>&1 | tee ${LOGFILE}
exit_code=$?
log "imagefactory exit code: ${exit_code}"

if [ `grep -c "Image build completed SUCCESSFULLY" ${LOGFILE}` ]
then
  log "Image build succesfully"
  IMAGEFILE=`grep "Image filename: " ${LOGFILE} | awk -F ':' '{print $2}'`

fi

