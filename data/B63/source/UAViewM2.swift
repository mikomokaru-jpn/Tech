
//親ビュー
import Cocoa
class UAViewM: NSView {
    private var observers = [NSKeyValueObservation]()
    private var originalViewSize = NSZeroSize
    private var originalSubViewSize = NSSize(width: 60, height: 60) //子ビューのサイズ
    private var fontSize: CGFloat = 50
    private var subviewArray = [[UAViewS]]()
    //Y軸反転
    override var isFlipped: Bool{
        return true
    }
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        originalViewSize = self.bounds.size
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.borderColor = NSColor.black.cgColor
        //子ビューを作成する
        for i in 0 ..< 3{
            subviewArray.append([])
            for j in 0 ..< 3{
                let frame = NSRect.init(x: originalSubViewSize.width * CGFloat(j) + 20,
                                        y: originalSubViewSize.height * CGFloat(i) + 20,
                                        width: originalSubViewSize.width,
                                        height: originalSubViewSize.height)
                let subView = UAViewS.init(frame: frame)
                let text = String(3 * i + j)
                subView.attrText = NSMutableAttributedString(string: text)
                subView.updateText(fontSize: fontSize)
                self.addSubview(subView)
                subviewArray[i].append(subView)
            }
        }
        //子ビュー（自身）のサイズが変わったとき
        observers.append(self.observe(\.layer?.bounds, options: [.old, .new]){_,change in
            if let bounds = change.newValue as? CGRect{
                let rateWidth: CGFloat = bounds.width / self.originalViewSize.width
                let rateHeight: CGFloat = bounds.height / self.originalViewSize.height
                print(String(format: "%.4f %.4f", rateWidth, rateHeight))
                //孫ビューの位置とサイズを変更する
                for i in 0 ..< 3{
                    for j in 0 ..< 3{
                        let newWidth = self.originalSubViewSize.width * rateWidth
                        let newHeight = self.originalSubViewSize.width * rateHeight
                        self.subviewArray[i][j].frame.size.width = newWidth
                        self.subviewArray[i][j].frame.size.height = newHeight
                        self.subviewArray[i][j].frame.origin.x = CGFloat(j) * newWidth + 20 * rateWidth
                        self.subviewArray[i][j].frame.origin.y = CGFloat(i) * newHeight + 20 * rateHeight
                        self.subviewArray[i][j].updateText(fontSize: self.fontSize * sqrt(rateWidth * rateHeight))
                    }
                }
            }
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
}
