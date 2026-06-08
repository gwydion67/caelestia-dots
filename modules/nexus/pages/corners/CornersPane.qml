pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property list<MenuItem> actionItems: [
        MenuItem { text: qsTr("Launcher") },
        MenuItem { text: qsTr("Dashboard") },
        MenuItem { text: qsTr("Session") },
        MenuItem { text: qsTr("Sidebar") },
        MenuItem { text: qsTr("Utilities") },
        MenuItem { text: qsTr("OSD") },
        MenuItem { text: qsTr("Nexus") },
        MenuItem { text: qsTr("Custom...") },
    ]

    readonly property var actionMap: ({
        "launcher": root.actionItems[0],
        "dashboard": root.actionItems[1],
        "session": root.actionItems[2],
        "sidebar": root.actionItems[3],
        "utilities": root.actionItems[4],
        "osd": root.actionItems[5],
        "nexus": root.actionItems[6],
        "custom": root.actionItems[7],
    })

    readonly property var actionKeys: ["launcher", "dashboard", "session", "sidebar", "utilities", "osd", "nexus", "custom"]

    function keyForItem(item: MenuItem): string {
        const text = item.text;
        for (let i = 0; i < root.actionItems.length; i++) {
            if (root.actionItems[i].text === text)
                return root.actionKeys[i];
        }
        return "launcher";
    }

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
            checked: GlobalConfig.services.showGlow
            onToggled: GlobalConfig.services.showGlow = checked
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Glow intensity")
            value: GlobalConfig.services.glowIntensity
            from: 0.1
            to: 1.0
            stepSize: 0.1
            onMoved: v => GlobalConfig.services.glowIntensity = v
        }

        SectionHeader {
            text: qsTr("Top-Left Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: GlobalConfig.services.enabledTopLeft
            onToggled: GlobalConfig.services.enabledTopLeft = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            menuItems: root.actionItems
            active: root.actionMap[GlobalConfig.services.actionTopLeft] ?? root.actionItems[0]
            onSelected: item => GlobalConfig.services.actionTopLeft = root.keyForItem(item)
        }

        ConnectedRect {
            Layout.fillWidth: true
            visible: GlobalConfig.services.actionTopLeft === "custom"
            clip: false
            implicitHeight: cmdLayoutTopLeft.implicitHeight + Tokens.padding.medium * 2

            RowLayout {
                id: cmdLayoutTopLeft
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                anchors.leftMargin: Tokens.padding.largeIncreased
                anchors.rightMargin: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.medium

                StyledTextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Command to execute")
                    text: GlobalConfig.services.customCmdTopLeft
                    onTextChanged: GlobalConfig.services.customCmdTopLeft = text
                }
            }
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: GlobalConfig.services.delayTopLeft
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => GlobalConfig.services.delayTopLeft = v
        }

        SectionHeader {
            text: qsTr("Top-Right Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: GlobalConfig.services.enabledTopRight
            onToggled: GlobalConfig.services.enabledTopRight = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            menuItems: root.actionItems
            active: root.actionMap[GlobalConfig.services.actionTopRight] ?? root.actionItems[0]
            onSelected: item => GlobalConfig.services.actionTopRight = root.keyForItem(item)
        }

        ConnectedRect {
            Layout.fillWidth: true
            visible: GlobalConfig.services.actionTopRight === "custom"
            clip: false
            implicitHeight: cmdLayoutTopRight.implicitHeight + Tokens.padding.medium * 2

            RowLayout {
                id: cmdLayoutTopRight
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                anchors.leftMargin: Tokens.padding.largeIncreased
                anchors.rightMargin: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.medium

                StyledTextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Command to execute")
                    text: GlobalConfig.services.customCmdTopRight
                    onTextChanged: GlobalConfig.services.customCmdTopRight = text
                }
            }
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: GlobalConfig.services.delayTopRight
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => GlobalConfig.services.delayTopRight = v
        }

        SectionHeader {
            text: qsTr("Bottom-Left Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: GlobalConfig.services.enabledBottomLeft
            onToggled: GlobalConfig.services.enabledBottomLeft = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            menuItems: root.actionItems
            active: root.actionMap[GlobalConfig.services.actionBottomLeft] ?? root.actionItems[0]
            onSelected: item => GlobalConfig.services.actionBottomLeft = root.keyForItem(item)
        }

        ConnectedRect {
            Layout.fillWidth: true
            visible: GlobalConfig.services.actionBottomLeft === "custom"
            clip: false
            implicitHeight: cmdLayoutBottomLeft.implicitHeight + Tokens.padding.medium * 2

            RowLayout {
                id: cmdLayoutBottomLeft
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                anchors.leftMargin: Tokens.padding.largeIncreased
                anchors.rightMargin: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.medium

                StyledTextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Command to execute")
                    text: GlobalConfig.services.customCmdBottomLeft
                    onTextChanged: GlobalConfig.services.customCmdBottomLeft = text
                }
            }
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: GlobalConfig.services.delayBottomLeft
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => GlobalConfig.services.delayBottomLeft = v
        }

        SectionHeader {
            text: qsTr("Bottom-Right Corner")
        }

        ToggleRow {
            Layout.fillWidth: true
            first: true
            text: qsTr("Enabled")
            checked: GlobalConfig.services.enabledBottomRight
            onToggled: GlobalConfig.services.enabledBottomRight = checked
        }

        SelectRow {
            Layout.fillWidth: true
            label: qsTr("Action")
            menuItems: root.actionItems
            active: root.actionMap[GlobalConfig.services.actionBottomRight] ?? root.actionItems[0]
            onSelected: item => GlobalConfig.services.actionBottomRight = root.keyForItem(item)
        }

        ConnectedRect {
            Layout.fillWidth: true
            visible: GlobalConfig.services.actionBottomRight === "custom"
            clip: false
            implicitHeight: cmdLayoutBottomRight.implicitHeight + Tokens.padding.medium * 2

            RowLayout {
                id: cmdLayoutBottomRight
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                anchors.leftMargin: Tokens.padding.largeIncreased
                anchors.rightMargin: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.medium

                StyledTextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Command to execute")
                    text: GlobalConfig.services.customCmdBottomRight
                    onTextChanged: GlobalConfig.services.customCmdBottomRight = text
                }
            }
        }

        StepperRow {
            Layout.fillWidth: true
            last: true
            label: qsTr("Activation delay (ms)")
            value: GlobalConfig.services.delayBottomRight
            from: 100
            to: 2000
            stepSize: 100
            onMoved: v => GlobalConfig.services.delayBottomRight = v
        }
    }
}
