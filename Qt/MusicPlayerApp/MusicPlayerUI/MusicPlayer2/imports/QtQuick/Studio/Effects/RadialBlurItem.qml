import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias cached: radialBlur.cached
    property alias samples: radialBlur.samples
    property alias verticalOffset: radialBlur.verticalOffset
    property alias horizontalOffset: radialBlur.horizontalOffset
    property alias transparentBorder: radialBlur.transparentBorder
    property alias angle: radialBlur.angle

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack

        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y
    }

    RadialBlur {
        id: radialBlur
        anchors.fill: stack
        source: stack
        verticalOffset: 12
        horizontalOffset: 12
        samples: 16
        angle: 45
    }
}
