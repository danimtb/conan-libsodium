# see https://github.com/jedisct1/libsodium/blob/master/contrib/Findsodium.cmake

find_path(sodium_INCLUDE_DIR NAMES sodium.h PATHS ${CONAN_INCLUDE_DIRS_LIBSODIUM})
find_library(sodium_LIBRARY NAMES ${CONAN_LIBS_LIBSODIUM} PATHS ${CONAN_LIB_DIRS_LIBSODIUM})

set(sodium_LIBRARY_DEBUG sodium_LIBRARY)
set(sodium_LIBRARY_RELEASE sodium_LIBRARY)
set(sodium_VERSION "1.0.15")
set(sodium_FOUND ON)

set(sodium_INCLUDE_DIRS ${sodium_INCLUDE_DIR})
set(sodium_LIBRARIES ${sodium_LIBRARY})

message(STATUS "libsodium found by conan!")
message(STATUS "sodium_INCLUDE_DIR: ${sodium_INCLUDE_DIR}")
message(STATUS "sodium_LIBRARY: ${sodium_LIBRARY}")
message(STATUS "sodium_VERSION: ${sodium_VERSION}")

if (${CONAN_DEFINES_LIBSODIUM} MATCHES SODIUM_STATIC)
    message(STATUS "using static libsodium")
    set(sodium_USE_STATIC_LIBS ON)
else()
    message(STATUS "using shared libsodium")
    set(sodium_USE_STATIC_LIBS OFF)

    if(MSVC)
        set(CMAKE_FIND_LIBRARY_SUFFIXES_BCK ${CMAKE_FIND_LIBRARY_SUFFIXES})
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
        find_library(sodium_DLL libsodium HINTS ${CONAN_BIN_DIRS_LIBSODIUM})
        message(STATUS "sodium_DLL: ${sodium_DLL}")
        set(sodium_DLL_DEBUG sodium_DLL)
        set(sodium_DLL_RELEASE sodium_DLL)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_BCK})
    endif()
endif()

# zmq wants upper cased names for some reason...
set(SODIUM_FOUND ${sodium_FOUND})
set(SODIUM_USE_STATIC_LIBS ${sodium_USE_STATIC_LIBS})
set(SODIUM_VERSION ${sodium_VERSION})
set(SODIUM_LIBRARY ${sodium_LIBRARY})
set(SODIUM_LIBRARIES ${sodium_LIBRARIES})
set(SODIUM_LIBRARY_DEBUG ${sodium_LIBRARY_DEBUG})
set(SODIUM_LIBRARY_RELEASE ${sodium_LIBRARY_RELEASE})
set(SODIUM_INCLUDE_DIR ${sodium_INCLUDE_DIR})
set(SODIUM_INCLUDE_DIRS ${sodium_INCLUDE_DIRS})
if (MSVC)
    set(SODIUM_DLL ${sodium_DLL})
    set(SODIUM_DLL_DEBUG ${sodium_DLL_DEBUG})
    set(SODIUM_DLL_RELEASE ${sodium_DLL_RELEASE})
endif()

add_library(sodium INTERFACE IMPORTED)
set_property(TARGET sodium PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${sodium_INCLUDE_DIRS})
set_property(TARGET sodium PROPERTY INTERFACE_LINK_LIBRARIES ${sodium_LIBRARIES})

