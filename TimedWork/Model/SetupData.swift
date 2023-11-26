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
    let images: Array<NSImage>
}

class SetupItemData {
    static let data: Array<SetupItem> = [
        SetupItem(
            title: "Sync Calendars",
            description: "Official PayPal API Postman Collection including capabilities like Checkout Orders, Payments, Payouts, Subscriptions, Webhooks, and more.",
            isPremium: true,
            image: NSImage(named: "Calendar")!,
            images: [NSImage(named: "GCal")!, NSImage(named: "Teams")!]
        ),
       SetupItem(
        title: "Sync Work Apps",
        description: "Official PayPal API Postman Collection including capabilities like Checkout Orders, Payments, Payouts, Subscriptions, Webhooks, and more.",
        isPremium: false,
        image: NSImage(named: "WorkApp")!,
        images: [NSImage(named: "Slack")!, NSImage(named: "Zoom")!])
    ]
}
