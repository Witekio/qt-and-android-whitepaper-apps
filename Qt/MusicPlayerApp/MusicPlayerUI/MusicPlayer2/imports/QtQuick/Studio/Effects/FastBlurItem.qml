import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
    id: root

    layer.enabled: true

    default property alias contentStack: stack.children
    property alias radius: blur.radius
    property alias transparentBorder: blur.transparentBorder
    property alias cached: blur.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack

        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y
    }

    FastBlur {
        id: blur

        transparentBorder: true
        anchors.fill: stack
        source: stack
        radius: 12
    }
}
