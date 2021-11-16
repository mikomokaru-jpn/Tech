import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.setContentSize(NSSize.init(width: 460, height: 460))
        let viewL = UAViewL(frame: NSRect(x: 10, y: 10, width: 440, height: 440))
        viewL.autoresizingMask =  [.width, .height]
        self.window.contentView?.addSubview(viewL)
    }
}

