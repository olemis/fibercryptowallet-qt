import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "Components" as Components
import "Components/Custom" as Custom
import "Components/Dialogs" as Dialogs

ApplicationWindow {
    id: applicationWindow

    width: 680
    height: 580
    visible: true
    title: Qt.application.name

    menuBar: Custom.CustomMenuBar {
        Material.elevation: 20

        onAboutRequested: {
            dialogAbout.open()
        }

        onAboutQtRequested: {
            dialogAboutQt.open()
        }

        onLicenseRequested: {
            dialogAboutLicense.open()
        }
    }

    Components.ApplicationWindowContent {
        width: parent.width
        height: parent.height
    }

    //! Application-level actions and dialogs

    // Fullscreen
    Action {
        property int previous: applicationWindow.visibility

        shortcut: StandardKey.FullScreen
        onTriggered: {
            if (applicationWindow.visibility !== Window.FullScreen) {
                previous = applicationWindow.visibility
            }
            if (applicationWindow.visibility === Window.FullScreen) {
                applicationWindow.showNormal() // Cannot show maximized directly due to a bug in some X11 managers
                if (previous === Window.Maximized) {
                    applicationWindow.showMaximized()
                }
            } else {
                applicationWindow.showFullScreen()
            }
        }
    }

    // Input dialogs
    Dialogs.DialogSimpleInput {
        id: dialogSimpleInput

        readonly property real singleItemHeight: applicationWindow.height > (promptMessage ? 220 : 200) ? (promptMessage ? 220 : 200) - 40 : applicationWindow.height - 40
        readonly property real doubleItemHeight: applicationWindow.height > (promptMessage ? 280 : 250) ? (promptMessage ? 280 : 250) - 40 : applicationWindow.height - 40

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 300 ? 300 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > implicitHeight + 40 ? implicitHeight : applicationWindow.height - 40
        //height: inputType <= Dialogs.DialogSimpleInput.InputType.Number ? singleItemHeight : doubleItemHeight
        focus: visible
        modal: true
    }

    // Help dialogs
    Dialogs.DialogAbout {
        id: dialogAbout

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
        focus: visible
        modal: true

        onLicenseRequested: {
            close()
            dialogAboutLicense.open()
        }
    }

    Dialogs.DialogAboutQt {
        id: dialogAboutQt

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
        focus: visible
        modal: true
    }

    Dialogs.DialogAboutLicense {
        id: dialogAboutLicense

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width - 40
        height: applicationWindow.height - 40
        focus: visible
        modal: true
    }
}