import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var view = UAView.init(frame: CGRect.init(x: 10, y: 10, 
                                              width: 300, height: 300))
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(view)
    }
    @IBAction func reset(_ sender: NSButton){
        view.changeDirection()
    }
}
