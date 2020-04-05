import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root

    default property alias contentStack: stack.children
    property alias zoomBlurLength: zoomBlur.length
    property alias zoomBlurSamples: zoomBlur.samples
    property alias zoomBlurHoffset: zoomBlur.horizontalOffset
    property alias zoomBlurVoffset: zoomBlur.verticalOffset
    property alias cached: zoomBlur.cached
    property alias transparentBorder: zoomBlur.transparentBorder

    implicitWidth: Math.max(32, stack.implicitWidth)
    implicitHeight: Math.max(32, stack.implicitHeight)

    Item {
        id: stack

        implicitWidth: childrenRect.width + childrenRect.x
        implicitHeight: childrenRect.height + childrenRect.y
    }

    ZoomBlur {
        id: zoomBlur
        anchors.fill: stack
        source: stack
        length: 32
        samples: 16
        horizontalOffset: 0
        verticalOffset: 0
    }
}
