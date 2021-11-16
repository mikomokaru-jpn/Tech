import Cocoa
class UAView: NSView {
    //操作を行うビュー
    let scaledView = UAScaledView(frame: 
        NSRect(x: 50, y: 50, width: 400, height: 300))
    
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addSubview(scaledView)
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented");
    }
    
    //マウスのドラッグでビュー拡大・縮小・移動を行う
    override func mouseDown(with event: NSEvent) {
        scaledView.select(event.locationInWindow)
    }
    override func mouseDragged(with event: NSEvent) {
        scaledView.scale(event.locationInWindow)
    }
    override func mouseUp(with event: NSEvent) {
        scaledView.scale(event.locationInWindow)
    }
}