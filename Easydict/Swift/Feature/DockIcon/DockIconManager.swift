//
//  DockIconManager.swift
//  Easydict
//
//  Created by tisfeng on 2026/3/26.
//  Copyright © 2026 izual. All rights reserved.
//

import AppKit
import Defaults
import Foundation

/// Manages Dock icon visibility based on user preference.
///
/// Call `setup()` once on app launch. After that, changes to the `showDockIcon`
/// Defaults key are observed automatically and the activation policy is updated
/// immediately on the main thread.
@objc(EZDockIconManager)
class DockIconManager: NSObject {
    // MARK: Internal

    @objc static let shared = DockIconManager()

    /// Apply the initial activation policy and begin observing future changes.
    @objc func setup() {
        applyPolicy(Defaults[.showDockIcon])
        observer = Defaults.observe(.showDockIcon, options: [.new]) { [weak self] change in
            DispatchQueue.main.async {
                self?.applyPolicy(change.newValue)
            }
        }
    }

    // MARK: Private

    private var observer: DefaultsObservation?

    private func applyPolicy(_ showDock: Bool) {
        NSApp.setActivationPolicy(showDock ? .regular : .accessory)
    }
}
