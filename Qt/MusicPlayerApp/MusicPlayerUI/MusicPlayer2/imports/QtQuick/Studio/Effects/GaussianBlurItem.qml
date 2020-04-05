import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias content: stack.children
    property alias gaussianBlurRadius: gaussianBlur.radius
    property alias gaussianBlurSamples: gaussianBlur.samples

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        implicitWidth: contentItem.width
        implicitHeight: contentItem.height
        visible: true
        id: stack
    }

    GaussianBlur {
        id: gaussianBlur
        anchors.fill: stack
        source: stack
        radius: 32
        samples: 16
    }
}
