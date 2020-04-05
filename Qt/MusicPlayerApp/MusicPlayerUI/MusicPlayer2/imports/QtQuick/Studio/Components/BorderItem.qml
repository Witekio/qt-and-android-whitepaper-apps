import QtQuick 2.10
import QtQuick.Shapes 1.0

Shape {
    id: root
    width: 200
    height: 150

    property int radius: 10

    property int topLeftRadius: radius
    property int bottomLeftRadius: radius
    property int topRightRadius: radius
    property int bottomRightRadius: radius

    //property alias gradient: path.fillGradient
    property alias strokeStyle: path.strokeStyle
    property alias strokeWidth: path.strokeWidth
    property alias strokeColor: path.strokeColor
    property alias dashPattern: path.dashPattern
    property alias joinStyle: path.joinStyle
    property alias dashOffset: path.dashOffset

    //property alias fillColor: path.fillColor
    property bool drawTop: true
    property bool drawBottom: true
    property bool drawRight: true
    property bool drawLeft: true

    property bool antialiasing: false
    layer.enabled: antialiasing
    layer.smooth: antialiasing
    layer.textureSize: Qt.size(width * 2, height * 2)

    Item {
        anchors.fill: parent
        anchors.margins: -root.strokeWidth / 2
    }

    ShapePath {
        id: path
        joinStyle: ShapePath.MiterJoin

        strokeWidth: 4
        strokeColor: "red"
        fillColor: "transparent"

        startX: root.topLeftRadius
        startY: 0
    }

    Item {
        id: shapes

        PathLine {
            x: root.width - root.topRightRadius
            y: 0
            property bool add: root.drawTop
        }

        PathArc {
            x: root.width
            y: root.topRightRadius
            radiusX: root.topRightRadius
            radiusY: root.topRightRadius
            property bool add: root.drawTop && root.drawRight
        }

        PathMove {
            x: root.width
            y: root.topRightRadius
            property bool add: !root.drawTop
        }

        PathLine {
            x: root.width
            y: root.height - root.bottomRightRadius
            property bool add: root.drawRight
        }

        PathArc {
            x: root.width - root.bottomRightRadius
            y: root.height
            radiusX: root.bottomRightRadius
            radiusY: root.bottomRightRadius
            property bool add: root.drawRight && root.drawBottom
        }

        PathMove {
            x: root.width - root.bottomRightRadius
            y: root.height
            property bool add: !root.drawRight
        }

        PathLine {
            x: root.bottomLeftRadius
            y: root.height
            property bool add: root.drawBottom
        }

        PathArc {
            x: 0
            y: root.height - root.bottomLeftRadius
            radiusX: root.bottomLeftRadius
            radiusY: root.bottomLeftRadius
            property bool add: root.drawBottom && root.drawLeft
        }

        PathMove {
            x: 0
            y: root.height - root.bottomLeftRadius
            property bool add: !root.drawBottom
        }

        PathLine {
            x: 0
            y: root.topLeftRadius
            property bool add: root.drawLeft
        }

        PathArc {
            x: root.topLeftRadius
            y: 0
            radiusX: root.topLeftRadius
            radiusY: root.topLeftRadius
            property bool add: root.drawTop && root.drawLeft
        }
    }

    //onDrawBottomChanged: invalidatePaths()
    //onDrawTopChanged: invalidatePaths()
    //onDrawLeftChanged: invalidatePaths()
    //onDrawRightChanged: invalidatePaths()
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
    }
}
