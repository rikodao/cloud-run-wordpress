set -eo pipefail

echo "Mounting GCS Fuse."
gcsfuse --dir-mode "777" --debug_gcs --debug_fuse -o nonempty,allow_other $BUCKET $MNT_DIR
echo "Mounting completed."

/usr/local/bin/docker-entrypoint.sh apache2-foreground