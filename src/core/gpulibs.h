#pragma once

// DERO-only optimized build - no GPU libraries needed for AstroBWT v3

inline int GPUTest() {
  // GPU mining is not supported for DERO AstroBWT v3 in this optimized build
  printf("GPU mining not supported in DERO-only optimized build\n");
  return 0;
}