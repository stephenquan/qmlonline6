import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../qt5-qml-toolkit"

Page {
    title: qsTr("Share")

    property string shareLink: ""

    header: Frame {
        background: Rectangle {
            color: "steelblue"
        }

        RowLayout {
            width: parent.width
            AppIconButton {
                icon.source: "images/chevron-left-32.svg"
                onClicked: stackView.pop()
            }
            Text {
                Layout.fillWidth: true
                text: title
                color: "snow"
            }
        }
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: 10

        contentWidth: textEdit.width
        contentHeight: textEdit.height
        clip: true

        TextEdit {
            id: textEdit
            text: shareLink
            width: flickable.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            readOnly: true
            Component.onCompleted: textEdit.selectAll()
        }
    }
}
