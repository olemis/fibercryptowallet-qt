import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Dialogs" as Dialogs
import "../Controls" as Controls

Page {
    id: pageSendSimple

    property bool activated: true

    property string walletSelected
    property string walletSelectedName
    property string signerSelected
    property bool walletEncrypted: false
    property string amount
    property string destinationAddress

    signal qrCodeRequested(var data)

    // refactor this
    function walletIsEncrypted() {
        return [walletSelected, walletSelectedName, walletEncrypted]
    }

    function getAddressList() {
        addressList.clear()
        console.log("Contacts requested to fill the addresses model")
        /*
        for(var i=0;i<abm.count;i++){
            for(var j=0;j<abm.contacts[i].address.rowCount();j++){
                addressList.append({name:abm.contacts[i].name,
                                       address:abm.contacts[i].address.address[j].value,
                                       coinType:abm.contacts[i].address.address[j].coinType})
            }
        }
        */
    }

    onQrCodeRequested: {
        console.log("QR requested...")
    }

    visible: opacity > 0
    implicitHeight: labelSendFrom.height + comboBoxWalletsSendFrom.height + comboBoxChangeSigner.height + labelSendTo.height + textFieldDestinationAddress.height + textFieldAmount.height + 80

    Label {
        id: labelSendFrom

        text: qsTr("Send from")
        font.bold: true
    }
                
    ComboBox {
        id: comboBoxWalletsSendFrom

        y: labelSendFrom.y + labelSendFrom.height + 6
        width: parent.width
        textRole: "name"
        displayText: comboBoxWalletsSendFrom.model.wallets && comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex] && comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].sky ? comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].name + " - " + comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].sky + " SKY (" + comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].coinHours + " CoinHours)" : qsTr("Select a wallet")
        model: listWallets

        // Taken from Qt 5.13.0 source code:
        delegate: MenuItem {
            width: parent.width
            text: comboBoxWalletsSendFrom.textRole ?
                      (Array.isArray(comboBoxWalletsSendFrom.model) ?
                           modelData[comboBoxWalletsSendFrom.textRole]
                         : model[comboBoxWalletsSendFrom.textRole] + " - " + model["sky"] + " SKY (" + model["coinHours"] + " CoinHours)") :
                      " --- " + modelData
            Material.foreground: ~~comboBoxWalletsSendFrom.currentIndex === ~~index ? parent.Material.accent : parent.Material.foreground
            highlighted: ~~comboBoxWalletsSendFrom.highlightedIndex === ~~index
            hoverEnabled: comboBoxWalletsSendFrom.hoverEnabled
            leftPadding: highlighted ? 2*padding : padding // added
            Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added
        }
        onPressedChanged: {
            //comboBoxWalletsSendFrom.model.updateModel(walletManager.getWallets())
        }
        onActivated: {
            pageSendSimple.walletSelected = comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].fileName
            pageSendSimple.walletSelectedName = comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].name
            pageSendSimple.walletEncrypted = comboBoxWalletsSendFrom.model.wallets[comboBoxWalletsSendFrom.currentIndex].encryptionEnabled
            comboBoxChangeSigner.reset(pageSendSimple.walletSelected)
        }
    } // ComboBox (send from)

    Label {
        id: labelChangeSigner

        x: labelSendFrom.x
        y: comboBoxWalletsSendFrom.y + comboBoxWalletsSendFrom.height + 10
        height: visible ? implicitHeight : 0
        visible: comboBoxChangeSigner.visible
        text: qsTr("Change signer")
    }

    ComboBox {
        id: comboBoxChangeSigner

        function reset(wltId) {
            currentIndex = 0
            //signerModelId.loadModel(wltId)
            //comboBoxChangeSigner.visible = signerModelId.rowCount() > 1
        }

        x: labelChangeSigner.x + labelChangeSigner.width + 6
        y: labelChangeSigner.y + (labelChangeSigner.height - height)/2
        width: parent.width - x
        height: visible ? implicitHeight : 0
        visible: false
        textRole: "description"
        model: 3/*SignerModel {
            id: signerModelId
        }*/

        // Taken from Qt 5.13.0 source code:
        delegate: MenuItem {
            id: selectedSignerDelegateId
            width: parent.width
            text: comboBoxChangeSigner.textRole ?
                      (Array.isArray(comboBoxChangeSigner.model)
                       ? modelData[comboBoxChangeSigner.textRole]
                       : model[comboBoxChangeSigner.textRole])
                    : modelData
            Material.foreground: ~~comboBoxChangeSigner.currentIndex === ~~index ? parent.Material.accent : parent.Material.foreground
            highlighted: ~~comboBoxChangeSigner.highlightedIndex === ~~index
            hoverEnabled: comboBoxChangeSigner.hoverEnabled
            leftPadding: highlighted ? 2*padding : padding // added
            Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added
            onClicked: {
                pageSendSimple.signerSelected = Array.isArray(comboBoxChangeSigner.model) ? modelData["id"] : model["id"];
            }
        }
    } // ComboBox (signer selector)


    Label {
        id: labelSendTo

        x: labelSendFrom.x
        y: comboBoxChangeSigner.y + comboBoxChangeSigner.height + 12
        text: qsTr("Send to")
        font.bold: true
    }

    Button {
        id: buttonSelectAddress

        x: labelSendFrom.x
        y: labelSendTo.y + labelSendTo.height + 6
        text: qsTr("Select")
        flat: true
        highlighted: true

        onClicked: {
            console.log("Contacts requested")
            /*
            if (abm.getSecType() !== 2) { // need an enum here
                abm.loadContacts()
                dialogSelectAddressByAddressBook.open()
            } else {
                getpass.open()
            }
            */
        }
    }

    Controls.TextField {
        id: textFieldDestinationAddress

        x: buttonSelectAddress.x + buttonSelectAddress.width + 6
        y: buttonSelectAddress.y + (buttonSelectAddress.height - height)/2
        width: parent.width - x
        font.family: "Code New Roman"
        placeholderText: qsTr("Destination address")
        selectByMouse: true
        //Material.accent: abm.addressIsValid(text) ? parent.Material.accent : Material.color(Material.Red)
        onTextChanged: {
            pageSendSimple.destinationAddress = text
        }
    }

    Controls.TextField {
        id: textFieldAmount

        x: labelSendFrom.x
        y: textFieldDestinationAddress.y + textFieldDestinationAddress.height + 6
        width: parent.width - x
        placeholderText: qsTr("Amount to send")
        selectByMouse: true
        validator: DoubleValidator {
            notation: DoubleValidator.StandardNotation
        }
        onTextChanged: {
            pageSendSimple.amount = text
        }
    }

    ListModel {
        id: addressList
    }

    // Copypasted from PageWallets
    ListModel {
        id: listWallets
        ListElement { name: "My first wallet";   hasHardwareWallet: false; encryptionEnabled: true;  sky: 5;    coinHours: 10 }
        ListElement { name: "My second wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 300;  coinHours: 1049 }
        ListElement { name: "My third wallet";   hasHardwareWallet: true;  encryptionEnabled: false; sky: 13;   coinHours: 201 }

        ListElement { name: "My fourth wallet";  hasHardwareWallet: true;  encryptionEnabled: false; sky: 3941; coinHours: 6652 }
        ListElement { name: "My fiveth wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 9;    coinHours: 35448 }
        ListElement { name: "My sixth wallet";   hasHardwareWallet: true;  encryptionEnabled: true;  sky: 439;  coinHours: 685 }

        ListElement { name: "My seventh wallet"; hasHardwareWallet: false; encryptionEnabled: true;  sky: 22;   coinHours: 315 }
        ListElement { name: "My eighth wallet";  hasHardwareWallet: true;  encryptionEnabled: false; sky: 2001; coinHours: 10628 }
        ListElement { name: "My nineth wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 93;   coinHours: 381 }
    }

    /*
    AddrsBookModel {
        id: abm
    }

    DialogSelectAddressByAddressBook {
        id: dialogSelectAddressByAddressBook

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height - 40

        listAddrsModel: addressList

        focus: true
        modal: true

        onAboutToShow: {
            getAddressList()
        }

        onAccepted: {
            textFieldWalletsSendTo.text = selectedAddress
        }
    }

    DialogGetPassword {
        id: getpass

        anchors.centerIn: Overlay.overlay
        height: 180
        onAccepted: {
            if (!abm.authenticate(getpass.password)) {
                getpass.open()
            } else {
                abm.loadContacts()
                dialogSelectAddressByAddressBook.open()
            }
        }
    }
    */

    states: [
        State {
            name: "visible"; when: activated
            PropertyChanges {
                target: pageSendSimple
                scale: 1.0
                opacity: 1.0
            }
        },
        State {
            name: "hidden"; when: !activated
            PropertyChanges {
                target: pageSendSimple
                scale: 0.9
                opacity: 0.0
            }
        }
    ]

    transitions: [
        Transition {
            reversible: true
            NumberAnimation { property: "scale"; easing.type: Easing.OutQuint; duration: 170 }
            NumberAnimation { property: "opacity"; easing.type: Easing.OutCubic; duration: 100 }
        }
    ]
}