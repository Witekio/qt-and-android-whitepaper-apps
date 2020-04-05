import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Shapes 1.0

Shape {
    id: root

    implicitWidth: 100
    implicitHeight: 100

    property alias gradient: path.fillGradient
    property alias strokeStyle: path.strokeStyle
    property alias strokeWidth: path.strokeWidth
    property alias strokeColor: path.strokeColor
    property alias dashPattern: path.dashPattern
    property alias joinStyle: path.joinStyle
    property alias fillColor: path.fillColor
    property alias capStyle: path.capStyle
    property alias dashOffset: path.dashOffset

    property real begin: 0
    property real end: 90

    property real arcWidth: 10

    property real alpha: end - begin

    property bool antialiasing: false
    layer.enabled: antialiasing
    layer.smooth: antialiasing
    layer.textureSize: Qt.size(width * 2, height * 2)
    property bool outlineArc: false

    function myCos(angleInDegrees) {
        var angleInRadians = angleInDegrees * Math.PI / 180.0
        return Math.cos(angleInRadians)
    }

    function mySin(angleInDegrees) {
        var angleInRadians = angleInDegrees * Math.PI / 180.0
        return Math.sin(angleInRadians)
    }

    function polarToCartesianX(centerX, centerY, radius, angleInDegrees) {
        var angleInRadians = angleInDegrees * Math.PI / 180.0
        var x = centerX + radius * Math.cos(angleInRadians)
        return x
    }

    function polarToCartesianY(centerX, centerY, radius, angleInDegrees) {
        var angleInRadians = angleInDegrees * Math.PI / 180.0
        var y = centerY + radius * Math.sin(angleInRadians)
        return y
    }

    function calc() {
        path.__xRadius = root.width / 2 - root.strokeWidth / 2
        path.__yRadius = root.height / 2 - root.strokeWidth / 2

        path.__Xcenter = root.width / 2
        path.__Ycenter = root.height / 2

        path.startX = root.polarToCartesianX(path.__Xcenter, path.__Ycenter,
                                             path.__xRadius, root.begin - 180)
        path.startY = root.polarToCartesianY(path.__Xcenter, path.__Ycenter,
                                             path.__yRadius, root.begin - 180)

        arc1.x = root.polarToCartesianX(path.__Xcenter, path.__Ycenter,
                                        path.__xRadius, root.end - 180)
        arc1.y = root.polarToCartesianY(path.__Xcenter, path.__Ycenter,
                                        path.__yRadius, root.end - 180)

        arc1.radiusY = path.__yRadius
        arc1.radiusX = path.__xRadius

        arc1.useLargeArc = root.alpha > 180
    }

    onWidthChanged: calc()
    onBeginChanged: calc()
    onEndChanged: calc()
    onAlphaChanged: calc()

    ShapePath {
        //closed: true
        id: path

        property real __xRadius
        property real __yRadius

        property real __Xcenter
        property real __Ycenter

        fillColor: "transparent"
        strokeColor: Qt.transparent
        strokeWidth: 1
        capStyle: ShapePath.FlatCap
    }

    Item {
        id: shapes
        PathArc {
            id: arc1
            property bool add: true
        }

        PathLine {
            relativeX: root.arcWidth * myCos(root.end)
            relativeY: root.arcWidth * mySin(root.end)
            property bool add: root.outlineArc && root.alpha < 360
        }

        PathMove {
            relativeX: root.arcWidth * myCos(root.end)
            relativeY: root.arcWidth * mySin(root.end)
            property bool add: root.outlineArc && root.alpha == 360
        }

        PathArc {
            id: arc2
            useLargeArc: arc1.useLargeArc
            radiusX: arc1.radiusX - root.arcWidth
            radiusY: arc1.radiusY - root.arcWidth

            x: path.startX + root.arcWidth * myCos(root.begin)
            y: path.startY + root.arcWidth * mySin(root.begin)

            direction: PathArc.Counterclockwise

            property bool add: root.outlineArc
        }

        PathLine {
            x: path.startX
            y: path.startY
            property bool add: root.outlineArc && root.alpha < 360
        }

        PathMove {
            x: path.startX
            y: path.startY
            property bool add: root.outlineArc && root.alpha == 360
        }
    }

    function invalidatePaths() {
        if (!root.__completed)
            return

        for (var i = 0; i < shapes.resources.length; i++) {
            var s = shapes.resources[i]
            if (s.add)
                path.pathElements.push(s)
        }
    }

    property bool __completed: false

    Component.onCompleted: {
        root.__completed = true
        invalidatePaths()
        calc()
    }
}
