//------------------------------------------------------------------------------
//  AppDelegate.swift
//------------------------------------------------------------------------------
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var view: UAView?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let rect = window.contentView?.frame{
            view = UAView.init(frame: rect)
            window.contentView?.addSubview(view!)
        }
    }
}

