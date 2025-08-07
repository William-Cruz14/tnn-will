#pragma once

// DERO-only optimized build - only include AstroBWT v3
#include <astrobwtv3/astrobwtv3.h>
#include <astrobwtv3/astrotest.hpp>

// Generic unsupported algorithm message for DERO-only build
const char* unsupported_algorithm = "This DERO-optimized build only supports AstroBWT v3 algorithm.\n"
            "All other algorithms have been removed for optimal performance.";