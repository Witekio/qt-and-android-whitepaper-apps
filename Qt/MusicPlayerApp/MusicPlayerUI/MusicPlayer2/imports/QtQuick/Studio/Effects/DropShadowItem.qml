import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias horizontalOffset: dropShadow.horizontalOffset
    property alias verticalOffset: dropShadow.verticalOffset
    property alias radius: dropShadow.radius
    property alias samples: dropShadow.samples
    property alias spread: dropShadow.spread
    property alias transparentBorder: dropShadow.transparentBorder
    property alias color: dropShadow.color
    property alias cached: dropShadow.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    DropShadow {
        id: dropShadow
        anchors.fill: stack
        source: stack
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        spread: 4
        transparentBorder: true
        color: "#80000000"
    }
}
