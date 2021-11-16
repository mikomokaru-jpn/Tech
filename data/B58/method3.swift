class ViewContext: NSView {

    override func draw(_ dirtyRect: NSRect) {
        //円の描画
        let context:CGContext? = NSGraphicsContext.current?.cgContext
        context?.addEllipse(in: CGRect.init(x: 10, y: 10,
                                            width: 100, height: 100))
        context?.setFillColor(NSColor.cyan.cgColor)
        //context?.fillPath() //NG

        //枠線の描画
        context?.setLineWidth(5)
        context?.setStrokeColor(NSColor.black.cgColor)
        //context?.strokePath() //NG
        
        //コンテキストに円と枠線を一緒に出力する（NGのように別々に描画すると枠線が出力されない）
        context?.drawPath(using: .fillStroke)
        
        //線の描画
        context?.move(to: CGPoint(x: 60, y: 60))
        context?.addLine(to:CGPoint(x: 260, y: 260))
        context?.setStrokeColor(NSColor.blue.cgColor)
        context?.strokePath()    
    }
}