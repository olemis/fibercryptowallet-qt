import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Flickable {
    id: contentSimpleInput

    property alias promptMessage: labelPrompt.text
    property alias promptMessageColor: labelPrompt.color

    property alias textValue: textField.text
    property alias textPlaceholder: textField.placeholderText
    property alias textColorPlaceholder: textField.placeholderTextColor
    property alias textEchoMode: textField.echoMode

    property alias textValue2: textField2.text
    property alias textPlaceholder2: textField2.placeholderText
    property alias textColorPlaceholder2: textField2.placeholderTextColor
    property alias textEchoMode2: textField2.echoMode

    property alias numericValue: spinBox.value
    property alias numericFrom: spinBox.from
    property alias numericTo: spinBox.to
    property alias numericStepSize: spinBox.stepSize

    contentWidth: width
    contentHeight: Math.max(textField2.y + textField2.height, spinBox.y + spinBox.height) + 6
    implicitWidth: contentWidth
    implicitHeight: contentHeight
    clip: true

    Label {
        id: labelPrompt

        width: parent.width
        height: text ? contentHeight : 0
        wrapMode: Label.Wrap
    }

    UI.TextField {
        id: textField

        y: inputType === UI.DialogSimpleInput.InputType.NumberText ? spinBox.y + spinBox.height + 12 : labelPrompt.y + (labelPrompt.height ? labelPrompt.height + 12 : 4)
        width: visible ? parent.width : 0
        height: visible ? implicitHeight : 0
        visible: inputType !== UI.DialogSimpleInput.InputType.Number
        focus: visible
        placeholderText: qsTr("Start typing...")
    }

    UI.TextField {
        id: textField2

        y: textField.y + textField.height + 12
        width: visible ? parent.width : 0
        height: visible ? implicitHeight : 0
        visible: inputType === UI.DialogSimpleInput.InputType.TextText
        focus: visible && inputType !== UI.DialogSimpleInput.InputType.TextText
        placeholderText: qsTr("Start typing...")
    }

    SpinBox {
        id: spinBox

        y: inputType === UI.DialogSimpleInput.InputType.TextNumber ? textField.y + textField.height + 10 : labelPrompt.y + labelPrompt.height + 10
        width: visible ? parent.width : 0
        height: visible ? implicitHeight : 0
        visible: inputType !== UI.DialogSimpleInput.InputType.Text && inputType !== UI.DialogSimpleInput.InputType.TextText
        focus: visible && inputType !== UI.DialogSimpleInput.InputType.TextNumber
        from: 1
        to: 100
        value: 1
        editable: true
    }

    ScrollBar.vertical: UI.ScrollBar { }
} // Flickable
