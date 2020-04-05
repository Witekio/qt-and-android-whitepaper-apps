import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children

    property alias brightness: brightCont.brightness
    property alias contrast: brightCont.contrast
    property alias cached: brightCont.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y
        visible: false
    }

    BrightnessContrast {
        id: brightCont
        anchors.fill: stack
        source: stack
    }
}
