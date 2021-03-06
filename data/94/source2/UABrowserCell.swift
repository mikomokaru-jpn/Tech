import Cocoa
class UABrowserCell: NSBrowserCell {
    var icon: NSImage? = nil
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        var imageFrame: NSRect = NSZeroRect
        var textFrame: NSRect = NSZeroRect
        if let image = icon{
            //フレームの分割
            NSDivideRect(cellFrame, &imageFrame, &textFrame, image.size.width+8, .minX)
            //アイコンの表示
            imageFrame.origin.x += 4;
            imageFrame.size = image.size
            image.draw(in: imageFrame,
                       from: NSMakeRect(0, 0, image.size.width, image.size.height),
                       operation: .sourceOver, fraction: 1.0)
            //名前の表示
            super.drawInterior(withFrame: textFrame, in: controlView)
            
        }else{
            //名前の表示・アイコン無し
            super.drawInterior(withFrame: cellFrame, in: controlView)
        }
    }
}
