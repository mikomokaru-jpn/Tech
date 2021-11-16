func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.contentView?.layer?.backgroundColor = NSColor.white.cgColor
    //ビューの作成
    let view = ViewBezier.init(frame: self.window.contentView!.frame)
    self.window.contentView?.addSubview(view)
}