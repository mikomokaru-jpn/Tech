import Cocoa
class UAView: NSView {
    override func awakeFromNib() {
        //メニューバーを含むウィンドウ全体のビューのクラスを取得
        let obj = self.superview!
        let aClass : AnyClass = type(of: obj)
        //システム規定のmouseDownメソッドを入れ替える
        let m1 = class_getInstanceMethod(aClass, #selector(NSResponder.mouseDown(with:)))
        let m2 = class_getInstanceMethod(UAView.self, #selector(self.customMouseDown(with:)))
        method_exchangeImplementations(m1!, m2!)
        print(String(describing: type(of: aClass))) //NSThemeFrame.Type
    }
    //---- メニューバーのマウスダウンにより起動するメソッド ----
    @objc func customMouseDown(with event: NSEvent) {
        if (event.window?.title == "MainWindow"){
            let alert = NSAlert()
            alert.messageText = "♬ メニューバーのクリック ♬"
            alert.informativeText = "superMouseDown(with:)"
            alert.runModal()
        }
    }
    //---- コンテントビューのマウスダウンにより起動するメソッド ----
    override func mouseDown(with event: NSEvent) {
        let alert = NSAlert()
        alert.messageText = "♪♪ コンテントビューのクリック ♪♪"
        alert.informativeText = "mouseDown(with:)"
        alert.runModal()
        //self.superMouseDown(with: event) //自身のメソッドを呼ぶこともできる
    }
}
