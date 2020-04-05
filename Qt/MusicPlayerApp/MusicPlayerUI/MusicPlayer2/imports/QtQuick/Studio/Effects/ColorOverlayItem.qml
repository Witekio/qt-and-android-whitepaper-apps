import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias content: stack.children

    property alias overlayColor: colorOverlay.color
    property alias cached: colorOverlay.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack

        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: stack
        source: stack
        color: "#80fff000"
    }
}
