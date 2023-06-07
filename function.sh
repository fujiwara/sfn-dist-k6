set -e
function handler () {
    cd $LAMBDA_TASK_ROOT
    rm -f /tmp/summary.json
    ./k6 run --vus "$1" --duration 3s simple.js 1>&2 > /dev/null
    cat /tmp/summary.json
}
