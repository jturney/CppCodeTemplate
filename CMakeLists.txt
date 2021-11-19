cmake_minimum_required(VERSION 3.21)

project(cppproject CXX)
include(cmake/StandardProjectSettings.cmake)
include(cmake/PreventInSourceBuilds.cmake)

# Link to this library to set the C++ standard and global flags
add_library(project-options INTERFACE)
target_compile_features(project-options INTERFACE cxx_std_17)
set_target_properties(project-options PROPERTIES CXX_EXTENSIONS OFF)

option(ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" ON)
if (ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(
        RESULT
            result
        OUTPUT
            output
    )
    if (result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(SEND_ERROR "IPO is not supported: ${output}")
    endif()
endif()

# A very basic PCH
option(ENABLE_PCH "Enable Pre-Compiled Headers" ON)
if (ENABLE_PCH)
    # This sets a global PCH parameter
    target_precompile_headers(
        project-options
        INTERFACE
            <algorithm>
            <array>
            <cassert>
            <chrono>
            <exception>
            <functional>
            <iomanip>
            <limits>
            <memory>
            <numeric>
            <random>
            <sstream>
            <stdexcept>
            <string>
            <tuple>
            <type_traits>
            <utility>
            <vector>
    )
endif()