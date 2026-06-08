pragma ComponentBehavior: Bound

import QtQuick
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

    Process {
        running: CornerSettings.enabled
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
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            visible: CornerSettings.enabled && CornerSettings.showGlow

            Item {
                anchors.fill: parent

                CornerGlow {
                    x: 0
                    y: 0
                    anchor: Qt.TopLeftCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: CornerSettings.enabledTopLeft
                    action: CornerSettings.actionTopLeft
                    delay: CornerSettings.delayTopLeft
                    triggerSize: CornerSettings.triggerSize
                }

                CornerGlow {
                    x: parent.width - CornerSettings.glowRadius
                    y: 0
                    anchor: Qt.TopRightCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: CornerSettings.enabledTopRight
                    action: CornerSettings.actionTopRight
                    delay: CornerSettings.delayTopRight
                    triggerSize: CornerSettings.triggerSize
                }

                CornerGlow {
                    x: 0
                    y: parent.height - CornerSettings.glowRadius
                    anchor: Qt.BottomLeftCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: CornerSettings.enabledBottomLeft
                    action: CornerSettings.actionBottomLeft
                    delay: CornerSettings.delayBottomLeft
                    triggerSize: CornerSettings.triggerSize
                }

                CornerGlow {
                    x: parent.width - CornerSettings.glowRadius
                    y: parent.height - CornerSettings.glowRadius
                    anchor: Qt.BottomRightCorner
                    cursorX: root.cursorX
                    cursorY: root.cursorY
                    screenX: win.modelData.x
                    screenY: win.modelData.y
                    screenW: win.modelData.width
                    screenH: win.modelData.height
                    enabled: CornerSettings.enabledBottomRight
                    action: CornerSettings.actionBottomRight
                    delay: CornerSettings.delayBottomRight
                    triggerSize: CornerSettings.triggerSize
                }
            }

            Behavior on visible {
                Anim {
                    type: Anim.DefaultEffects
                }
            }
        }
    }

    component CornerGlow: Item {
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
        property int delay
        property int triggerSize
        property int glowRadius: CornerSettings.glowRadius

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

        function doAction(): void {
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

        implicitWidth: glowRadius * 2
        implicitHeight: glowRadius * 2

        Rectangle {
            anchors.centerIn: parent
            width: glowRadius * 2
            height: glowRadius * 2
            radius: glowRadius

            scale: glow.proximity
            opacity: glow.proximity * CornerSettings.glowIntensity

            color: Colours.palette.m3primary
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0) }
                GradientStop { position: 0.5; color: Colours.palette.m3primaryContainer }
                GradientStop { position: 1; color: Colours.palette.m3primary }
            }

            Behavior on scale {
                Anim {
                    type: Anim.StandardSmall
                }
            }

            Behavior on opacity {
                Anim {
                    type: Anim.DefaultEffects
                }
            }
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
