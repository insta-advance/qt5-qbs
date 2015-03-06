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
    parser.setApplicationDescription(QLatin1String(
        "qhost is a utility for managing Qt installations built using QBS.\r\n"
        "It replaces specific functions of qmake to provide compatibility with "
        "tools such as qbs-setup-qt."));
    parser.setSingleDashWordOptionMode(QCommandLineParser::ParseAsLongOptions);
    parser.addOption({
        QStringLiteral("query"),
        QStringLiteral("Query persistent property. Show all if <prop> is empty."),
        QStringLiteral("prop"),
    });
    parser.addOption({
        QStringLiteral("config-file"),
        QStringLiteral("Specify the path to the JSON persistent properties file."),
        QStringLiteral("file"),
    });

    parser.addHelpOption();
    parser.parse(app.arguments());

    QString configFile;
    if (parser.isSet(QStringLiteral("config-file"))) {
        configFile = parser.value(QStringLiteral("config-file"));
        if (!QFile::exists(configFile)) {
            qCritical() << "Configuration file" << configFile << "does not exist.";
            return 1;
        }
    }

    // qmake emulation
    if (parser.isSet(QStringLiteral("query"))) {
        const QString qtLocation = configFile.isEmpty()
                ? QDir(app.applicationDirPath() + QLatin1String("/..")).absolutePath()
                : QFileInfo(configFile).dir().absolutePath();

        QJsonObject json;
        // The active Qt should have a qhost.json set, or the "theoretical" install should be created
        // ### should the JSON document be created anyway, so it can be written if needed?
        const QString sep = QDir::separator();
        if (configFile.isEmpty())
            configFile = qtLocation + sep + QLatin1String("qhost.json");
        if (QFile::exists(configFile)) {
            QFile file(configFile);
            if (!file.open(QIODevice::ReadOnly)) {
                qCritical() << "Could not open" << file.fileName() << "for reading";
                return 1;
            }

            QJsonParseError error;
            json = QJsonDocument::fromJson(file.readAll(), &error).object();
            if (error.error) {
                qCritical() << "Failed to parse" << file.fileName()
                            << ":" << error.errorString();
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
        }

        const QDir qtLocationDir(qtLocation);
        const QString prop = parser.value(QStringLiteral("query"));
        if (prop.isEmpty()) {
            for (QJsonObject::const_iterator it = json.begin(); it != json.end(); ++it) {
                QString value = it.value().toString();
                // Resolve to absolute paths
                if (it.key().startsWith(QLatin1String("QT_HOST_"))
                        || it.key().startsWith(QLatin1String("QT_INSTALL_"))) {
                    QDir dir(it.value().toString());
                    value = dir.isRelative() ? QDir::cleanPath(qtLocationDir.absoluteFilePath(dir.path()))
                                             : dir.absolutePath();
                }
                std::cout << qPrintable(it.key()) << ':'
                          << qPrintable(value) << std::endl;
            }
        } else {
            std::cout << qPrintable(json.value(prop).toString()) << std::endl;
        }

        return 0;
    }

    parser.process(app);
    parser.showHelp();
}
