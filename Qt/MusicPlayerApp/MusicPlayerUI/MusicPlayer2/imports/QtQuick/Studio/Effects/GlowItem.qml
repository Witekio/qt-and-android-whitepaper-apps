import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias radius: glow.radius
    property alias samples: glow.samples
    property alias spread: glow.spread
    property alias color: glow.color
    property alias transparentBorder: glow.transparentBorder
    property alias cached: glow.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y
        visible: false
    }

    Glow {
        id: glow
        anchors.fill: stack
        radius: 5
        samples: 16
        spread: 0.5
        color: "#ffffffff"
        transparentBorder: true
        source: stack
    }
}
