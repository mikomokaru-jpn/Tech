import Cocoa
class UAView: NSView {
    var startPoint = NSMakePoint(0, 0)
    var endPoint = NSMakePoint(0, 0)
    
    //マウスのドラッグでウィンドウを移動する
    override func mouseDown(with event: NSEvent) {
        startPoint =  event.locationInWindow
        //ボタンの周縁部をクリックしたとき、mouseDownイベントが発生しない。
    }
    override func mouseDragged(with event: NSEvent) {
        //ボタンの周縁部をクリックしたとき、mouseDownイベントが発生しないことの対応
        if startPoint == NSZeroPoint{
            return
        }
        endPoint =  event.locationInWindow
        let xSpan = endPoint.x - startPoint.x
        let ySpan = endPoint.y - startPoint.y
        var newOrigin =  self.window!.frame.origin
        newOrigin.x += xSpan
        newOrigin.y += ySpan
        self.window!.setFrameOrigin(newOrigin)
    }
    override func mouseUp(with event: NSEvent) {
        //ボタンの周縁部をクリックしたとき、mouseDownイベントが発生しないことの対応
        if startPoint == NSZeroPoint{
            return
        }
        endPoint =  event.locationInWindow
        let xSpan = endPoint.x - startPoint.x
        let ySpan = endPoint.y - startPoint.y
        var newOrigin =  self.window!.frame.origin
        newOrigin.x += xSpan
        newOrigin.y += ySpan
        startPoint = NSZeroPoint //リセット
        self.window!.setFrameOrigin(newOrigin)
    }
}
