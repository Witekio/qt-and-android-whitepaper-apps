import QtQuick 2.0
import QtQuick.Timeline 1.0
import QtQuick.Shapes 1.0

Shape {
    width: 200
    height: 200

    property alias gradient: shape.fillGradient
    property alias strokeStyle: shape.strokeStyle
    property alias strokeWidth: shape.strokeWidth
    property alias strokeColor: shape.strokeColor
    property alias dashPattern: shape.dashPattern
    property alias joinStyle: shape.joinStyle
    property alias fillColor: shape.fillColor
    property alias path: pathSvg.path
    property alias dashOffset: shape.dashOffset

    property bool antialiasing: false
    layer.enabled: antialiasing
    layer.smooth: antialiasing
    layer.textureSize: Qt.size(width * 2, height * 2)

    id: svgPathItem

    ShapePath {
        id: shape
        strokeWidth: 4
        strokeColor: "red"

        PathSvg {
            id: pathSvg

            path: "M91,70.6c4.6,0,8.6,2.4,10.9,6.3l19.8,34.2c2.3,3.9,2.3,8.7,0,12.6c-2.3,3.9-6.4,6.3-10.9,6.3H71.2 c-4.6,0-8.6-2.4-10.9-6.3c-2.3-3.9-2.3-8.7,0-12.6l19.8-34.2C82.4,72.9,86.4,70.6,91,70.6 M91,69.6c-4.6,0-9.2,2.3-11.8,6.8l-19.8,34.2c-5.2,9.1,1.3,20.4,11.8,20.4h39.5c10.5,0,17-11.3,11.8-20.4l-19.8-34.2C100.2,71.9,95.6,69.6,91,69.6L91,69.6z"
        }
    }
}
