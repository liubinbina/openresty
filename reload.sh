openresty -t
if [ $? -eq 0 ]
then
        echo "[$(date -Iseconds)] Reloading Nginx Configuration"
        service openresty reload
fi