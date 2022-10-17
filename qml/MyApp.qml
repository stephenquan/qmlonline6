import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt6 QML Online")

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "MainPage.qml"
    } 
}
