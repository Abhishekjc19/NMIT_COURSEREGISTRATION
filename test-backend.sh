#!/bin/bash
echo "Testing backend connection..."
echo ""
echo "Checking port 8090:"
netstat -ano | grep 8090 || echo "❌ Nothing running on port 8090"
echo ""
echo "To test the API, run after backend starts:"
echo "curl http://localhost:8090/api/notices"
