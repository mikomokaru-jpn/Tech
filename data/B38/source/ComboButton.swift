//---- ComboButton.swift ----
import Cocoa

protocol ComboButtonDelegate: class {
    func clickPulldownButton()
}
class ComboButton: AcceptFirstView {
    //y軸反転
    override var isFlipped:Bool {
        get {return true}
    }
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        self.layer?.borderWidth = 1.0
        self.layer?.borderColor = NSColor.black.cgColor
        let image = AcceptFirstView.init(
            frame: NSMakeRect(self.frame.width / 4,
                              self.frame.height / 4,
                              self.frame.width / 2,
                              self.frame.height / 2))
        image.wantsLayer = true
        image.layer?.contents = NSImage.init(named:NSImage.Name.addTemplate)
        self.addSubview(image)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    weak var delegate: ComboButtonDelegate?  = nil  //デリゲートへの参照
    //マウスクリック
    override func mouseDown(with event: NSEvent) {
        self.delegate?.clickPulldownButton()
    }
}
