import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import qmlonline
import "../qt5-qml-toolkit"

Page {
    title: qsTr("About")

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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: [
                [ "Qt Version", System.qtVersion ],
                [ "Built on", BUILD_DATE + " " + BUILD_TIME ]
            ]

            delegate: Frame {
                width: ListView.view.width
                background: Rectangle {
                    color: (index & 1) ? "#e0e0e0" : "#c0c0c0"
                }

                RowLayout {
                    width: parent.width
                    Text {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 100
                        text: modelData[0]
                        font.pointSize: 10
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    Text {
                        Layout.fillWidth: true
                        Layout.preferredWidth:400
                        text: modelData[1]
                        font.pointSize: 10
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: text
            text: 'View source on <a href="https://github.com/stephenquan/qmlonline6">github.com/stephenquan/qmlonline6</a>'
            onLinkActivated: link => Qt.openUrlExternally(link)
        }

    }
}
