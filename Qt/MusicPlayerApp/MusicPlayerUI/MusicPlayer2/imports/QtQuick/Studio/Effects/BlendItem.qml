import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias mode: blend.mode

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        z: -1
        id: stack
        implicitWidth: blend.source.width + blend.source.x
        implicitHeight: blend.source.height + blend.source.y

        visible: false
    }

    Blend {
        id: blend
        anchors.fill: parent
        mode: "subtract"
        source: root.background
        foregroundSource: root.foreground
    }

    property Item background
    property Item foreground

    property Item foo: Item {}

    Component.onCompleted: {
        root.background = stack.children[0]
        root.foreground = stack.children[1]
    }
}
