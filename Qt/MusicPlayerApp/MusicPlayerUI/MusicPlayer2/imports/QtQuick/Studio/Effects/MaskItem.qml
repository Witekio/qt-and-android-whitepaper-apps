import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias invert: blend.invert

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        z: -1
        id: stack
        implicitWidth: blend.source.width + blend.source.x
        implicitHeight: blend.source.height + blend.source.y

        visible: false
    }

    OpacityMask {
        id: blend
        anchors.fill: parent
        source: root.background
        maskSource: root.foreground
    }

    property Item background
    property Item foreground

    property Item foo: Item {}

    Component.onCompleted: {
        root.background = stack.children[0]
        root.foreground = stack.children[1]
    }
}
