pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Caelestia.Config

Singleton {
    id: root

    readonly property bool enabled: Config.bar.workspaces.purgeEmpty

    property var occupied: ({})
    property int occupiedCount: 0
    property int maxOccupied: 0

    function refresh(): void {
        const occ = {};
        let count = 0;
        let maxId = 0;
        for (const ws of Hypr.workspaces.values) {
            const hasWindows = ws.lastIpcObject.windows > 0 && !ws.name.startsWith("special:");
            occ[ws.id] = hasWindows;
            if (hasWindows) {
                count++;
                if (ws.id > maxId)
                    maxId = ws.id;
            }
        }
        root.occupied = occ;
        root.occupiedCount = count;
        root.maxOccupied = maxId;
    }

    onEnabledChanged: if (enabled) compact()

    function compact(): void {
        if (!enabled) return;
        debounceTimer.restart();
    }

    Timer {
        id: debounceTimer
        interval: 100
        repeat: false
        onTriggered: performCompaction()
    }

    function performCompaction(): void {
        const toplevels = Hypr.toplevels.values.filter(t => t.workspace && t.workspace.id > 0);
        const occupiedIds = new Set(toplevels.map(t => t.workspace.id));
        const sortedOccupied = Array.from(occupiedIds).sort((a, b) => a - b);

        let targetId = 1;
        const activeWsId = Hypr.activeWsId;
        let activeWsMovedTo = -1;

        for (const currentId of sortedOccupied) {
            if (currentId > targetId) {
                const windowsToMove = toplevels.filter(t => t.workspace.id === currentId);
                for (const w of windowsToMove) {
                    Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${targetId}, window = "address:0x${w.address}", follow = false })`);
                }
                if (activeWsId === currentId)
                    activeWsMovedTo = targetId;
            }
            targetId++;
        }

        if (activeWsMovedTo !== -1)
            Hypr.dsp.focus({ workspace: activeWsMovedTo });

        root.refresh();
    }

    function cycleWorkspace(direction: string): void {
        const currentId = Hypr.activeWsId;
        const limit = Math.max(root.maxOccupied + 1, 1);

        let nextId;
        if (direction === "next") {
            nextId = (currentId % limit) + 1;
        } else {
            nextId = currentId <= 1 ? limit : currentId - 1;
        }

        Hypr.dsp.focus({ workspace: nextId });
    }

    Component.onCompleted: root.refresh()

    Connections {
        target: Hyprland

        function onRawEvent(event): void {
            const name = event?.name ?? "";
            if (name === "workspace" || name === "workspacev2"
                || name === "openwindow" || name === "closewindow"
                || name === "movewindow" || name === "movewindowv2"
                || name === "focusedmon" || name === "focusedmonv2"
                || name === "destroyworkspace" || name === "createworkspace") {
                root.refresh();
                if (root.enabled
                    && (name === "closewindow" || name === "openwindow"
                        || name === "movewindow" || name === "movewindowv2")) {
                    root.compact();
                }
            }
        }
    }

    IpcHandler {
        function cycle(direction: string): void {
            root.cycleWorkspace(direction);
        }

        function compact(): void {
            root.compact();
        }

        target: "workspaces"
    }
}
