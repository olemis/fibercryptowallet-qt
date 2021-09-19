import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
//import QtGraphicalEffects

import FiberCryptoWallet as Backend

import "../Dialogs/" as Dialogs

Item {
    id: root

    property bool emptyAddressVisible: true
    property bool expanded: false

    signal addAddressesRequested()
    signal editWalletRequested()
    signal toggleEncryptionRequested()


    onEditWalletRequested: {
        // dialogEditWallet.originalWalletName = name
        // dialogEditWallet.name = name
        // dialogEditWallet.open()
    }
    onToggleEncryptionRequested: {
        if (encryptionEnabled) {
            // dialogGetPassword.addAddress = false
            // dialogGetPassword.open()
        } else {
            // dialogSetPassword.open()
        }
    }

    width: parent ? parent.width : width
    height: itemDelegateMainButton.height
    clip: true

    states: State {
        name: "expanded"
        when: expanded
        PropertyChanges { target: root; height: itemDelegateMainButton.height + addressList.height }
    }
    transitions: Transition {
        NumberAnimation { property: "height"; duration: 250; easing.type: Easing.OutQuint }
    }

    ItemDelegate {
        id: itemDelegateMainButton
        width: parent.width
        font.bold: expanded

        Image {
            id: imageStatus
            y: (parent.height - height)/2
            width: 16
            source: statusIcon
            sourceSize: "16x16"
        }

        Label {
            id: labelWalletName

            x: imageStatus.width + 4
            y: (parent.height - height)/2
            width: itemImageLockIcon.x - x
            text: name // a role of the model
        }

        Item {
            id: itemImageLockIcon

            x: labelSky.x - width
            y: (parent.height - height)/2
            width: lockIcon.width
            height: lockIcon.height

            Image {
                id: lockIcon
                source: "qrc:/images/icons/toggle/lock_" + (encryptionEnabled ? "on" : "off") + ".svg"
                sourceSize: "24x24"
            }

            /*
            ColorOverlay {
                anchors.fill: lockIcon
                source: lockIcon
                color: Material.theme === Material.Dark ? Material.foreground : "undefined"
            }
            */
        }

        Label {
            id: labelSky

            x: labelCoinHours.x - width
            y: (parent.height - height)/2
            width: 70
            horizontalAlignment: Text.AlignRight
            text: sky === qsTr("N/A") ? "" : sky // a role of the model
            color: Material.accent

            BusyIndicator {
                x: parent.width - width
                y: (parent.height - height)/2
                implicitWidth: implicitHeight
                implicitHeight: parent.height + 10
                running: sky === qsTr("N/A") ? true : false
            }
        }

        Label {
            id: labelCoinHours

            y: (parent.height - height)/2
            x: parent.width - width - 10
            width: 70
            horizontalAlignment: Text.AlignRight
            text: coinHours // a role of the model
        }

        onReleased: {
            expanded = !expanded
            // walletModel.changeExpanded(fileName)
        }
    } // ItemDelegate

    ListView {
        id: addressList

        y: itemDelegateMainButton.y + itemDelegateMainButton.height
        width: parent.width
        height: contentHeight
        model: listAddresses
        opacity: expanded ? 1.0 : 0.0
        clip: true
        interactive: false

        Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
        Behavior on opacity { NumberAnimation { duration: expanded ? 250 : 1000; easing.type: Easing.OutQuint } }

        header: Pane {
            z: 2
            width: parent.width
            height: buttonAddAddress.height
            padding: 0

            ToolButton {
                id: buttonAddAddress

                x: 2
                width: parent.width/4 - 1
                text: qsTr("Add address")
                icon.source: "qrc:/images/icons/actions/add.svg"
                Material.accent: Material.Teal
                Material.foreground: Material.accent

                onClicked: {
                    addAddressesRequested()
                }
            }
            ToolButton {
                id: buttonToggleVisibility

                x: buttonAddAddress.x + buttonAddAddress.width
                width: buttonAddAddress.width
                text: qsTr("Show empty")
                checkable: true
                checked: emptyAddressVisible
                icon.source: "qrc:/images/icons/toggle/visibility_" + (checked ? "on" : "off") + ".svg"
                Material.accent: Material.Indigo
                Material.foreground: Material.Grey

                onCheckedChanged: {
                    emptyAddressVisible = checked
                }
            }
            ToolButton {
                id: buttonToggleEncryption

                x: buttonToggleVisibility.x + buttonToggleVisibility.width
                width: buttonAddAddress.width
                text: checked ? qsTr("Decrypt wallet") : qsTr("Encrypt wallet")
                checkable: true
                checked: encryptionEnabled
                icon.source: "qrc:/images/icons/toggle/lock_" + (checked ? "on" : "off") + ".svg"
                Material.accent: Material.Amber
                Material.foreground: Material.Grey

                onClicked: {
                    toggleEncryptionRequested()
                }
            }
            ToolButton {
                id: buttonEdit

                x: buttonToggleEncryption.x + buttonToggleEncryption.width
                width: buttonAddAddress.width
                text: qsTr("Edit wallet")
                icon.source: "qrc:/images/icons/actions/edit.svg"
                Material.accent: Material.Blue
                Material.foreground: Material.accent

                onClicked: {
                    editWalletRequested()
                }
            }
        }

        delegate: DelegateWalletAddress {
            width: parent.width

            Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuint } }
        }

    } // ListView

    // Roles: address, addressSky, addressCoinHours
    // Use listModel.append( { "address": value, "addressSky": value, "addressCoinHours": value } )
    // Or implement the model in the backend (a more recommendable approach)
    ListModel {
        id: listAddresses
        ListElement { address: "llaksjdlkajsdyagwdh"; addressSky: 5;    addressCoinHours: 10 }
        ListElement { address: "oeifhdskfjhkudsafja"; addressSky: 300;  addressCoinHours: 1049 }
        ListElement { address: "rqiweladskhdflkdsft"; addressSky: 13;   addressCoinHours: 201 }

        ListElement { address: "mvkjsdnhuaydiauksjd"; addressSky: 3941; addressCoinHours: 6652 }
        ListElement { address: "vscytafdhsdhjxhcdjs"; addressSky: 0;    addressCoinHours: 35448 }
        ListElement { address: "dsjnhffaskdfhnkdjhu"; addressSky: 439;  addressCoinHours: 685 }

        ListElement { address: "zsdfjsdhcmhjsdkfhjs"; addressSky: 0;   addressCoinHours: 315 }
        ListElement { address: "oidhfkusjdhfnhadgfe"; addressSky: 0; addressCoinHours: 10628 }
        ListElement { address: "eydsjjfndshgnjsdehd"; addressSky: 93;   addressCoinHours: 381 }
    }

    /*

    DialogEditWallet {
        id: dialogEditWallet
        anchors.centerIn: Overlay.overlay

        focus: true
        modal: true

        onAccepted: {
            var qwallet = walletManager.editWallet(fileName, name)
            walletModel.editWallet(index, qwallet.name, encryptionEnabled, qwallet.sky, qwallet.coinHours )
        }
    } // DialogEditWallet

//    Backend.AddressModel {
//        id: listAddresses
//    }
    Component.onCompleted: {
        listAddresses.updateModel(fileName)
        listAddresses.suscribe(fileName)
    }
    */
}