#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QJSEngine>
#include <QtGlobal>
#include <QQmlContext>
#include <QDebug>
#include "../qt-toolkit/App.h"
#include "../qt-toolkit/Engine.h"
#include "../qt-toolkit/FileSystem.h"
#include "../qt-toolkit/Folder.h"
#include "../qt-toolkit/ImageBuffer.h"
#include "../qt-toolkit/SyntaxHighlighter.h"
#include "../qt-toolkit/System.h"
#include "../qt-toolkit/UrlInfo.h"

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

int main(int argc, char *argv[])
{
    QString newSelectors = QString("qt") + QString::number(QT_VERSION_MAJOR)
                        + QString(",qt") + QString::number(QT_VERSION_MAJOR)
                          + QString(".") + QString::number(QT_VERSION_MINOR)
                        + QString(",qt") + QString::number(QT_VERSION_MAJOR)
                          + QString(".") + QString::number(QT_VERSION_MINOR)
                          + QString(".") + QString::number(QT_VERSION_PATCH);

    qputenv("QT_FILE_SELECTORS",newSelectors.toUtf8());

    qmlRegisterSingletonType<App>("qmlonline", 1, 0, "App", [](QQmlEngine*,QJSEngine*) -> QObject* { return new App(); } );
    qmlRegisterSingletonType<Engine>("qmlonline", 1, 0, "Engine", [](QQmlEngine*,QJSEngine*) -> QObject* { return new Engine(); } );
    qmlRegisterSingletonType<FileSystem>("qmlonline", 1, 0, "FileSystem", [](QQmlEngine*,QJSEngine*) -> QObject* { return new FileSystem(); } );
    qmlRegisterSingletonType<System>("qmlonline", 1, 0, "System", [](QQmlEngine*,QJSEngine*) -> QObject* { return new System(); } );

    qmlRegisterType<ImageBuffer>("qmlonline", 1, 0, "ImageBuffer");
    qmlRegisterType<Folder>("qmlonline", 1, 0, "Folder");
    qmlRegisterType<SyntaxHighlighter>("qmlonline", 1, 0, "SyntaxHighlighter");
    qmlRegisterType<UrlInfo>("qmlonline", 1, 0, "UrlInfo");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext* rootContext = engine.rootContext();
    rootContext->setContextProperty("BUILD_DATE", __DATE__);
    rootContext->setContextProperty("BUILD_TIME", __TIME__);
#ifdef GIT_COMMIT
    rootContext->setContextProperty("GIT_COMMIT", STR(GIT_COMMIT));
#else
    rootContext->setContextProperty("GIT_COMMIT", "");
#endif

    const QUrl url(QStringLiteral("qrc:/qml/MyApp.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    int ret = app.exec();
    qDebug() << Q_FUNC_INFO << "line: " << __LINE__ << "ret:" << ret;
    return ret;
}
