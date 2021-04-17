import QtQuick 2.0
import Sailfish.Silica 1.0
import Process 1.0
import Nemo.Notifications 1.0
import Nemo.Configuration 1.0

Page {

    id: page
    allowedOrientations: Orientation.PortraitMask
    property string itemCopied
    property bool allItemDetails
    property int searchFieldMargin

    SilicaListView {

        id: itemListView
        currentIndex: -1
        model: itemListModel
        anchors.fill: parent

        PullDownMenu {

            visible: settings.skipVaultScreen // will be visible should user opt to skip Vault screen, option not yet enabled.

            MenuItem {

                text: qsTr("Settings")

                onClicked: {

                    pageStack.push(Qt.resolvedUrl("Settings.qml"));

                }

            }

        }

        header: SearchField {

            id: searchField
            width: parent.width
            placeholderText: qsTr("Search items")

            Component.onCompleted: {

                searchFieldMargin = this.textLeftMargin; // to get around errors with alias and direct identification of searchField not functioning as expected.
                if (searchField.text === "") searchField.forceActiveFocus();

            }

            onTextChanged: {

                itemListModel.update(text);

            }

            EnterKey.onClicked: {

                // needs to be at least one result to work with and not a full list / empty field.
                if (itemListModel.count > 0 && text.length > 0) {

                    if (settings.enterKeyLoadsDetails) {

                        loadingItemBusy.running = true;
                        allItemDetails = true;
                        getPassword.start("op", ["get", "item", itemListModel.get(0).uuid, "--session", currentSession]);

                    }

                    else {

                        itemCopied = itemListModel.get(0).title;
                        allItemDetails = false;
                        getPassword.start("op", ["get", "item", itemListModel.get(0).uuid, "--fields", "password", "--session", currentSession]);

                    }

                    searchField.focus = false;
                    searchField.text = "";

                }

                else if (text === "") searchField.focus = false;

            }

        }

        delegate: Column {

            id: delegateColumn
            width: parent.width
            height: itemRow.height

            Row {

                width: parent.width
                id: itemRow
                spacing: Theme.paddingMedium

                BackgroundItem {

                    id: delegate

                    Label {

                        anchors {

                            left: parent.left
                            leftMargin: searchFieldMargin
                            verticalCenter: parent.verticalCenter

                        }

                        text: title
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor

                    }

                    onClicked: {

                        if (settings.tapToCopy) {

                            itemCopied = title;
                            allItemDetails = false;
                            getPassword.start("op", ["get", "item", uuid, "--fields", "password", "--session", currentSession]);

                        }

                        else {

                            allItemDetails = true;
                            loadingItemBusy.running = true;
                            getPassword.start("op", ["get", "item", uuid, "--session", currentSession]);

                        }

                    }

                    onPressAndHold: {

                        if (settings.tapToCopy) {

                            allItemDetails = true;
                            loadingItemBusy.running = true;
                            getPassword.start("op", ["get", "item", uuid, "--session", currentSession]);



                        }

                        else {

                            itemCopied = title;
                            allItemDetails = false;
                            getPassword.start("op", ["get", "item", uuid, "--fields", "password", "--session", currentSession]);

                        }

                    }

                }

            }

        }

        VerticalScrollDecorator { }

    }

    Process {

        id: getPassword

        onReadyReadStandardOutput: {

            sessionExpiryTimer.restart();

            if (allItemDetails) { // load item details and move to itemDetails page

                singleItemUsername = ""; // incase none is returned from CLI
                singleItemPassword = "";
                itemDetailsModel.clear();
                var prelimOutput = readAllStandardOutput();
                itemDetails = JSON.parse(prelimOutput);

                for (var i = 0; i < itemDetails.details.fields.length; i++) {

                    switch (itemDetails.details.fields[i].designation) {

                    case "username":

                        singleItemUsername = itemDetails.details.fields[i].value;
                        break;

                    case "password":

                        singleItemPassword = itemDetails.details.fields[i].value;

                    }

                }

                itemDetailsModel.append({"uuid": itemDetails.uuid, "itemTitle": itemDetails.overview.title, "username": singleItemUsername, "password": singleItemPassword, "website": itemDetails.overview.url});
                singleItemPassword = "0000000000000000000000000000000000000000000000000000000000000000";
                singleItemPassword = "";
                singleItemUsername = "0000000000000000000000000000000000000000000000000000000000000000";
                singleItemUsername = "";
                loadingItemBusy.running = false;
                pageStack.push(Qt.resolvedUrl("ItemDetails.qml"));

            }

            else { // Just the password to be copied to clipboard.

                Clipboard.text = readAllStandardOutput();
                passwordCopied.previewSummary = itemCopied + qsTr(" copied.");
                passwordCopied.publish();

            }

        }

        onReadyReadStandardError: {

            sessionExpiryTimer.restart();

            if (allItemDetails) {

                passwordCopied.previewSummary = qsTr("Error - Unable to load item details.");
                passwordCopied.body = readAllStandardError();
                passwordCopied.urgency = Notification.Medium;
                passwordCopied.publish();
                passwordCopied.urgency = Notification.Low; // back to normal setting

            }

            else {

                passwordCopied.previewSummary = qsTr("Error - Password not copied.");
                passwordCopied.body = readAllStandardError();
                passwordCopied.urgency = Notification.Medium;
                passwordCopied.publish();
                passwordCopied.urgency = Notification.Low; // back to normal setting

            }

        }

    }

    Notification {

        id: passwordCopied
        appName: "QuayCentral"
        urgency: Notification.Low
        isTransient: true
        expireTimeout: 1500

    }

    BusyIndicator {

        id: loadingItemBusy
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: false

    }

}