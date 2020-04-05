import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children

    property alias directionalBlurAngle: directionalBlur.angle
    property alias directionalBlurLength: directionalBlur.length
    property alias directionalBlurSamples: directionalBlur.samples
    property alias directionalBlurBorder: directionalBlur.transparentBorder
    property alias cached: directionalBlur.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    DirectionalBlur {
        id: directionalBlur
        anchors.fill: stack
        source: stack
        angle: 90
        length: 32
        samples: 16
        transparentBorder: true
    }
}
