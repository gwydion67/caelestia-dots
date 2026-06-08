pragma Singleton

import QtQuick

Singleton {
    id: root

    property bool enabledTopLeft: true
    property bool enabledTopRight: true
    property bool enabledBottomLeft: true
    property bool enabledBottomRight: true

    property string actionTopLeft: "launcher"
    property string actionTopRight: "dashboard"
    property string actionBottomLeft: "session"
    property string actionBottomRight: "sidebar"

    property int delayTopLeft: 300
    property int delayTopRight: 300
    property int delayBottomLeft: 300
    property int delayBottomRight: 300

    property int glowRadius: 80
    property real glowIntensity: 0.6
    property bool showGlow: true
    property int triggerSize: 10

    property bool enabled: enabledTopLeft || enabledTopRight || enabledBottomLeft || enabledBottomRight
}
