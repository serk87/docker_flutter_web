#!/bin/bash

cd /app
flutter pub get
flutter build web

# Set the port
PORT=5000

# switch directories
cd build/web/

# Start the server
echo 'Server starting on port' $PORT '...'
python3 -m http.server $PORT