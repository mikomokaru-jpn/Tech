import Cocoa
class ShapeView: NSView {

    var text :NSMutableAttributedString?
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.lightGray.cgColor
        //self.layer?.borderWidth = 2
        
        let font = NSFont.systemFont(ofSize: 26)
        text = NSMutableAttributedString.init(string: "天地無用？",
                                              attributes: [NSAttributedStringKey.font:font])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //ビューの再描画
    override func draw(_ dirtyRect: NSRect) {
        let path1 = NSBezierPath(rect: NSRect(x: 0, y: 0, width: 10, height: 10))
        NSColor.red.set()
        path1.fill()
        //中央に文字列を表示する
        if let textSize = text?.size(){
            let point = NSPoint.init(x: self.bounds.width / 2 -  CGFloat(textSize.width) / 2,
                                     y: self.bounds.height / 2 - CGFloat(textSize.height) / 2)
            text?.draw(at: point)
        }
    }
}
