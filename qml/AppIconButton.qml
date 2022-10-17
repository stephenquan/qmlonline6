import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: iconButton
    property alias icon: button.icon
    signal clicked()
    Layout.preferredWidth: 32
    Layout.preferredHeight: 32
    clip: true
    Button {
        id: button
        anchors.centerIn: parent
        background: Item { }
        icon.width: parent.width
        icon.height: parent.height
        icon.color: "snow"
        onClicked: iconButton.clicked()
    }
}

