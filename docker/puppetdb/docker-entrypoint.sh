#!/bin/sh

set -e

on_exit() {
  # Propagate up the exit code of our container application
  status=$?
  # Perform cleanup/whatever on exit
  echo "Shutting down!"
  # Don't trigger this again when we exit below
  trap '' EXIT TERM
  if [ "$CONSUL_ENABLED" = "true" ]; then
    pkill consul
  fi
  exit $status

}

for f in /docker-entrypoint.d/*.sh; do
    echo "Running $f"
    chmod +x "$f"
    "$f"
done

trap on_exit INT TERM EXIT

su-exec root java $PUPPETDB_JAVA_ARGS -cp /puppetdb.jar \
    clojure.main -m puppetlabs.puppetdb.core "$@" \
    -c /etc/puppetlabs/puppetdb/conf.d/
