//
//  SetupData.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 25.11.23.
//

import Foundation
import Cocoa

struct SetupItem {
    let title: String
    let description: String
    let isPremium: Bool
    let image: NSImage
    let images: Array<NSImage?>
}

let appIcons = FileSystemOperations.shared.getInstalledApps()[0...9].map({ app in
    return app.appIcon
})

class SetupItemData {
    static let data: Array<SetupItem> = [
       SetupItem(
        title: "Designate Work Apps",
        description: "Official PayPal API Postman Collection including capabilities like Checkout Orders, Payments, Payouts, Subscriptions, Webhooks, and more.",
        isPremium: false,
        image: NSImage(named: "WorkApp")!,
        images: appIcons),
       
       SetupItem(
           title: "Track Calendars",
           description: "Official PayPal API Postman Collection including capabilities like Checkout Orders, Payments, Payouts, Subscriptions, Webhooks, and more.",
           isPremium: true,
           image: NSImage(named: "Calendar")!,
           images: [NSImage(named: "GCal")!, NSImage(named: "Teams")!]
       ),
    ]
}
