import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.setContentSize(NSSize.init(width: 420, height: 420))
        let viewM = UAViewM(frame: NSRect(x: 10, y: 10, width: 400, height: 400))
        viewM.autoresizingMask =  [.width, .height]
        self.window.contentView?.addSubview(viewM)
    }
}

