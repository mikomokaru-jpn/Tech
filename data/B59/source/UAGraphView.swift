import Cocoa
class UAGraphView: UAScaledView {
    //グラフ値要素
    var unitList = [NSView]()
    //---- イニシャライザ ----
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        //ビューの変更を監視する
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.resizeGraph),
                                               name: NSView.frameDidChangeNotification,
                                               object: nil)
        self.postsFrameChangedNotifications = true //忘れずに
        self.makeGraph()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //グラフの描画
    func makeGraph(){
        unitList = []
        for _ in 0 ..< 10{
            let unit = NSView.init(frame: NSRect.init())
            unit.wantsLayer = true
            unit.layer?.borderColor = NSColor.black.cgColor
            unit.layer?.borderWidth = 1
            self.addSubview(unit)
            self.unitList.append(unit)
        }
        self.resizeGraph()
    }
    //ビューのサイズを変更する
    //var count = 0
    @objc func resizeGraph(){
        //count += 1
        //print("resizeGraph \(count)")
        let aWidth = self.frame.width / 10
        for i in 0 ..< 10{
            let aHeight = self.frame.height * 0.9 * (CGFloat(i+1) / 10)
            unitList[i].frame = NSRect.init(x: CGFloat(i) * aWidth, y: 0,
                                            width: aWidth+1, height: aHeight)
        }
    }
}