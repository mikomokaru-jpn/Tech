class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ....
        let calendarView = UACalView2.init(frame: NSRect.init(x: 10, y: 10, width: 0, height: 0))
        window.contentView?.addSubview(calendarView)
    }
}