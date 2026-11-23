//
//  AppDelegate.swift
//  clipboard
//
//  Created by crown on 2025/9/11
//

import AppKit
import Combine
import QuartzCore

class AppDelegate: NSObject {
    private var monitorToken: Any?
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        StatusBarController.shared.setup()

        applyAppearanceSettings()

        applyDockIconPolicy()

        Task {
            await initClipboardAsync()
        }

        Task.detached(priority: .utility) {
            PasteboardWritingItem.clearDragCache()
        }
    }

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        true
    }

    func applicationWillTerminate(_: Notification) {
        if let token = monitorToken {
            NSEvent.removeMonitor(token)
            monitorToken = nil
        }
        StatusBarController.shared.cleanup()
        AppIconCache.shared.clearCache()
        HotKeyManager.shared.clear()
        MCPServer.shared.stop()
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
        WindowManager.shared.toggleWindow(frame: NSScreen.main?.frame)
        return true
    }

    private func applyDockIconPolicy() {
        let showDockIcon = PasteUserDefaults.showDockIcon
        NSApp.setActivationPolicy(showDockIcon ? .regular : .accessory)
    }

    private func applyAppearanceSettings() {
        let appearanceMode =
            AppearanceMode(
                rawValue: PasteUserDefaults.appearance
            ) ?? .system

        switch appearanceMode {
        case .system:
            NSApp.appearance = nil
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        }
    }
}

extension AppDelegate {
    private func initClipboardAsync() async {
        guard await PasteDataStore.main.setup() else { return }

        PasteBoard.main.startListening()

        initLocalEvent()

        HotKeyManager.shared.initialize()

        WelcomeWindowController.shared.showIfNeeded()

        syncLaunchAtLoginStatus()

        MCPServer.shared.sync()
    }

    private func syncLaunchAtLoginStatus() {
        let userDefaultsValue = PasteUserDefaults.onStart
        let actualValue = LaunchAtLoginHelper.shared.isEnabled
        if userDefaultsValue != actualValue {
            LaunchAtLoginHelper.shared.setEnabled(userDefaultsValue)
        }
    }
}

extension AppDelegate {
    private func initLocalEvent() {
        monitorToken = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) {
                let modifiers = event.charactersIgnoringModifiers
                if modifiers == "," || modifiers == "，" {
                    SettingWindowController.shared.toggleWindow(page: .general)
                    return nil
                }
                if modifiers == "q" || modifiers == "Q" {
                    NSApplication.shared.terminate(nil)
                    return nil
                }
                if modifiers == "t" || modifiers == "T",
                    event.modifierFlags.intersection([.command, .option, .control, .shift]) == .command
                {
                    if PasteBoard.main.isPaused {
                        PasteBoard.main.resume()
                    } else {
                        PasteBoard.main.pause()
                    }
                    return nil
                }
                if modifiers == "n" || modifiers == "N",
                    event.modifierFlags.intersection([.command, .option, .control, .shift]) == .command
                {
                    EditWindowController.shared.openNewWindow()
                    return nil
                }
            }
            return event
        }
    }
}

// MARK: - Notification.Name

extension Notification.Name {
    static let menuBarIconVisibilityChanged = Notification.Name(
        "menuBarIconVisibilityChanged"
    )
}
