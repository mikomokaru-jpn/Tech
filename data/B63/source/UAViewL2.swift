
import Cocoa

class UAViewL: NSView {
    private var observers = [NSKeyValueObservation]()
    private var originalViewSize = NSZeroSize
    private var originalSubViewSize = NSSize(width: 220, height: 220) //子ビューのサイズ
    private var subviewArray = [[UAViewM]]()
    //Y軸反転
    override var isFlipped: Bool{
        return true
    }
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        originalViewSize = self.bounds.size
        self.wantsLayer = true
        self.layer?.borderWidth = 2
        self.layer?.borderColor = NSColor.black.cgColor
        //子ビューを作成する
        for i in 0 ..< 3{
            subviewArray.append([])
            for j in 0 ..< 3{
                let frame = NSRect.init(x: originalSubViewSize.width * CGFloat(j),
                                        y: originalSubViewSize.height * CGFloat(i),
                                        width: originalSubViewSize.width,
                                        height: originalSubViewSize.height)
                let subView = UAViewM.init(frame: frame)
                self.addSubview(subView)
                subviewArray[i].append(subView)
            }
        }
        //親ビュー（自身）のサイズが変わったとき（コンテントビューのサイズと連動する）
        observers.append(self.observe(\.layer?.bounds, options: [.old, .new]){_,change in
            if let bounds = change.newValue as? CGRect{
                let rateWidth: CGFloat = bounds.width / self.originalViewSize.width
                let rateHeight: CGFloat = bounds.height / self.originalViewSize.height
                print(String(format: "%.4f %.4f", rateWidth, rateHeight))
                //子ビューの位置とサイズを変更する
                for i in 0 ..< 3{
                    for j in 0 ..< 3{
                        let newWidth = self.originalSubViewSize.width * rateWidth
                        let newHeight = self.originalSubViewSize.width * rateHeight
                        self.subviewArray[i][j].frame.size.width = newWidth
                        self.subviewArray[i][j].frame.size.height = newHeight
                        self.subviewArray[i][j].frame.origin.x = CGFloat(j) * newWidth
                        self.subviewArray[i][j].frame.origin.y = CGFloat(i) * newHeight
                    }
                }
            }
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
