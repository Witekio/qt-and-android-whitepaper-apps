import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias desaturation: desaturate.desaturation
    property alias cached: desaturate.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack

        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    Desaturate {
        id: desaturate
        source: stack
        anchors.fill: stack

        desaturation: 0.5
    }
}
