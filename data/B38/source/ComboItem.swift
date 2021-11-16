//---- ComboItem.swift ----
import Cocoa

protocol ComboItemDelegate: class {
    func clickItem(_ index: Int, _ aString: NSAttributedString?)
    func selectItem(_ index: Int, _ aString: NSAttributedString?)
}

class ComboItem: NSView {
    var aStringValue : NSMutableAttributedString?
    var stringValue: String = "" {
        didSet{
            self.aStringValue =  NSMutableAttributedString.init(string: stringValue,
                                                         attributes: [.font : font])
        }
    }
    var index: Int = 0
    //フォント
    let font:NSFont = NSFont.init(name:"Monaco", size:14)
                                  ?? NSFont.systemFont(ofSize: 14)
    let shapeLine = CAShapeLayer.init()
    weak var delegate: ComboItemDelegate?  = nil  //デリゲートへの参照
    //y軸反転
    override var isFlipped:Bool {
        get {return true}
    }
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        //下線を引く
        self.wantsLayer = true
        let path = NSBezierPath.init()
        path.move(to: NSMakePoint(0, self.frame.size.height)) //始点
        path.line(to: NSMakePoint(self.frame.size.width, self.frame.size.height)) //終点
        shapeLine.lineWidth = 1.0
        shapeLine.strokeColor = NSColor.black.cgColor
        shapeLine.path = path.cgPath
        self.layer?.addSublayer(shapeLine)
        
        let options:NSTrackingArea.Options = [
            .mouseMoved,
            .mouseEnteredAndExited,
            .activeAlways
        ]
        //インスタンスの作成
        let trackingArea = NSTrackingArea.init(rect: self.bounds,
                                               options: options,
                                               owner: self,
                                               userInfo: nil)
        //インスタンスの追加
        self.addTrackingArea(trackingArea)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //要素の選択（前）
    override func mouseDown(with event: NSEvent) {
        self.delegate?.clickItem(index, aStringValue)
    }
    //要素の選択（後）
    override func mouseUp(with event: NSEvent) {
        self.delegate?.selectItem(index, aStringValue)
    }
    override func mouseEntered(with event: NSEvent){
        self.layer?.backgroundColor = NSColor.cyan.cgColor
        
    }
    override func mouseExited(with event: NSEvent){
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    //ビューの再描画
    override func draw(_ dirtyRect: NSRect) {
        
        if aStringValue != nil{
            let ypos = (self.frame.size.height / 2) - (aStringValue!.size().height / 2) - 1
            aStringValue!.draw(at: NSMakePoint(5, ypos))
        }
    }
}
