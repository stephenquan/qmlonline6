import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import qmlonline
import "../qt5-qml-toolkit"

Page {
    title: qsTr("Share")

    property string href: ""
    property string code: ""
    property string shareLink: makeShareLink(href, code, false)
    property string shareLink2: makeShareLink(href, code, true)

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

        contentWidth: columnLayout.width
        contentHeight: columnLayout.height
        clip: true
        ScrollBar.vertical: ScrollBar { width: 20 }

        ColumnLayout {
            id: columnLayout

            width: flickable.width - 20

            Frame {
                Layout.fillWidth: true

                TextEdit {
                    text: shareLink2
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    readOnly: true
                }
            }

            Button {
                text: qsTr("Copy (%1 bytes)").arg(shareLink2.length)
                onClicked: App.copy(shareLink2)
            }

            Frame {
                Layout.fillWidth: true

                TextEdit {
                    text: shareLink
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    readOnly: true
                }
            }

            Button {
                text: qsTr("Copy (%1 bytes)").arg(shareLink.length)
                onClicked: App.copy(shareLink)
            }
        }
    }

    function makeShareLink(href, code, compressed) {
        console.log("href: ", href);
        let urlInfo = System.urlInfo(href || "http://localhost/?a=1&b=2");
        if (compressed) {
            urlInfo.setQueryItem("code", undefined);
            urlInfo.setQueryItem("zcode", System.stringCompress(code));
        } else {
            try {
            urlInfo.setQueryItem("zcode", undefined);
            urlInfo.setQueryItem("code", code);
            } catch (err) {
                console.error(err.message);
                throw err;
            }
        }
        return urlInfo.url;
    }
}
