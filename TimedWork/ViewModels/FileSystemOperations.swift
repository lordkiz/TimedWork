//
//  FileSystemOperations.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 26.11.23.
//

import Cocoa

struct InstalledApp {
    var appUrl: URL
    var appIcon: NSImage?
    var appName: String
}

class FileSystemOperations: NSObject {
    static let shared = FileSystemOperations()
    
    override init() {
        super.init()
    }
    
    func getInstalledApps() -> [InstalledApp] {
        
        let localAppUrls = getApplicationUrlsAt(directory: .applicationDirectory, domain: .localDomainMask)
        let systemAppUrls = getApplicationUrlsAt(directory: .applicationDirectory, domain: .systemDomainMask)
        let systemUtilitiesAppUrls = getApplicationUrlsAt(directory: .applicationDirectory, domain: .systemDomainMask, subpath: "/Utilities")
        
        let appUrls = localAppUrls + systemAppUrls + systemUtilitiesAppUrls
        
        var apps = [InstalledApp]()
        
        appUrls.forEach({ url in
            do {
                let resourceKeys: [URLResourceKey] = [.isExecutableKey, .isApplicationKey]
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                if (resourceValues.isApplication! && resourceValues.isExecutable!) {
                    let name = url.deletingPathExtension().lastPathComponent
                    var icon: NSImage
                    if #available(macOS 13.0, *) {
                        icon = NSWorkspace.shared.icon(forFile: url.path(percentEncoded: false))
                    } else {
                        icon = NSWorkspace.shared.icon(forFile: url.path)
                    }
                    apps.append(InstalledApp(appUrl: url, appIcon: icon, appName: name))
                }
            } catch {
                //
            }
        })
        return apps
    }
    
    private func getApplicationUrlsAt(directory: FileManager.SearchPathDirectory, domain: FileManager.SearchPathDomainMask, subpath: String? = "") -> [URL] {
        let fileManager = FileManager()
        
        do {
            let folderUrl = try FileManager.default.url(for: directory, in: domain, appropriateFor: nil, create: false)
            let folderUrlWithSubPath = NSURL.init(string: folderUrl.path + (subpath ?? ""))! as URL
            let appUrls = try fileManager.contentsOfDirectory(at: folderUrlWithSubPath, includingPropertiesForKeys: [], options: [.skipsPackageDescendants, .skipsSubdirectoryDescendants])
            return appUrls
        } catch {
            return []
        }
    }
    
    private func folderHasCustomIcon(path: String) -> Bool {
        let iconPath = NSString.path(withComponents: [path, "Icon\r"])
        return FileManager.default.fileExists(atPath: iconPath)
        
    }
}
