class ViewBezier: NSView {

    override func draw(_ dirtyRect: NSRect) {      
        //円の描画
        let path1 = NSBezierPath(ovalIn: NSRect(x: 10, y: 10, width: 100, height: 100))
        NSColor.cyan.set()
        path1.fill()
        NSColor.black.set()
        path1.lineWidth = 5  //枠線
        path1.stroke()
        
        //線の描画
        NSColor.blue.set()
        let path2 = NSBezierPath.init()
        path2.lineWidth = 3
        path2.move(to: NSPoint(x: 60, y: 60))
        path2.line(to: NSPoint(x: 260, y: 260))
        path2.stroke()
    }   
}