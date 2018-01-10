TEMPLATE = app
TARGET = pup_killer

CONFIG -= qt

CONFIG += c++14
CONFIG -= app_bundle

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

contains(QT_ARCH, x86_64) {
	ARCHITECTURE = x64
} else {
	ARCHITECTURE = x86
}

mac* | linux*{
	CONFIG(release, debug|release):CONFIG += Release
	CONFIG(debug, debug|release):CONFIG += Debug
}

Release:OUTPUT_DIR=release/$${ARCHITECTURE}
Debug:OUTPUT_DIR=debug/$${ARCHITECTURE}

DESTDIR  = bin/$${OUTPUT_DIR}
OBJECTS_DIR = build/$${OUTPUT_DIR}/$${TARGET}
MOC_DIR     = build/$${OUTPUT_DIR}/$${TARGET}
UI_DIR      = build/$${OUTPUT_DIR}/$${TARGET}
RCC_DIR     = build/$${OUTPUT_DIR}/$${TARGET}

win* {
	QMAKE_CXXFLAGS += /MP /Zi /wd4275 /wd4251
	QMAKE_CXXFLAGS_EXCEPTIONS_ON = /EHa
	QMAKE_CXXFLAGS_STL_ON = /EHa
	DEFINES += NOMINMAX WIN32_LEAN_AND_MEAN _CRT_SECURE_NO_WARNINGS

	QMAKE_LFLAGS += /DEBUG:FASTLINK /ignore:4217 /ignore:4049
	QMAKE_LIBFLAGS += /ignore:4217 /ignore:4049

	Debug:QMAKE_LFLAGS += /INCREMENTAL
	Release:QMAKE_LFLAGS += /OPT:REF /OPT:ICF

	DEFINES -= UNICODE
}

SOURCES += src/main.cpp
