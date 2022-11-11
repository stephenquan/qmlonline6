import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import QtQuick3D
import "../qt5-qml-toolkit"
import qmlonline 1.0

//Test:

// Failed: 
//import QtQuick3D 1.15
//import QtQuick3D.Materials
//import QtQuick3D.Effects

Page {
    property string errorString: ""

    header: Frame {
        background: Rectangle {
            color: "steelblue"
        }

        RowLayout {
            width: parent.width
            Text {
                Layout.fillWidth: true
                text: app.title
                color: "snow"
            }
            AppIconButton {
                icon.source: "images/handle-vertical-32.svg"
                onClicked: menu.visible = true
            }
        }
    }

    SplitView {
        anchors.fill: parent
        SplitView {
            orientation: Qt.Vertical
            SplitView.preferredWidth: parent.width/3
            CodeEdit {
                id: codeEdit
                SplitView.preferredHeight: parent.height - 200
                font.family: Qt.platform.os === "wasm"
                             ? "DejaVu Sans Mono"
                             : "Courier"
                onTextChanged: Qt.callLater(compile)
            }
            Frame {
                Text {
                    anchors.fill: parent
                    text: errorString
                    color: "red"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }
        RunView {
            id: runView
        }
    }

    footer: Frame {
        background: Rectangle { color: "#eee" }

        RowLayout {
            width: parent.width

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Built on %1 %2").arg(BUILD_DATE).arg(BUILD_TIME)
                font.pointSize: 10
            }
        }
    }

    Menu {
        id: menu
        x: parent.width - width
        y: 0
        MenuItem {
            icon.source: "images/share-32.svg"
            text: qsTr("Share")
            //enabled: Qt.platform.os === "wasm"
            onTriggered: share()
        }
        MenuItem {
            icon.source: "images/information-32.svg"
            text: qsTr("About")
            onTriggered: stackView.push("AboutPage.qml")
        }
    }

    SyntaxHighlighter {
        textDocument: codeEdit.textDocument
    }

    function compile() {
        try {
            errorString = "";
            Engine.clearComponentCache();
            Engine.trimComponentCache();
            let mainFile = "";
            let mainText = "";
            let sourceFile = mainFile;
            let sourceText = "";
            for (let line of codeEdit.text.split(/\r?\n/)) {
                let m = line.match(/^\/\/\s*([\w_.-]+\.\w{3}|qmldir)$/);
                if (m) {
                    if (sourceFile) {
                        FileSystem.tempFolder.writeTextFile(sourceFile, sourceText);
                        if (!mainFile) {
                            mainFile = sourceFile;
                            mainText = sourceText;
                        }
                    }
                    sourceFile = m[1] || m[2];
                    sourceText = "";
                    continue;
                }
                if (!sourceFile) {
                    sourceFile = "Main.qml";
                }
                sourceText += line + "\n";
            }
            FileSystem.tempFolder.writeTextFile(sourceFile, sourceText);
            if (!mainFile) {
                mainFile = sourceFile;
                mainText = sourceText;
            }
            runView.compile(mainText || sourceText, FileSystem.tempFolder.fileUrl(mainFile));
        } catch (err) {
            console.error(err.message);
            errorString = err.message;
        }
    }

    function share() {
        //let shareLink = App.href + "?code=" + encodeURIComponent(codeEdit.text);
        //let shareLink = App.href + "?zcode=" + encodeURIComponent(System.stringCompress(codeEdit.text));
        //let m = (App.href + "").match(/(.*)(zcode|code)(=)(.*)/);
        //if (m) {
            //shareLink = m[1] + "zcode=" + encodeURIComponent(System.stringCompress(codeEdit.text));
        //}
        stackView.push("SharePage.qml", { href: App.href, code: codeEdit.text } );
    }

    Component.onCompleted: {
        let code = "";
        let m = (App.href + "").match(/code=(.*)/);
        if (m) {
            code = decodeURIComponent(m[1]);
        }
        m = (App.href + "").match(/zcode=(.*)/);
        if (m) {
            code = System.stringUncompress(decodeURIComponent(m[1]));
        }
        if (!code) {
            code =
`import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
Page {
    background: Rectangle { color: "#848895" }
    Node {
        id: standAloneScene
        DirectionalLight { ambientColor: Qt.rgba(1.0, 1.0, 1.0, 1.0) }
        Node {
            id: node
            Model {
                id: model
                source: "#Cube"
                materials: [
                    DefaultMaterial { diffuseColor: Qt.rgba(0.053, 0.130, 0.219, 0.75) }
                ]
            }
        }
        OrthographicCamera {
            id: cameraOrthographicFront
            eulerRotation { x: -45; y: 45 }
            x: 600; y: 800; z: 600
        }
    }
    View3D {
        anchors.fill: parent
        importScene: standAloneScene
        camera: cameraOrthographicFront
    }
    NumberAnimation {
        target: model
        property: "eulerRotation.y"
        loops: Animation.Infinite
        running: true
        from: 720; to: 0
        duration: 10000
    }
}
`;
        }
        codeEdit.text = code;
    }
}
