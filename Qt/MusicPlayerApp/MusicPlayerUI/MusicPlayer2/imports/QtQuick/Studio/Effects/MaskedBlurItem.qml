import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    default property alias contentStack: stack.children
    property alias maskBlurRadius: maskedBlur.radius
    property alias maskBlurSamples: maskedBlur.samples
    property alias gradientStopPosition1: stop1.position
    property alias gradientStopPosition2: stop2.position
    property alias gradientStopPosition3: stop3.position
    property alias gradientStopPosition4: stop4.position
    property alias maskRotation: gradient.rotation

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack
        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y

        visible: false
    }

    Item {
        id: mask
        width: stack.width
        height: stack.height
        visible: false

        LinearGradient {
            id: gradient
            height: stack.height * 2
            width: stack.width * 2
            y: -stack.height / 2
            x: -stack.width / 2
            rotation: 0
            gradient: Gradient {
                GradientStop {
                    id: stop1
                    position: 0.2
                    color: "#ffffffff"
                }
                GradientStop {
                    id: stop2
                    position: 0.5
                    color: "#00ffffff"
                }
                GradientStop {
                    id: stop3
                    position: 0.8
                    color: "#00ffffff"
                }
                GradientStop {
                    id: stop4
                    position: 1.0
                    color: "#ffffffff"
                }
            }
            start: Qt.point(stack.width / 2, 0)
            end: Qt.point(stack.width + stack.width / 2, 100)
        }
    }

    MaskedBlur {
        id: maskedBlur
        anchors.fill: stack
        source: stack
        maskSource: mask
        radius: 32
        samples: 16
    }
}
