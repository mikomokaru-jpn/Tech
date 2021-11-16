import Cocoa
class AcceptFirstView: NSView {
    //アクティブでないビューをクリックしたときに即反応する
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool{
        return true
    }
}
