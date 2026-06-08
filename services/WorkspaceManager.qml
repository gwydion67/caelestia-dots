pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Caelestia.Config

Singleton {
    id: root

    readonly property var occupied: {
        const occ = {};
        for (const ws of Hypr.workspaces.values)
            occ[ws.id] = ws.lastIpcObject.windows > 0;
        return occ;
    }

    readonly property int occupiedCount: {
        let count = 0;
        for (const ws of Hypr.workspaces.values) {
            if (ws.lastIpcObject.windows > 0)
                count++;
        }
        return count;
    }

    readonly property int maxOccupied: {
        let maxId = 0;
        for (const ws of Hypr.workspaces.values) {
            if (ws.lastIpcObject.windows > 0 && ws.id > maxId)
                maxId = ws.id;
        }
        return maxId;
    }

    readonly property var workspacesList: Hypr.workspaces.values

    function cycleWorkspace(direction: string): void {
        if (!Config.bar.workspaces.purgeEmpty) {
            Hypr.dsp.focus({ workspace: `"e${direction === "next" ? "+1" : "-1"}"` });
            return;
        }

        const occ = root.occupied;
        const activeId = Hypr.activeWsId;
        const ids = Object.keys(occ)
            .map(Number)
            .filter(id => occ[id])
            .sort((a, b) => a - b);

        if (ids.length === 0) {
            Hypr.dsp.focus({ workspace: 1 });
            return;
        }

        const maxId = ids[ids.length - 1];
        let nextId;

        if (direction === "next") {
            if (activeId < maxId) {
                nextId = activeId + 1;
                while (nextId <= maxId && !occ[nextId])
                    nextId++;
                if (nextId > maxId)
                    nextId = ids[0];
            } else {
                nextId = ids[0];
            }
        } else {
            if (activeId > ids[0]) {
                nextId = activeId - 1;
                while (nextId >= ids[0] && !occ[nextId])
                    nextId--;
                if (nextId < ids[0])
                    nextId = ids[ids.length - 1];
            } else {
                nextId = ids[ids.length - 1];
            }
        }

        Hypr.dsp.focus({ workspace: nextId });
    }

    function autoCompact(): void {
        if (!Config.bar.workspaces.purgeEmpty)
            return;

        const occ = root.occupied;
        const ids = Object.keys(occ)
            .map(Number)
            .filter(id => occ[id])
            .sort((a, b) => a - b);

        if (ids.length === 0)
            return;

        let target = 1;
        for (const id of ids) {
            if (id !== target && id > 0) {
                for (const ws of Hypr.workspaces.values) {
                    if (ws.id === id) {
                        for (const tl of ws.toplevels.values) {
                            Hypr.dsp.window.move({ workspace: target, window: `address:${tl.address}` });
                        }
                    }
                }
            }
            target++;
        }
    }

    Connections {
        function onWorkspacesChanged(): void {
            if (Config.bar.workspaces.purgeEmpty)
                root.autoCompact();
        }

        target: Hyprland
    }
}
