import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias colorizeHue: colorize.hue
    property alias colorizeSaturation: colorize.saturation
    property alias colorizeLightness: colorize.lightness
    property alias cached: colorize.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    Colorize {
        id: colorize
        anchors.fill: stack
        source: stack
        hue: 0.0
        saturation: 0
        lightness: 0
    }
}
