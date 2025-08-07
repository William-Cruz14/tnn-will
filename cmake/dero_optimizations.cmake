# DERO-specific optimizations for target processors:
# - Intel Xeon E5 2680 v4 (Broadwell, 14c/28t, 2.4GHz)
# - AMD Ryzen 5 5600 (Zen 3, 6c/12t)  
# - AMD Ryzen 7 5700U (Zen 2, 8c/16t, notebook)

message(STATUS "Applying DERO-specific optimizations for target processors")

# Processor-specific optimization flags
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
  # Broadwell (Xeon E5 2680 v4) and Zen 2/3 all support these instructions
  set(DERO_OPT_FLAGS "-mavx2 -maes -mpclmul -msha -mbmi -mbmi2 -madx -mfma")
  
  # Performance optimizations (Clang-compatible)
  set(DERO_PERF_FLAGS "-ffast-math -funroll-loops -finline-functions")
  set(DERO_PERF_FLAGS "${DERO_PERF_FLAGS} -ftree-vectorize")
  set(DERO_PERF_FLAGS "${DERO_PERF_FLAGS} -fomit-frame-pointer")
  
  # Clang-specific optimizations
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(DERO_CLANG_FLAGS "-fvectorize -fslp-vectorize")
    set(DERO_CLANG_FLAGS "${DERO_CLANG_FLAGS} -freroll-loops -ffast-math")
  endif()
  
  # Memory optimization for suffix array operations
  set(DERO_MEM_FLAGS "-falign-functions=32 -falign-loops=32")
  set(DERO_MEM_FLAGS "${DERO_MEM_FLAGS} -mcx16 -mprfchw")
  
  # Combine all DERO optimization flags
  set(DERO_ALL_FLAGS "${DERO_OPT_FLAGS} ${DERO_PERF_FLAGS} ${DERO_CLANG_FLAGS} ${DERO_MEM_FLAGS}")
  
  # Apply to both C and C++ flags
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${DERO_ALL_FLAGS}")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${DERO_ALL_FLAGS}")
  
  message(STATUS "Applied DERO optimizations: ${DERO_ALL_FLAGS}")
endif()

# NUMA optimization for multi-core processors
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DDERO_NUMA_OPTIMIZE")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DDERO_NUMA_OPTIMIZE")

# AstroBWT-specific optimizations
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DDERO_ASTROBWT_OPTIMIZE")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DDERO_ASTROBWT_OPTIMIZE")

# Remove dev fee at compile time
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DDERO_NO_DEVFEE")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DDERO_NO_DEVFEE")