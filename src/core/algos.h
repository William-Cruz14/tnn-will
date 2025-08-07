#pragma once

// DERO-only optimized build - only include AstroBWT v3
#include <astrobwtv3/astrobwtv3.h>
#include <astrobwtv3/astrotest.hpp>

// Only include the DERO-specific error message
const char* unsupported_astro = "This Binary was compiled without AstroBWTv3 support... \n"
            "Please source a TNN Miner binary with AstroBWTv3 support";