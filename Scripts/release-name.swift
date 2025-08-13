#!/usr/bin/env swift

import Foundation

/// UI kit components paired with matching animals for alliterative release names.
let components = [
    "Button", "Form", "Layout", "Modal", "Navigation",
    "Panel", "Queue", "Stack", "Theme", "Widget"
]

let animals = [
    "Beaver", "Fox", "Lynx", "Mole", "Narwhal",
    "Panda", "Quokka", "Stoat", "Tiger", "Walrus"
]

func releaseName(for version: String) -> String {
    let numbers = version.split(separator: ".").compactMap { Int($0) }
    let index = numbers.reduce(0, +)
    return "\(components[index % components.count]) \(animals[index % animals.count])"
}

if CommandLine.arguments.count > 1 {
    let version = CommandLine.arguments[1]
    print(releaseName(for: version))
} else {
    fputs("Usage: release-name <version>\n", stderr)
    exit(1)
}
