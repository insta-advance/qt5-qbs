#include <qcommandlineparser.h>
#include <qcoreapplication.h>
#include <qdir.h>
#include <qfile.h>
#include <qjsondocument.h>
#include <qjsonobject.h>
#include <qdebug.h>

#include <iostream>

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral(
        "qhost is a utility for managing Qt installations built using QBS.\r\n"
        "It replaces specific functions of qmake and syncqt.pl."));
    parser.setSingleDashWordOptionMode(QCommandLineParser::ParseAsLongOptions);
    parser.addOption({
        QStringLiteral("query"),
        QStringLiteral("Query persistent property. Show all if <prop> is empty."),
        QStringLiteral("prop"),
    });
    parser.addOption({
        QStringLiteral("sync"),
        QStringLiteral("Synchronize headers from a module directory."),
        QStringLiteral("module path")
    });
    parser.addOption({
        QStringLiteral("outdir"),
        QStringLiteral("Specify output directory for sync."),
        QStringLiteral("output path"),
    });
    parser.addHelpOption();
    parser.parse(app.arguments());

    // qmake emulation
    if (parser.isSet(QStringLiteral("query"))) {
        const QString qtLocation = QDir::cleanPath(app.applicationDirPath() + QLatin1String("/.."));

        // ### move to a separate function, loadConfig
        QJsonObject json;
        // The active Qt should have a qconfig.json set, or the "theoretical" install should be created
        const QString sep = QDir::separator();
        const QString configFile = qtLocation + sep + QLatin1String("qhost.json");
        if (QFile::exists(configFile)) {
            QFile file(QStringLiteral("qconfig.json"));
            if (!file.open(QIODevice::ReadOnly)) {
                qCritical() << "Could not open" << file.fileName() << "for reading";
                return 1;
            }

            QJsonParseError error;
            json = QJsonDocument::fromJson(file.readAll(), &error).object();
            if (error.error) {
                qCritical() << "Failed to parse" << file.fileName();
                qCritical() << error.errorString();
                return 1;
            }
        } else { // If no configuration is found, qhost only points to the host tools.
            json.insert(QStringLiteral("QT_HOST_PREFIX"), qtLocation);
            json.insert(QStringLiteral("QT_HOST_DATA"), qtLocation);
            json.insert(QStringLiteral("QT_HOST_BINS"), QString(qtLocation + sep + QLatin1String("bin")));
            json.insert(QStringLiteral("QT_HOST_LIBS"), QString(qtLocation + sep + QLatin1String("lib")));
            // The following are for qtchooser's benefit, but aren't really "installed"
            json.insert(QStringLiteral("QT_INSTALL_BINS"), QString(qtLocation + sep + QLatin1String("bin")));
            json.insert(QStringLiteral("QT_INSTALL_LIBS"), QString(qtLocation + sep + QLatin1String("lib")));
            // QT_HOST_DATA -- mkspecs (to be installed with qbs build)
        }

        const QString prop = parser.value(QStringLiteral("query"));
        if (prop.isEmpty()) {
            for (QJsonObject::const_iterator it = json.begin(); it != json.end(); ++it) {
                std::cout << qPrintable(it.key()) << ':'
                          << qPrintable(it.value().toString()) << std::endl;
            }
        } else {
            std::cout << qPrintable(json.value(prop).toString()) << std::endl;
        }

        return 0;
    }

    parser.process(app);
    parser.showHelp();
}
