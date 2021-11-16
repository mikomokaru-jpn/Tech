import Cocoa
class UAViewS: NSView {

    var attrText: NSMutableAttributedString?
    var textSize = NSZeroSize
    var selected: Bool = false
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.borderColor = NSColor.gray.cgColor
        self.selectedOperation()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let text = self.attrText{
            let point =  NSPoint.init(x: self.bounds.width / 2 - textSize.width / 2,
                                      y: self.bounds.height / 2 - textSize.height / 2)
            text.draw(at: point)
        }
    }
    override func mouseDown(with event: NSEvent) {
        selected = !selected
        self.selectedOperation()
        self.needsDisplay = true
    }
    func updateText(fontSize: CGFloat){
        let font = NSFont.systemFont(ofSize: fontSize)
        attrText?.addAttributes([.font:font],
                                range: NSMakeRange(0, attrText?.string.count ?? 0))
        self.textSize = attrText?.size() ?? NSZeroSize
    }
    private func selectedOperation(){
        if selected{
            self.layer?.backgroundColor = NSColor.yellow.cgColor
        }else{
            self.layer?.backgroundColor = NSColor.white.cgColor
        }
    }
}
