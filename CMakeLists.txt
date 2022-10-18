cmake_minimum_required(VERSION 3.14)

project(qmlonline6 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Core5Compat)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick)

set(PROJECT_SOURCES
    src/main.cpp
    qt-toolkit/App.cpp
    qt-toolkit/App.h
	qt-toolkit/Engine.cpp
	qt-toolkit/Engine.h
    qt-toolkit/FileSystem.cpp
    qt-toolkit/FileSystem.h
    qt-toolkit/Folder.cpp
    qt-toolkit/Folder.h
	qt-toolkit/SyntaxHighlighter.cpp
	qt-toolkit/SyntaxHighlighter.h
	qt-toolkit/System.cpp
	qt-toolkit/System.h
    qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(qmlonline6
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET qmlonline6 APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(qmlonline6 SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(qmlonline6
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(qmlonline6 PRIVATE GIT_COMMIT=${GIT_COMMIT})

# /*
# include_directories(util)
#
# qt_add_qml_module(qmlonline6
#     URI qmlonline6
#     VERSION 1.0
#     SOURCES
#         util/util.cpp
#         util/util.h
# )
#
# set(QML_IMPORT_PATH "./")

target_link_libraries(qmlonline6
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)
#  Qt${QT_VERSION_MAJOR}::Core5Compat)

set_target_properties(qmlonline6 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS qmlonline6
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(qmlonline6)
    qt_finalize_executable(qmlonline6)
endif()

# add_link_options(
#     --bind
#     "SHELL:-s FETCH=1"
#     "SHELL:-s WASM=1"
#     "SHELL:-s FULL_ES2=1"
#     "SHELL:-s WASM_BIGINT=1"
#     "SHELL:-s FULL_ES3=1"
#     "SHELL:-s USE_WEBGL2=1"
#     "SHELL:-s EXIT_RUNTIME=1"
#     "SHELL:-s INITIAL_MEMORY=335544320"
#     "SHELL:-lidbfs.js"
#     "SHELL:-s FORCE_FILESYSTEM=1"
#     "SHELL:-s ALLOW_MEMORY_GROWTH=1"
#     "SHELL:-s EXPORTED_RUNTIME_METHODS=[ccall,cwrap,UTF16ToString,stringToUTF16,specialHTMLTargets]"
#     "SHELL:-s ERROR_ON_UNDEFINED_SYMBOLS=1")
# 
