#!/bin/bash
set -e
show_help () {
cat << USAGE
usage: $0 [ -n NUMBER-TO-TEST ] [ -k SCKEY-TO-SEND-MSG ]

    -n : Specify the number to test. 
    -k : Specify the SCKEY of the user to send note to. If multiple, set the keys in term of csv, 
         as 'key-1,key-2,key-3'.

USAGE
exit 0
}
# Get Opts
while getopts "hn:k:" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    k)  SCKEY=$OPTARG # 参数存在$OPTARG中
        ;;
    n)  NUM=$OPTARG
        ;;
    ?)  # 当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
[ -z "$*" ] && show_help
chk_var () {
if [ -z "$2" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
  sleep 3
  exit 1
fi
}
chk_var -k $SCKEY
chk_var -n $NUM
LOG_PREFIX=/tmp/test-install-k8.$(date -d today +'%Y-%m-%d_%H:%M:%S')
START=$(date +%s)
START_STR=$(date -d today +'%Y-%m-%d %H:%M:%S')
FAILD=0
SCKEY=$(echo ${SCKEY} | tr "," " ")
for i in $(seq -s ' ' 1 ${NUM}); do 
  FLAG=$(make > ${LOG_PREFIX}.${i}_in_${NUM}.log 2>&1)
  TEXT="test_install_k8s_${i}"
  if [[ $FLAG -eq 0 ]]; then
    RET="Success"
  else
    RET="Failed"   
    FAILD=$[${FAILD}+1]
  fi
  DESP=$(cat <<EOF
time: $(date -d today +'%Y-%m-%d %H:%M:%S')  
round: $i / $NUM   
ret: ${RET}
EOF
  )
  for KEY in ${SCKEY}; do
    URL=https://sc.ftqq.com/${KEY}.send
    curl -d "text=${TEXT}&desp=${DESP}" -X POST ${URL}
  done
done
END=$(date +%s)
END_STR=$(date -d today +'%Y-%m-%d %H:%M:%S')
ELAPSED=$[$END-$START]
MINUTE=$[$ELAPSED/60]
TEXT="summary_of_test_install_k8s_"
DESP=$(cat <<EOF
start: ${START_STR}  
end: ${END_STR}  
elapsed: ${ELAPSED} sec, ${MINUTE} min  
total: ${NUM}  
success: $[${NUM}-${FAILD}]    
faild: ${FAILD}  
EOF
)
for KEY in ${SCKEY}; do
  URL=https://sc.ftqq.com/${KEY}.send
  curl -d "text=${TEXT}&desp=${DESP}" -X POST ${URL}
done
exit 0
