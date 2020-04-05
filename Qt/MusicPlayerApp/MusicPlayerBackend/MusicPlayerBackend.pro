TEMPLATE = lib
TARGET = musicPlayerBackend
QT += qml quick multimedia
CONFIG += plugin c++11

TARGET = $$qtLibraryTarget($$TARGET)
uri = io.qt

# Input
SOURCES += \
    albummodel.cpp \
    artistmodel.cpp \
    genremodel.cpp \
    mediametadataparser.cpp \
        musicplayerbackendplugin.cpp \
    musicplayerbackend.cpp \
    songmodel.cpp

HEADERS += \
    albummodel.h \
    artistmodel.h \
    genremodel.h \
    mediametadataparser.h \
    musicplayerbackendplugin.h \
    musicplayerbackend.h \
    songmodel.h

DISTFILES += qmldir \
    musicPlayer.qmltypes

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

# DESTDIR = $$[QT_INSTALL_QML]/io/qt/

qmldir.files = qmldir \
    musicPlayer.qmltypes

unix|windows {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

RESOURCES +=
