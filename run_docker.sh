#!/bin/bash

if ! command -v docker compose &> /dev/null; then
    echo "⚠️  Docker Compose not found. You can still use Docker directly."
    USE_COMPOSE=false
else
    USE_COMPOSE=true
fi

if [ $? -eq 0 ]; then
    echo "✅ P2IM Docker image built successfully!"
    echo ""
    
    if [ "$USE_COMPOSE" = true ]; then
        docker compose up -d
        echo "🚀 Starting P2IM container with Docker Compose..."
        echo ""
        echo "📋 To access the container:"
        echo "   docker compose exec p2im bash"
        echo ""
        echo "🛑 To stop the container:"
        echo "   docker compose down"
        echo "🚀 P2IM container is started"
        docker compose exec p2im bash
    else
        docker run -it --rm \
        -v $(pwd)/fuzzing:/app/fuzzing \
        p2im:latest bash
    fi    
else
    echo "❌ Failed to build Docker image. Please check the error messages above."
    exit 1
fi