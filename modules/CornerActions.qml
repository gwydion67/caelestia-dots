pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Caelestia.Config
import qs.components
import qs.components.containers
import qs.services
import qs.modules.nexus

Scope {
    id: root

    property int cursorX: 0
    property int cursorY: 0

    Timer {
        interval: 30
        repeat: true
        running: GlobalConfig.services.enabledTopLeft || GlobalConfig.services.enabledTopRight || GlobalConfig.services.enabledBottomLeft || GlobalConfig.services.enabledBottomRight
        onTriggered: cursorProcess.running = true
    }

    Process {
        id: cursorProcess
        command: ["hyprctl", "cursorpos", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text)
                    return;
                const pos = JSON.parse(text);
                root.cursorX = pos.x;
                root.cursorY = pos.y;
            }
        }
    }

    Variants {
        model: Screens.screens

        StyledWindow {
            id: win

            required property ShellScreen modelData

            screen: modelData
            name: "corners"
            mask: Region {}
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            visible: (GlobalConfig.services.enabledTopLeft || GlobalConfig.services.enabledTopRight || GlobalConfig.services.enabledBottomLeft || GlobalConfig.services.enabledBottomRight) && GlobalConfig.services.showGlow

            Item {
                anchors.fill: parent

                CornerGlow {
                    x: -glowRadius
                    y: -glowRadius
                    width: glowRadius * 2
                    height: glowRadius * 2
                    anchor: Qt.TopLeftCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: Config.services.enabledTopLeft
                    action: Config.services.actionTopLeft
                    customCmd: Config.services.customCmdTopLeft
                    delay: Config.services.delayTopLeft
                    triggerSize: Config.services.triggerSize
                }

                CornerGlow {
                    x: parent.width - glowRadius
                    y: -glowRadius
                    width: glowRadius * 2
                    height: glowRadius * 2
                    anchor: Qt.TopRightCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: Config.services.enabledTopRight
                    action: Config.services.actionTopRight
                    customCmd: Config.services.customCmdTopRight
                    delay: Config.services.delayTopRight
                    triggerSize: Config.services.triggerSize
                }

                CornerGlow {
                    x: -glowRadius
                    y: parent.height - glowRadius
                    width: glowRadius * 2
                    height: glowRadius * 2
                    anchor: Qt.BottomLeftCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: Config.services.enabledBottomLeft
                    action: Config.services.actionBottomLeft
                    customCmd: Config.services.customCmdBottomLeft
                    delay: Config.services.delayBottomLeft
                    triggerSize: Config.services.triggerSize
                }

                CornerGlow {
                    x: parent.width - glowRadius
                    y: parent.height - glowRadius
                    width: glowRadius * 2
                    height: glowRadius * 2
                    anchor: Qt.BottomRightCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: Config.services.enabledBottomRight
                    action: Config.services.actionBottomRight
                    customCmd: Config.services.customCmdBottomRight
                    delay: Config.services.delayBottomRight
                    triggerSize: Config.services.triggerSize
                }
            }

            Behavior on visible {
                Anim {
                    type: Anim.DefaultEffects
                }
            }
        }
    }

    component CornerGlow: Shape {
        id: glow

        property int anchor
        property int cursorX
        property int cursorY
        property int screenX
        property int screenY
        property int screenW
        property int screenH
        property bool enabled
        property string action
        property string customCmd
        property int delay
        property int triggerSize
        property int glowRadius: Config.services.glowRadius

        preferredRendererType: Shape.CurveRenderer

        readonly property real cornerCenterX: {
            if (anchor === Qt.TopLeftCorner || anchor === Qt.BottomLeftCorner)
                return screenX;
            return screenX + screenW;
        }
        readonly property real cornerCenterY: {
            if (anchor === Qt.TopLeftCorner || anchor === Qt.TopRightCorner)
                return screenY;
            return screenY + screenH;
        }
        readonly property real distance: Math.sqrt(
            Math.pow(cursorX - cornerCenterX, 2) + Math.pow(cursorY - cornerCenterY, 2)
        )
        readonly property real proximity: enabled ? Math.max(0, 1 - distance / glowRadius) : 0
        readonly property bool inTriggerZone: enabled && distance <= triggerSize

        property bool triggered
        property bool wasInZone

        opacity: glow.proximity * Config.services.glowIntensity

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: Colours.palette.m3primary
            fillGradient: RadialGradient {
                centerX: glow.width / 2
                centerY: glow.height / 2
                centerRadius: glow.glowRadius
                focalX: centerX
                focalY: centerY

                GradientStop { position: 0; color: Qt.alpha(Colours.palette.m3primary, 1) }
                GradientStop { position: 0.7; color: Qt.alpha(Colours.palette.m3primary, 0.6) }
                GradientStop { position: 1; color: Qt.alpha(Colours.palette.m3primary, 0) }
            }

            startX: glow.glowRadius
            startY: 0
            PathArc {
                x: glow.glowRadius
                y: glow.height
                radiusX: glow.glowRadius
                radiusY: glow.glowRadius
            }
            PathArc {
                x: glow.glowRadius
                y: 0
                radiusX: glow.glowRadius
                radiusY: glow.glowRadius
            }
        }

        function doAction(): void {
            if (action === "custom" && customCmd) {
                Quickshell.execDetached(customCmd.trim().split(" "));
                return;
            }

            const vis = Visibilities.getForActive();
            switch (action) {
                case "launcher":
                    vis.launcher = !vis.launcher;
                    break;
                case "dashboard":
                    vis.dashboard = !vis.dashboard;
                    break;
                case "session":
                    vis.session = !vis.session;
                    break;
                case "sidebar":
                    vis.sidebar = !vis.sidebar;
                    break;
                case "utilities":
                    vis.utilities = !vis.utilities;
                    break;
                case "osd":
                    vis.osd = !vis.osd;
                    break;
                case "nexus":
                    WindowFactory.create();
                    break;
                default:
                    break;
            }
        }

        onInTriggerZoneChanged: {
            if (inTriggerZone && !wasInZone) {
                triggerTimer.start();
            } else if (!inTriggerZone) {
                triggerTimer.stop();
            }
            wasInZone = inTriggerZone;
        }

        Timer {
            id: triggerTimer

            interval: glow.delay
            repeat: false
            onTriggered: {
                if (glow.enabled && glow.inTriggerZone) {
                    glow.triggered = true;
                    glow.doAction();
                }
            }
        }
    }
}
