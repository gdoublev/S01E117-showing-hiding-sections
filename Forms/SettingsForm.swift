//
//  ViewController.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

enum ShowPreview {
    case always
    case never
    case whenUnlocked
    
    static let all: [ShowPreview] = [.always, .whenUnlocked, .never]
    
    var text: String {
        switch self {
        case .always: return "Always"
        case .whenUnlocked: return "When Unlocked"
        case .never: return "Never"
        }
    }
}
struct Hotspot {
    var isEnabled: Bool = true
    var password: String = "hello"
    var networkName: String = "my network"
    var showPreview: ShowPreview = .always
}

struct Settings {
    var hotspot = Hotspot()
    
    var hotspotEnabled: String {
        return hotspot.isEnabled ? "On" : "Off"
    }
	
	var personalizationEnabled: Bool = false
	var firstName: String = "Chris"
	var lastName: String = "Lattner"
	var useRandomGreeting: Bool = true
	var enabledPersonalizationTitle: String? {
		guard personalizationEnabled else { return nil }
		let fullName = "\(firstName) \(lastName)"
		guard useRandomGreeting,
			let greeting = ["Hello", "Bonjour", "Hola", "Ciao", "Guten Tag"].randomElement() else { return "Hello, \(fullName)" }
		return "\(greeting), \(fullName)"
	}
}

extension Hotspot {
    var enabledSectionTitle: String? {
        return isEnabled ? "Personal Hotspot Enabled" : nil
    }
}

let showPreviewForm: Form<Hotspot> =
    sections([
        section(
            ShowPreview.all.map { option in
                optionCell(title: option.text, option: option, keyPath: \.showPreview)
            }
        )
    ])

let settingsForm: Form<Settings> =
    sections([
        section([
            detailTextCell(title: "Personal Hotspot", keyPath: \Settings.hotspotEnabled, form: bind(form: hotspotForm, to: \.hotspot))
        ]),
		section([
			controlCell(title: "Personalize", control: uiSwitch(keyPath: \.personalizationEnabled)),
			nestedTextField(title: "First Name", keyPath: \.firstName, isVisible: \.personalizationEnabled),
			nestedTextField(title: "Last Name", keyPath: \.lastName, isVisible: \.personalizationEnabled),
			controlCell(title: "Random Greeting", control: uiSwitch(keyPath: \.useRandomGreeting), isVisible: \.personalizationEnabled)
		], footer: \.enabledPersonalizationTitle)
    ])

let hotspotForm: Form<Hotspot> =
    sections([
        section([
            controlCell(title: "Personal Hotspot", control: uiSwitch(keyPath: \.isEnabled))
        ], footer: \.enabledSectionTitle),
        section([
            detailTextCell(title: "Notification", keyPath: \.showPreview.text, form: showPreviewForm)
        ], isVisible: \.isEnabled),
        section([
            nestedTextField(title: "Password", keyPath: \.password),
            nestedTextField(title: "Network Name", keyPath: \.networkName)
        ], isVisible: \.isEnabled)
    ])
