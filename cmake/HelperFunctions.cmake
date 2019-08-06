# Sets the library linker flags and includes for MKL
#
#   NAME      [required]    Name to store library locations and linker flags to
#   REQD_LIBS [required]    List of libraries that should be included
#   STATIC    [optional]    Generate static library. If not specified, will generate shared
#
#  Example:
#     add_mkl_dependency(NAME mkl_static REQD_LIBS mkl_intel_lp64 mkl_gnu_thread STATIC)

function(add_mkl_dependency)
    set(options STATIC)
    set(oneValueArgs NAME)
    set(multiValueArgs REQD_LIBS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if( NOT ARG_NAME )
      message ( FATAL_ERROR "add_mkl_dependency_unix called without a NAME" )
    endif()

    # Set prefixes and suffixes for libraries based on type of compilation and OS
    if (ARG_STATIC)
      if (WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")    	
      else()
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")	
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")		
      endif()
      
    else()
      if (WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")    	
      elseif(APPLE)
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")	
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".dylib")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".so")	
      else()
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")		
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".so")	
      endif()
    endif()

    # Find libraries
    foreach(s ${ARG_REQD_LIBS})
      if (WIN32)
	find_library(${s}_LIBRARY
	  NAMES ${s}
	  PATHS $ENV{MKLROOT}/lib
	  $ENV{MKLROOT}/lib/intel64
	  $ENV{MKLROOT}/../compiler/lib/intel64
	  $ENV{MKLROOT}/Library/bin
	  $ENV{MKLROOT}/Library/lib
	  NO_DEFAULT_PATH)	
      else()
	find_library(${s}_LIBRARY
	  NAMES ${s}
	  PATHS $ENV{MKLROOT}/lib
	  $ENV{MKLROOT}/lib/intel64
	  $ENV{MKLROOT}/../compiler/lib/intel64
	  NO_DEFAULT_PATH)	
      endif()

      if(NOT ${s}_LIBRARY)
	message(FATAL_ERROR "NOT FOUND: " ${s})
      endif()     
            
      list(APPEND ${ARG_NAME}_FOUND_LIBRARIES ${${s}_LIBRARY})
    endforeach()

    # Set includes and linking based on OS and whether static or shared build
    if (WIN32)
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{MKLROOT}/Library/include PARENT_SCOPE)
      if (ARG_STATIC)
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)	
      endif()
    elseif(APPLE)
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{MKLROOT}/include PARENT_SCOPE)
      if (ARG_STATIC)
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} "-liomp5" "-lpthread" "-lm" "-ldl" PARENT_SCOPE)
      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      endif()
    else()
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{MKLROOT}/include PARENT_SCOPE)
      if (ARG_STATIC)
	set(${ARG_NAME}_LIBRARIES "-Wl,--start-group" ${${ARG_NAME}_FOUND_LIBRARIES} "-Wl,--end-group" "-fopenmp" "-lgomp" "-lpthread" "-lm" "-ldl" PARENT_SCOPE)
      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      endif()
    endif()
endfunction(add_mkl_dependency)

# Sets the library linker flags and includes for IPP
#
#   NAME      [required]    Name to store library locations and linker flags to
#   REQD_LIBS [required]    List of libraries that should be included
#   STATIC    [optional]    Generate static library. If not specified, will generate shared
#
#  Example:
#     add_ipp_dependency(NAME ipp_static REQD_LIBS ipp_intel_lp64 ipp_gnu_thread STATIC)

function(add_ipp_dependency)
    set(options STATIC)
    set(oneValueArgs NAME)
    set(multiValueArgs REQD_LIBS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if( NOT ARG_NAME )
      message ( FATAL_ERROR "add_ipp_dependency_unix called without a NAME" )
    endif()

    # Set prefixes and suffixes for libraries based on type of compilation and OS
    if (ARG_STATIC)
      if (WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")    	
      else()
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")	
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")		
      endif()
      
    else()
      if (WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")    	
      elseif(APPLE)
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")	
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".dylib")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".so")	
      else()
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib")		
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".so")	
      endif()
    endif()

    # Find libraries
    foreach(s ${ARG_REQD_LIBS})
      if (WIN32)
	find_library(${s}_LIBRARY
	  NAMES ${s}
	  PATHS $ENV{IPPROOT}/lib
	  $ENV{IPPROOT}/lib/intel64
	  $ENV{IPPROOT}/../compiler/lib/intel64
	  $ENV{IPPROOT}/Library/bin
	  $ENV{IPPROOT}/Library/lib
	  NO_DEFAULT_PATH)	
      else()
	find_library(${s}_LIBRARY
	  NAMES ${s}
	  PATHS $ENV{IPPROOT}/lib
	  $ENV{IPPROOT}/lib/intel64
	  $ENV{IPPROOT}/../compiler/lib/intel64
	  NO_DEFAULT_PATH)	
      endif()

      if(NOT ${s}_LIBRARY)
	message(FATAL_ERROR "NOT FOUND: " ${s})
      endif()     
            
      list(APPEND ${ARG_NAME}_FOUND_LIBRARIES ${${s}_LIBRARY})
    endforeach()

    # Set includes and linking based on OS and whether static or shared build
    if (WIN32)
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{IPPROOT}/Library/include PARENT_SCOPE)
      if (ARG_STATIC)
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)	
      endif()
    elseif(APPLE)
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{IPPROOT}/include PARENT_SCOPE)
      if (ARG_STATIC)

      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      endif()
    else()
      set(${ARG_NAME}_INCLUDE_DIRS $ENV{IPPROOT}/include PARENT_SCOPE)
      if (ARG_STATIC)
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} "-lgomp" "-lpthread" "-lm" "-ldl" PARENT_SCOPE)
      else()
	set(${ARG_NAME}_LIBRARIES ${${ARG_NAME}_FOUND_LIBRARIES} PARENT_SCOPE)
      endif()
    endif()
endfunction(add_ipp_dependency)
