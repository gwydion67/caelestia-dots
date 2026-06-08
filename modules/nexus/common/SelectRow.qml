pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services
import qs.modules.nexus.common

ConnectedRect {
    id: root

    property alias label: label.text
    property string subtext
    property var model: []
    property int currentIndex: 0

    signal activated(index: int)

    implicitHeight: rowLayout.implicitHeight + rowLayout.anchors.margins * 2

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        anchors.leftMargin: Tokens.padding.largeIncreased
        anchors.rightMargin: Tokens.padding.largeIncreased
        spacing: Tokens.spacing.medium

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                id: label

                Layout.fillWidth: true
                font: Tokens.font.body.small
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.subtext
                text: root.subtext
                color: Colours.palette.m3outline
                font: Tokens.font.label.small
                elide: Text.ElideRight
            }
        }

        StyledRect {
            implicitWidth: valueLabel.implicitWidth + Tokens.padding.large
            implicitHeight: valueLabel.implicitHeight + Tokens.padding.small

            radius: Tokens.rounding.full
            color: Colours.tPalette.m3surfaceContainerHighest

            StyledText {
                id: valueLabel

                anchors.centerIn: parent
                text: root.currentIndex >= 0 && root.currentIndex < root.model.length ? root.model[root.currentIndex] : ""
                color: Colours.palette.m3primary
                font: Tokens.font.body.small
            }

            StateLayer {
                color: Colours.palette.m3onSurface
                onClicked: {
                    const next = (root.currentIndex + 1) % root.model.length;
                    root.activated(next);
                }
            }
        }
    }
}
