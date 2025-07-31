#!/bin/bash

# P2IM Docker Setup Script
# This script builds and runs the P2IM Docker environment

set -e

echo -e "\n=== P2IM Docker Setup ==="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Ubuntu: sudo apt-get update && sudo apt-get install docker.io"
    echo "   Or follow: https://docs.docker.com/install/"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose &> /dev/null; then
    echo "⚠️  Docker Compose not found. You can still use Docker directly."
    USE_COMPOSE=false
else
    USE_COMPOSE=true
fi

echo "🔧 Building P2IM Docker image..."
docker build -t p2im:latest .

if [ $? -eq 0 ]; then
    echo "✅ P2IM Docker image built successfully!"
    echo ""
    
    if [ "$USE_COMPOSE" = true ]; then
        echo "🚀 Starting P2IM container with Docker Compose..."
        docker compose up -d
        echo ""
        echo "📋 To access the container:"
        echo "   docker compose exec p2im bash"
        echo ""
        echo "🛑 To stop the container:"
        echo "   docker compose down"
    else
        echo "🚀 To run P2IM container:"
        echo "   docker run -it --rm -v \$(pwd)/fuzzing:/app/fuzzing -v \$(pwd)/externals:/app/externals -p 9000:9000 p2im:latest"
        echo ""
        echo "📋 Or for interactive shell:"
        echo "   docker run -it --rm -v \$(pwd)/fuzzing:/app/fuzzing -v \$(pwd)/externals:/app/externals -p 9000:9000 p2im:latest bash"
    fi    
else
    echo "❌ Failed to build Docker image. Please check the error messages above."
    exit 1
fi
