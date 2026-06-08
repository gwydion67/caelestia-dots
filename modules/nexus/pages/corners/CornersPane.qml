pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: qsTr("Hot Corners")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: qsTr("Appearance")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Show glow effect")
            subtext: qsTr("Display a proximity-based glow when cursor nears a corner")
            checked: CornerSettings.showGlow
            onToggled: CornerSettings.showGlow = checked
        }

        SliderRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Glow intensity")
            value: CornerSettings.glowIntensity
            from: 0.1
            to: 1.0
            stepSize: 0.1
            onMoved: v => CornerSettings.glowIntensity = v
        }

        SectionHeader {
            text: qsTr("Top-Left Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: CornerSettings.enabledTopLeft
            onToggled: CornerSettings.enabledTopLeft = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            model: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"]
            currentIndex: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"].indexOf(CornerSettings.actionTopLeft)
            onActivated: idx => CornerSettings.actionTopLeft = model[idx]
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: CornerSettings.delayTopLeft
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => CornerSettings.delayTopLeft = v
        }

        SectionHeader {
            text: qsTr("Top-Right Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: CornerSettings.enabledTopRight
            onToggled: CornerSettings.enabledTopRight = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            model: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"]
            currentIndex: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"].indexOf(CornerSettings.actionTopRight)
            onActivated: idx => CornerSettings.actionTopRight = model[idx]
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: CornerSettings.delayTopRight
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => CornerSettings.delayTopRight = v
        }

        SectionHeader {
            text: qsTr("Bottom-Left Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: CornerSettings.enabledBottomLeft
            onToggled: CornerSettings.enabledBottomLeft = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            model: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"]
            currentIndex: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"].indexOf(CornerSettings.actionBottomLeft)
            onActivated: idx => CornerSettings.actionBottomLeft = model[idx]
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: CornerSettings.delayBottomLeft
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => CornerSettings.delayBottomLeft = v
        }

        SectionHeader {
            text: qsTr("Bottom-Right Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: CornerSettings.enabledBottomRight
            onToggled: CornerSettings.enabledBottomRight = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            model: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"]
            currentIndex: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus"].indexOf(CornerSettings.actionBottomRight)
            onActivated: idx => CornerSettings.actionBottomRight = model[idx]
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: CornerSettings.delayBottomRight
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => CornerSettings.delayBottomRight = v
        }
    }
}
