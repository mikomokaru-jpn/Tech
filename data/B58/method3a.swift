func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.contentView?.layer?.backgroundColor = NSColor.white.cgColor
    //ビューの作成
    let view = ViewContext.init(frame: self.window.contentView!.frame)
    self.window.contentView?.addSubview(view)
}