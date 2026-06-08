#pragma once

#include "configobject.hpp"

#include <qstring.h>
#include <qvariant.h>

namespace caelestia::config {

using Qt::StringLiterals::operator""_s;

class ServiceConfig : public ConfigObject {
    Q_OBJECT
    QML_ANONYMOUS

    CONFIG_GLOBAL_PROPERTY(QString, weatherLocation)
    // Guess based on locale
    CONFIG_GLOBAL_PROPERTY(bool, useFahrenheit,
        QLocale().measurementSystem() == QLocale::ImperialUSSystem ||
            QLocale().measurementSystem() == QLocale::ImperialUKSystem)
    // This is always false by default cause apparently even imperial system users don't use it for perf temps?
    CONFIG_GLOBAL_PROPERTY(bool, useFahrenheitPerformance, false)
    // Attempt to guess based on locale
    CONFIG_GLOBAL_PROPERTY(
        bool, useTwelveHourClock, QLocale().timeFormat(QLocale::ShortFormat).toLower().contains(u"a"_s))
    CONFIG_GLOBAL_PROPERTY(QString, gpuType)
    CONFIG_GLOBAL_PROPERTY(int, visualiserBars, 60)
    CONFIG_GLOBAL_PROPERTY(qreal, audioIncrement, 0.1)
    CONFIG_GLOBAL_PROPERTY(qreal, brightnessIncrement, 0.1)
    CONFIG_GLOBAL_PROPERTY(qreal, maxVolume, 1.0)
    CONFIG_GLOBAL_PROPERTY(bool, smartScheme, true)
    CONFIG_GLOBAL_PROPERTY(QString, defaultPlayer, u"Spotify"_s)
    CONFIG_GLOBAL_PROPERTY(QVariantList, playerAliases,
        { vmap({ { u"from"_s, u"com.github.th_ch.youtube_music"_s }, { u"to"_s, u"YT Music"_s } }) })
    CONFIG_GLOBAL_PROPERTY(QString, lyricsBackend, u"Auto"_s)

    // Hot corners
    CONFIG_PROPERTY(bool, enabledTopLeft, true)
    CONFIG_PROPERTY(bool, enabledTopRight, true)
    CONFIG_PROPERTY(bool, enabledBottomLeft, true)
    CONFIG_PROPERTY(bool, enabledBottomRight, true)
    CONFIG_PROPERTY(QString, actionTopLeft, u"launcher"_s)
    CONFIG_PROPERTY(QString, actionTopRight, u"dashboard"_s)
    CONFIG_PROPERTY(QString, actionBottomLeft, u"session"_s)
    CONFIG_PROPERTY(QString, actionBottomRight, u"sidebar"_s)
    CONFIG_PROPERTY(QString, customCmdTopLeft, u""_s)
    CONFIG_PROPERTY(QString, customCmdTopRight, u""_s)
    CONFIG_PROPERTY(QString, customCmdBottomLeft, u""_s)
    CONFIG_PROPERTY(QString, customCmdBottomRight, u""_s)
    CONFIG_PROPERTY(int, delayTopLeft, 300)
    CONFIG_PROPERTY(int, delayTopRight, 300)
    CONFIG_PROPERTY(int, delayBottomLeft, 300)
    CONFIG_PROPERTY(int, delayBottomRight, 300)
    CONFIG_PROPERTY(int, glowRadius, 80)
    CONFIG_PROPERTY(qreal, glowIntensity, 0.6)
    CONFIG_PROPERTY(bool, showGlow, true)
    CONFIG_PROPERTY(int, triggerSize, 10)

public:
    explicit ServiceConfig(QObject* parent = nullptr)
        : ConfigObject(parent) {}
};

} // namespace caelestia::config
