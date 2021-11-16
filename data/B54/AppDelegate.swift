import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    let view = UAView.init(frame: CGRect.init(x: 10, y: 40, width: 300, height: 300))
    let button = NSButton(frame: CGRect.init(x: 10, y: 10, width: 120, height: 20))
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(view)
        window.contentView?.addSubview(button)
        button.title = "changeDirection"
        button.bezelStyle = .roundRect
        button.target = view
        button.action = #selector(view.changeDirection)
    }
}