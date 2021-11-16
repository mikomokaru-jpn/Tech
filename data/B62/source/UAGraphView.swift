import Cocoa
class UAGraphView: NSView {
    //入力グラフ属性
    var definition: [String:String] = [:]
    //入力データ
    var data = [Float]()
    //入力項目名
    var nameList = [String]()

    //---- イニシャライザ ----
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //---- グラフの描画 ----
    func makeGraph(){
        //高さ
        let height: CGFloat = CGFloat(getValue("height"))
        //最大値
        let maxValue: CGFloat = CGFloat(getValue("maxValue"))
        //要素の幅
        let unitWidth: CGFloat = CGFloat(getValue("unitWidth"))
        //項目名の高さ
        let nameHeight: CGFloat = CGFloat(getValue("nameHeight"))
        //グラフの上余白
        let topMargin: CGFloat = CGFloat(getValue("topMargin"))
        //目盛見出しりの幅
        let scaleWidth: CGFloat = CGFloat(getValue("scaleWidth"))
        //補助線目盛りの単位
        let scaleValue: CGFloat = CGFloat(getValue("scaleValue"))
        //グラフビューの位置
        self.frame.origin = NSPoint.init(x: 20, y: 20)
        //グラフの大きさ
        let width = unitWidth * CGFloat(data.count) + scaleWidth
        self.frame.size = NSSize.init(width: CGFloat(width)+1, height: CGFloat(height))
        //データの最大値
        guard let max = data.max() else{
            return
        }
        let graphHeight = self.frame.height - nameHeight - topMargin //グラフ領域の高さ
        //初期化・サブビュー/サブレイヤーの削除
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }        
        //データ・棒グラフ
        for i in 0 ..< data.count{
            let aHeight: CGFloat
            if maxValue > 0{
                aHeight = graphHeight * (CGFloat(data[i]) / maxValue)
            }else{
                aHeight = graphHeight * (CGFloat(data[i]) / CGFloat(max))
            }
            let unit = NSView.init(frame: NSRect.init(x: CGFloat(i) * unitWidth + scaleWidth,
                                                      y: nameHeight,
                                                      width: unitWidth+1,
                                                      height: aHeight))
            unit.wantsLayer = true
            unit.layer?.borderColor = NSColor.black.cgColor
            unit.layer?.borderWidth = 1
            self.addSubview(unit)
        }
        //項目名
        for i in 0 ..< nameList.count{
            let unitName = UANameView(frame: NSRect(x: CGFloat(i) * unitWidth + scaleWidth,
                                                    y: 0,
                                                    width: nameHeight,
                                                    height: unitWidth))
            unitName.positionYoko = .left
            unitName.frameRotation = 90
            unitName.frame.origin.x += unitWidth
            unitName.frame.origin.y += 10
            self.addSubview(unitName)
            unitName.name = nameList[i]
        }
        //目盛り見出し・補助線
        let scaleHight: CGFloat
        if maxValue > 0{
            scaleHight = graphHeight * (scaleValue / maxValue)
        }else{
            scaleHight = graphHeight * (scaleValue / CGFloat(max))
        }
        var counter = 0
        for value in stride(from: scaleHight, to: self.frame.height - nameHeight, by: scaleHight){
            //目盛り見出し
            let scaleView = UANameView(frame: NSRect(x: 0,
                                                      y: value + nameHeight - scaleHight,
                                                      width: scaleWidth,
                                                      height: scaleHight*2))
            scaleView.positionTate = .middle
            scaleView.positionYoko = .right
            self.addSubview(scaleView)
            counter += 1
            scaleView.name = Int(scaleValue * CGFloat(counter)).description + "　"
            //補助線
            let axLine = CAShapeLayer()
            let path = NSBezierPath()
            path.move(to: NSPoint.init(x: scaleWidth, y: value + nameHeight))
            path.line(to: NSPoint.init(x: self.frame.width, y: value + nameHeight))
            axLine.strokeColor = NSColor.lightGray.cgColor
            axLine.path = path.cgPath
            self.layer?.addSublayer(axLine)
        }
    }
    //---- 定義値の取得 ----
    private func getValue(_ key: String) -> Float{
        if let s = definition[key]{
            if let f = Float(s){
                return f
            }
        }
        return 0
    }
}



