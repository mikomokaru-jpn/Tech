import Cocoa
class UATextField: NSTextField {
    override func draw(_ dirtyRect: NSRect) {
        let y =  dirtyRect.size.height / 2 - self.attributedStringValue.size().height / 2;
        let newPoint = CGPoint(x: 4, y: y)
        self.attributedStringValue.draw(at: newPoint)
    }
}
