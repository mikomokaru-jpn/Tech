func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.contentView?.layer?.backgroundColor = NSColor.white.cgColor

    //円の作成
    let shape1 = CAShapeLayer()
    let path1 = NSBezierPath(ovalIn: NSRect(x: 10, y: 10,
                                            width: 100, height: 100))
    shape1.path = path1.cgPath
    shape1.fillColor = NSColor.cyan.cgColor
    shape1.lineWidth = 5
    shape1.strokeColor = NSColor.black.cgColor
    self.window.contentView?.layer?.addSublayer(shape1)
    
    //線の作成
    let shape2 = CAShapeLayer()
    let path2 = NSBezierPath()
    path2.move(to: NSPoint(x: 60, y: 60))
    path2.line(to: NSPoint(x: 260, y: 260))
    shape2.path = path2.cgPath
    shape2.lineWidth = 3
    shape2.strokeColor = NSColor.blue.cgColor
    self.window.contentView?.layer?.addSublayer(shape2)
}
