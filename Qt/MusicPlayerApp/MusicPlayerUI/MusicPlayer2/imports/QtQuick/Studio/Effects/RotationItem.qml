import QtQuick 2.10

Item {
    id: root
    property alias originX: rotation.origin.x
    property alias originY: rotation.origin.y
    property alias axisX: rotation.axis.x
    property alias axisY: rotation.axis.y
    property alias axisZ: rotation.axis.z
    property alias angle: rotation.angle

    implicitWidth: childrenRect.width + childrenRect.x
    implicitHeight: childrenRect.height + childrenRect.y

    transform: Rotation {
        id: rotation
        origin.x: root.width / 2
        origin.y: root.height / 2
        angle: 45
    }
}
