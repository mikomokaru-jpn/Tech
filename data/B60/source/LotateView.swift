import Cocoa
class LotateView: NSView {
    //回転するビュー
    let aShape = ShapeView.init(frame: NSRect.init(x: 200, y: 200, width: 150, height: 50))
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.layer?.borderWidth = 1
        self.addSubview(aShape)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //ビューの再描画
    override func draw(_ dirtyRect: NSRect) {
        //補助線・横
        let path1 = NSBezierPath.init()
        path1.lineWidth = 1
        path1.move(to: NSPoint(x: 0, y: self.bounds.height / 2))
        path1.line(to: NSPoint(x: self.bounds.width, y: self.bounds.height / 2))
        path1.stroke()
        //補助線・縦
        let path2 = NSBezierPath.init()
        path2.lineWidth = 1
        path2.move(to: NSPoint(x: self.bounds.width / 2, y: 0))
        path2.line(to: NSPoint(x: self.bounds.width / 2, y: self.bounds.height))
        path2.stroke()
    }
    func lotate(){
        //ビューを回転する
        aShape.frameRotation += 45
    }
    func right(){
        //右へ移動
        aShape.frame.origin.x += 50
    }
    func up(){
        //上へ移動
        aShape.frame.origin.y += 50
    }
    func left(){
        //左へ移動
        aShape.frame.origin.x -= 50
    }
    func down(){
        //下へ移動
        aShape.frame.origin.y -= 50
    }
    func heigher(){
        //高く
        aShape.frame.size.height += 10
    }
    func lower(){
        //低く
        aShape.frame.size.height -= 10
    }
    func widen(){
        //広く
        aShape.frame.size.width += 10
    }
    func narrow(){
        //狭く
        aShape.frame.size.width -= 10
    }
}
