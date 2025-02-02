macro(get_sdl2 version)
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.24)
    cmake_policy(SET CMP0135 NEW)
  endif()
  include(FetchContent)
  if(MSVC OR (WIN32 AND CMAKE_C_COMPILER_ID MATCHES "Clang"))
    FetchContent_Declare(
      SDL2
      URL https://github.com/libsdl-org/SDL/releases/download/release-${version}/SDL2-devel-${version}-VC.zip
      URL_HASH
        SHA256=ff0dfdd8e89c2cef3be8378e4a39c27b5ee7acb689a7cb09aa14dd14242f9a9c)
  elseif(MINGW)
    FetchContent_Declare(
      SDL2
      URL https://github.com/libsdl-org/SDL/releases/download/release-${version}/SDL2-devel-${version}-mingw.zip
      URL_HASH
        SHA256=8d0c8adee4ac3a66f6bc8cbd8e9724d5ed160af365ae362d3a4ef68df26da9da)
  else()
    find_package(SDL2 QUIET)
    if(NOT SDL2_FOUND)
      if(NINTENDO_3DS) # TODO: Remove when added in a release
        set(tag "origin/main")
      else()
        set(tag "release-${version}")
      endif()
      FetchContent_Declare(
        SDL2
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG "${tag}")
      FetchContent_MakeAvailable(SDL2)
      set(SDL2_LIBRARIES SDL2::SDL2main SDL2::SDL2)
    endif()
  endif()

  if(WIN32)
    FetchContent_MakeAvailable(SDL2)
    find_package(SDL2 CONFIG REQUIRED PATHS ${sdl2_SOURCE_DIR} NO_DEFAULT_PATH)
    get_target_property(SDL2_DLL SDL2::SDL2 IMPORTED_LOCATION)
    file(COPY_FILE ${SDL2_DLL} ${EXPORT_DIR}/SDL2.dll ONLY_IF_DIFFERENT)
  endif()
endmacro(get_sdl2)

macro(get_sdl2_mixer version)
  include(FetchContent)
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.24)
    cmake_policy(SET CMP0135 NEW)
  endif()
  if(MSVC OR (WIN32 AND CMAKE_C_COMPILER_ID MATCHES "Clang"))
    FetchContent_Declare(
      SDL2_mixer
      URL https://github.com/libsdl-org/SDL_mixer/releases/download/release-${version}/SDL2_mixer-devel-${version}-VC.zip
      URL_HASH
        SHA256=7f050663ccc7911bb9c57b11e32ca79578b712490186b8645ddbbe4e7d2fe1c9)
  elseif(MINGW)
    FetchContent_Declare(
      SDL2_mixer
      URL https://github.com/libsdl-org/SDL_mixer/releases/download/release-${version}/SDL2_mixer-devel-${version}-mingw.zip
      URL_HASH
        SHA256=4e1eeddd41eb1e780f10d13ca21da35d4941eaa8c472591040943169d0e39837)
  else()
    find_package(SDL2_mixer QUIET)
    if(NOT SDL2_mixer_FOUND)
      set(tag "release-${version}")
      set(SDL2MIXER_INSTALL OFF)
      FetchContent_Declare(
        SDL2_mixer
        GIT_REPOSITORY https://github.com/libsdl-org/SDL_mixer.git
        GIT_TAG "${tag}")
      FetchContent_MakeAvailable(SDL2_mixer)
    endif()
  endif()

  if(WIN32)
    FetchContent_MakeAvailable(SDL2_mixer)
    find_package(SDL2_mixer CONFIG REQUIRED PATHS ${sdl2_mixer_SOURCE_DIR}
                 NO_DEFAULT_PATH)
    get_target_property(SDL2_mixer_DLL SDL2_mixer::SDL2_mixer IMPORTED_LOCATION)
    file(COPY_FILE ${SDL2_mixer_DLL} ${EXPORT_DIR}/SDL2_mixer.dll
         ONLY_IF_DIFFERENT)
  endif()

  if(TARGET SDL2_mixer::SDL2_mixer-static)
    set(SDL2_MIXER_LIBS SDL2_mixer::SDL2_mixer-static)
  else()
    set(SDL2_MIXER_LIBS SDL2_mixer::SDL2_mixer)
  endif()
endmacro(get_sdl2_mixer)
