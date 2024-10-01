#!/bin/bash

case "$1" in
    build*)
            flutter pub run build_runner build --delete-conflicting-outputs
            dart run flutter_launcher_icons:generate -f flutter_launcher_icons.yaml
            flutter build "$2"
            ;;
    gen*) flutter pub run build_runner build --delete-conflicting-outputs
            ;;
    appicon*) dart run flutter_launcher_icons:generate -f flutter_launcher_icons.yaml
            ;;
    *)      echo "unknown command: $1"
esac
