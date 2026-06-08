# Caelestia Implementation Plan

Based on `changes.html` - implementing 3 active features.

## Feature 4: Workspace Manager & Auto-Compact
- `services/WorkspaceManager.qml` — New singleton service
- `plugin/src/Caelestia/Config/barconfig.hpp` — Add `purgeEmpty` config prop
- `modules/bar/components/workspaces/Workspaces.qml` — Dynamic count, auto-compact
- `modules/bar/Bar.qml` — Use WorkspaceManager.cycleWorkspace()
- `modules/nexus/pages/panels/taskbar/BarWorkspaces.qml` — Add auto-compact toggle

## Feature 3: Hyprland 0.55 Compatibility
- `services/Hypr.qml` — Add `dsp` structured dispatch API
- Update all call sites to `Hypr.dsp.*` new format

## Feature 2: Corner Action Support
- `services/CornerSettings.qml` — Corner config singleton
- `modules/CornerActions.qml` — Hot corner logic + glow UI
- `modules/nexus/pages/corners/CornersPane.qml` — Config page
- `shell.qml` — Instantiate CornerActions
- `modules/nexus/PageRegistry.qml` + `PageCompRegistry.qml` — Register page
