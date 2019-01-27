//
//  MainPrefsViewController.swift
//  MonitorControl
//
//  Created by Guillaume BRODER on 07/01/2018.
//  MIT Licensed.
//

import Cocoa
import MASPreferences
import ServiceManagement

class MainPrefsViewController: NSViewController, MASPreferencesViewController {

	var viewIdentifier: String = "Main"
	var toolbarItemLabel: String? = NSLocalizedString("General", comment: "Shown in the main prefs window")
	var toolbarItemImage: NSImage? = NSImage.init(named: NSImage.preferencesGeneralName)
	let prefs = UserDefaults.standard

    @IBOutlet var versionLabel: NSTextField!
    @IBOutlet var startAtLogin: NSButton!
	@IBOutlet var showContrastSlider: NSButton!
	@IBOutlet var lowerContrast: NSButton!
    @IBOutlet var intelliDock: NSButton!

	override func viewDidLoad() {
        super.viewDidLoad()

		startAtLogin.state = prefs.bool(forKey: Utils.PrefKeys.startAtLogin.rawValue) ? .on : .off
		showContrastSlider.state = prefs.bool(forKey: Utils.PrefKeys.showContrast.rawValue) ? .on : .off
		lowerContrast.state = prefs.bool(forKey: Utils.PrefKeys.lowerContrast.rawValue) ? .on : .off
        intelliDock.state = prefs.bool(forKey: Utils.PrefKeys.intelliDock.rawValue) ? .on : .off
        setVersionNumber()
    }

	@IBAction func startAtLoginClicked(_ sender: NSButton) {
		let identifier = "me.jonivr.MonitorControlHelper" as CFString
		switch sender.state {
		case .on:
			prefs.set(true, forKey: Utils.PrefKeys.startAtLogin.rawValue)
			SMLoginItemSetEnabled(identifier, true)
		case .off:
			prefs.set(false, forKey: Utils.PrefKeys.startAtLogin.rawValue)
			SMLoginItemSetEnabled(identifier, false)
		default: break
		}

		#if DEBUG
		print("Toggle start at login state -> \(sender.state == .on ? "on" : "off")")
		#endif
	}

	@IBAction func showContrastSliderClicked(_ sender: NSButton) {
		switch sender.state {
		case .on:
			prefs.set(true, forKey: Utils.PrefKeys.showContrast.rawValue)
		case .off:
			prefs.set(false, forKey: Utils.PrefKeys.showContrast.rawValue)
		default: break
		}

		#if DEBUG
		print("Toggle show contrast slider state -> \(sender.state == .on ? "on" : "off")")
		#endif

		NotificationCenter.default.post(name: Notification.Name.init(Utils.PrefKeys.showContrast.rawValue), object: nil)
	}

	@IBAction func lowerContrastClicked(_ sender: NSButton) {
		switch sender.state {
		case .on:
			prefs.set(true, forKey: Utils.PrefKeys.lowerContrast.rawValue)
		case .off:
			prefs.set(false, forKey: Utils.PrefKeys.lowerContrast.rawValue)
		default: break
		}

		#if DEBUG
		print("Toggle lower contrast after brightness state -> \(sender.state == .on ? "on" : "off")")
		#endif
	}

    @IBAction func intelliDockClicked(_ sender: NSButton) {
        switch sender.state {
        case .on:
            prefs.set(true, forKey: Utils.PrefKeys.intelliDock.rawValue)
        case .off:
            prefs.set(false, forKey: Utils.PrefKeys.intelliDock.rawValue)
        default: break
        }
        Utils.updateDockAutohide()
        #if DEBUG
        print("Toggle Intellidock state -> \(sender.state == .on ? "on" : "off")")
        #endif
    }

    fileprivate func setVersionNumber() {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "unknown"
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown"
        versionLabel.stringValue = "version \(versionNumber) build \(buildNumber)"
    }
}
