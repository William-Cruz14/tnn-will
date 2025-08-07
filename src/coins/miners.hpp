#pragma once

#include "tnn-common.hpp"
#include <net.hpp>
#include <num.h>
#include <hex.h>
#include <endian.hpp>
#include <terminal.h>

using byte = unsigned char;

extern bool rx_hugePages;

inline Num ConvertDifficultyToBig(Num d, int algo)
{
  // DERO-only optimized version - only support AstroBWT v3
  if (algo == ALGO_ASTROBWTV3) {
    return oneLsh256 / d;
  }
  return 0; // Unsupported algorithm
}

inline bool CheckHash(unsigned char *hash, int64_t diff, int algo)
{
  if (littleEndian()) std::reverse(hash, hash+32);
  bool cmp = Num(hexStr(hash, 32).c_str(), 16) <= ConvertDifficultyToBig(diff, algo);
  if (littleEndian()) std::reverse(hash, hash+32);
  return (cmp);
}

inline bool CheckHash(unsigned char *hash, Num diff, int algo)
{
  if (littleEndian()) std::reverse(hash, hash+32);
  bool cmp = Num(hexStr(hash, 32).c_str(), 16) <= diff;
  if (littleEndian()) std::reverse(hash, hash+32);
  return (cmp);
}

inline std::string uint32ToHex(uint32_t value) {
  std::stringstream ss;
  ss << std::hex << std::setw(8) << std::setfill('0') << value;
  return ss.str();
}

static inline void unsupportedCPU(int tid) {
  printf("This coin is not supported on CPUs\n");
}

static inline void unsupportedGpu(int tid) {
  printf("This coin is not supported on GPUs\n");
}

// DERO-only optimized mining function
void mineDero(int tid);

typedef void (*mineFunc)(int);
inline mineFunc getMiningFunc(int algoNum, bool gpu) {
  // DERO-only optimized version - GPU mining not supported for AstroBWT
  if(gpu) {
    printf("GPU mining not supported for DERO AstroBWT v3\n");
    return unsupportedGpu;
  }
  
  // Only support DERO AstroBWT v3 algorithm
  if (algoNum == ALGO_ASTROBWTV3) {
    return mineDero;
  }
  
  printf("Only DERO AstroBWT v3 algorithm is supported in this optimized build\n");
  return unsupportedCPU;
}
