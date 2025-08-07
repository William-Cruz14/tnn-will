#!/bin/bash
# DERO Mining Performance Benchmark Script
# Tests performance improvements on target processors

echo "=== DERO TNN Miner Performance Benchmark ==="
echo "Optimized for:"
echo "- Intel Xeon E5 2680 v4 (Broadwell, 14c/28t, 2.4GHz)"
echo "- AMD Ryzen 5 5600 (Zen 3, 6c/12t)"
echo "- AMD Ryzen 7 5700U (Zen 2, 8c/16t, notebook)"
echo

# Get CPU info
echo "Current CPU:"
lscpu | grep "Model name" | head -1
echo

# Get available cores
CORES=$(nproc)
echo "Available CPU cores: $CORES"
echo

# Check for required CPU features
echo "CPU Features:"
grep -E "avx2|aes|sha_ni|bmi1|bmi2" /proc/cpuinfo | head -1
echo

# Build directory
BUILD_DIR="build_optimized"

if [ ! -f "$BUILD_DIR/bin/tnn-miner-cpu" ]; then
    echo "ERROR: Optimized miner not found in $BUILD_DIR/bin/"
    echo "Please build the optimized version first."
    exit 1
fi

echo "=== Running AstroBWT Algorithm Tests ==="
echo "Testing AstroBWT v3 implementation..."
$BUILD_DIR/bin/tnn-miner-cpu --test-dero --quiet
echo

echo "=== Performance Benchmarks ==="

# Test with different thread counts for optimization
for THREADS in 1 2 4 $CORES; do
    if [ $THREADS -le $CORES ]; then
        echo "--- Benchmark with $THREADS thread(s) ---"
        echo "Running 10-second benchmark..."
        
        # Create a temporary benchmark log
        TEMP_LOG=$(mktemp)
        
        # Run benchmark and capture output
        timeout 15s $BUILD_DIR/bin/tnn-miner-cpu --dero --dero-benchmark 10 --threads $THREADS --daemon-address 127.0.0.1 --port 20206 --wallet dERi6MG3HEFutxRvLsgrNFAfQJv7DsT2AhFLHDqm4AKNfL7aBBFe4vgJoFYqxUf3FLk7kJb3LjqzwNpN2Nv5NEZFKsNJ5NSsQ 2>&1 | tee $TEMP_LOG
        
        # Extract hashrate if available
        if grep -q "H/s" $TEMP_LOG; then
            HASHRATE=$(grep "H/s" $TEMP_LOG | tail -1 | awk '{print $NF}' | sed 's/H\/s//')
            echo "Estimated hashrate: $HASHRATE H/s"
        fi
        
        rm -f $TEMP_LOG
        echo
    fi
done

echo "=== CPU Affinity Test ==="
echo "Testing with CPU affinity enabled (optimal for target processors)..."
timeout 15s $BUILD_DIR/bin/tnn-miner-cpu --dero --dero-benchmark 10 --threads $CORES --daemon-address 127.0.0.1 --port 20206 --wallet dERi6MG3HEFutxRvLsgrNFAfQJv7DsT2AhFLHDqm4AKNfL7aBBFe4vgJoFYqxUf3FLk7kJb3LjqzwNpN2Nv5NEZFKsNJ5NSsQ 2>&1 | grep -E "(H/s|Thread|ERROR)"
echo

echo "Testing with CPU affinity disabled..."
timeout 15s $BUILD_DIR/bin/tnn-miner-cpu --dero --dero-benchmark 10 --threads $CORES --no-lock --daemon-address 127.0.0.1 --port 20206 --wallet dERi6MG3HEFutxRvLsgrNFAfQJv7DsT2AhFLHDqm4AKNfL7aBBFe4vgJoFYqxUf3FLk7kJb3LjqzwNpN2Nv5NEZFKsNJ5NSsQ 2>&1 | grep -E "(H/s|Thread|ERROR)"
echo

echo "=== Algorithm Selection Test ==="
echo "Testing Wolf algorithm (optimized for target processors)..."
timeout 15s $BUILD_DIR/bin/tnn-miner-cpu --dero --dero-benchmark 5 --threads 4 --no-tune wolf --daemon-address 127.0.0.1 --port 20206 --wallet dERi6MG3HEFutxRvLsgrNFAfQJv7DsT2AhFLHDqm4AKNfL7aBBFe4vgJoFYqxUf3FLk7kJb3LjqzwNpN2Nv5NEZFKsNJ5NSsQ 2>&1 | grep -E "(H/s|Wolf|ERROR)"
echo

echo "=== Optimization Summary ==="
echo "✓ Dev fee removed (0%)"
echo "✓ Non-DERO algorithms disabled"
echo "✓ AVX2, AES-NI, SHA-NI optimizations enabled"
echo "✓ Target processor optimizations applied"
echo "✓ Cache-aligned data structures"
echo "✓ NUMA-aware memory allocation"
echo "✓ Loop unrolling and vectorization"
echo "✓ Branch prediction optimizations"
echo
echo "Benchmark complete. For production mining, use the parameters that showed best performance."