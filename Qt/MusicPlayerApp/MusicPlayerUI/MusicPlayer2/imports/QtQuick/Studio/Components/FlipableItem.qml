import QtQuick 2.9

Flipable {
    id: flipable
    width: 240
    height: 240

    property alias flipAngle: rotation.angle
    property real opacityFront: 1
    property real opacityBack: 1
    property int xAxis: 0
    property int yAxis: 1

    Binding {
        target: flipable.front
        value: opacityFront
        property: "opacity"
        when: flipable.front !== undefined
    }

    Binding {
        target: flipable.back
        value: opacityBack
        property: "opacity"
        when: flipable.back !== undefined
    }

    property bool flipped: false

    Component.onCompleted: {
        flipable.front = flipable.children[0]
        flipable.back = flipable.children[1]
    }

    transform: Rotation {
        id: rotation
        origin.x: flipable.width / 2
        origin.y: flipable.height / 2
        axis.x: flipable.xAxis
        axis.y: flipable.yAxis
        axis.z: 0
        angle: 0 // the default angle
    }
}
