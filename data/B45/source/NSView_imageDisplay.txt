import Cocoa
extension NSView {
    //--------------------------------------------------------------------------
    // ビューにイメージ（NSImageオブジェクト）を表示するとき、
    // イメージ全体がビューに収まるように、イメージのサイズをビューに対して正規化（拡大・縮小）する。
    // 横長のイメージでは上下が余白となり、縦長のイメージでは左右が余白となる。
    //--------------------------------------------------------------------------
    class func adjustFrame(rect: NSRect, image: NSImage) -> NSRect{
        let imageRep: NSImageRep = image.representations[0]
        let imageSize: NSSize = NSSize.init(width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
        var newRect = NSRect.init()
        if imageSize.width >= imageSize.height{
            newRect.size.width = rect.size.width
            newRect.size.height = imageSize.height * (newRect.size.width / imageSize.width)
            newRect.origin.x = 0
            newRect.origin.y = (rect.size.height - newRect.size.height) / 2;
        }else{
            newRect.size.height = rect.size.height
            newRect.size.width = imageSize.width * (newRect.size.height / imageSize.height)
            newRect.origin.y = 0
            newRect.origin.x = (rect.size.width - newRect.size.width) / 2;
        }
        return newRect
    }
}