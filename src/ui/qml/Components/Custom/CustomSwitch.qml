import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

// Colors are only implemented for Material Style
// TODO: Implement the same colors for the other styles

Rectangle {
    id: root

    readonly property real spacing: 10
    property color backgroundColor: Material.primary
    property bool isInLeftSide: true
    property string leftText: "Left"
    property string rightText: "Right"
    property int animationsSpeed: 150
    property color textColor: Material.foreground
    property color hoveredColor: "#0A000000"
    property color pressedColor: "#1A000000"
    property real controlRadius: 40

    signal toggled()

    color: backgroundColor
    radius: controlRadius

    Button {
        id: switchButton
        clip: true

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.isInLeftSide ? spacing : root.width/2 + spacing*2
        anchors.right: parent.right
        anchors.rightMargin: root.isInLeftSide ? root.width/2 + spacing*2 : spacing

        Material.foreground: textColor

        Behavior on anchors.leftMargin  { NumberAnimation { duration: animationsSpeed; easing.type: Easing.OutQuint } }
        Behavior on anchors.rightMargin { NumberAnimation { duration: animationsSpeed; easing.type: Easing.OutQuint } }

        text: "<b>" + (root.isInLeftSide ? root.leftText : root.rightText) + "</b>"

        onClicked: {
            root.isInLeftSide = !root.isInLeftSide
            parent.toggled()
        }

        contentItem: Label {
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            text: switchButton.text
            font: switchButton.font
            color: !switchButton.enabled ? switchButton.Material.hintTextColor : switchButton.Material.foreground
        }

        background: Rectangle {
            implicitWidth: 64
            implicitHeight: switchButton.Material.buttonHeight

            radius: root.controlRadius
            color: !switchButton.enabled ? switchButton.Material.buttonDisabledColor : "white"
            Behavior on color { ColorAnimation { duration: animationsSpeed } }

            layer.enabled: switchButton.enabled && switchButton.Material.buttonColor.a > 0

            Rectangle {
                id: rectangleColorEffect
                anchors.fill: parent
                radius: root.controlRadius

                color: switchButton.down ? pressedColor : switchButton.hovered ? hoveredColor : "transparent"

                Behavior on color { ColorAnimation { duration: animationsSpeed } }
            }
        } // Rectangle (button's background)
    } // Button
}
