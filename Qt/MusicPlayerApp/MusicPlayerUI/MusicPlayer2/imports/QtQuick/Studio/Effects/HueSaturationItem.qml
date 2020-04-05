import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias adjustHue: hueSat.hue
    property alias adjustSaturation: hueSat.saturation
    property alias adjustLightness: hueSat.lightness
    property alias cached: hueSat.cached

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    HueSaturation {
        id: hueSat
        anchors.fill: stack
        source: stack
        hue: 0.0
        saturation: 0.5
        lightness: -0.2
    }
}
