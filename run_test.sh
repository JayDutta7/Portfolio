#!/bin/bash
flutter run -d chrome > flutter_output.txt 2>&1 &
FLUTTER_PID=$!
sleep 20
kill $FLUTTER_PID
cat flutter_output.txt
