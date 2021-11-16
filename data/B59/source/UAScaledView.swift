import Cocoa
class UAScaledView: NSView {    
    //点・線要素
    enum Positions {
        case none
        case pointA     //左下
        case pointB     //右下
        case pointC     //右上
        case pointD     //左上
        case lineAB     //下辺
        case lineBC     //右辺
        case lineCD     //上辺
        case lineDA     //左辺
        case area       //矩形内
    }
    let tolerance :CGFloat = 5 //許容範囲（ピクセル）
    var selectedPosition :Positions = .none //選択中要素
    var startPoint = NSZeroPoint
    //自身の点の位置
    var pointA: NSPoint{
        return self.frame.origin
    }
    var pointB: NSPoint{
        return NSPoint.init(x: self.frame.origin.x + self.frame.size.width,
                            y: self.frame.origin.y)
    }
    var pointC: NSPoint{
        return NSPoint.init(x: self.frame.origin.x + self.frame.size.width,
                            y: self.frame.origin.y + self.frame.size.height)
    }
    var pointD: NSPoint{
        return NSPoint.init(x: self.frame.origin.x,
                            y: self.frame.origin.y + self.frame.size.height)
    }
    //自身の線の位置
    var lineAB: (NSPoint, NSPoint){
        return (pointA, pointB)
    }
    var lineBC: (NSPoint, NSPoint){
        return (pointB, pointC)
    }
    var lineCD: (NSPoint, NSPoint){
        return (pointC, pointD)
    }
    var lineDA: (NSPoint, NSPoint){
        return (pointD, pointA)
    }
    //自身の四辺で囲まれた範囲
    var area: (NSPoint, NSPoint){
        return (pointA, pointC)
    }
    //---- イニシャライザ ----
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.borderWidth = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--- 点・線・領域の選択 ----
    @discardableResult func select(_ point: NSPoint) -> Positions{
        startPoint = point
        if nearPoint(pointA, point){
            selectedPosition = .pointA
        }else if nearPoint(pointB, point){
            selectedPosition = .pointB
        }else if nearPoint(pointC, point){
            selectedPosition = .pointC
        }else if nearPoint(pointD, point){
            selectedPosition = .pointD
        }else if nearLine(lineAB, point) {
            selectedPosition = .lineAB
        }else if nearLine(lineBC, point) {
            selectedPosition = .lineBC
        }else if nearLine(lineCD, point) {
            selectedPosition = .lineCD
        }else if nearLine(lineDA, point) {
            selectedPosition = .lineDA
        }else if inArea(area, point){
            selectedPosition = .area
        }else{
            selectedPosition = .none
            startPoint = NSZeroPoint
        }
        return selectedPosition
    }
    //---- サイズ変更・移動 -----
    func scale(_ point :NSPoint){
        switch selectedPosition {
        //---- 点 ----
        case .pointA:
            let width = startPoint.x - point.x
            let height = startPoint.y - point.y
            self.frame.size = NSSize.init(width: self.frame.width + width ,
                                          height: self.frame.size.height + height)
            self.frame.origin.x -= width
            self.frame.origin.y -= height
            break
        case .pointB:
            let width = point.x - startPoint.x
            let height = startPoint.y - point.y
            self.frame.size = NSSize.init(width: self.frame.width + width ,
                                          height: self.frame.size.height + height)
            self.frame.origin.y -= height
            break
        case .pointC:
            let width = point.x - startPoint.x
            let height = point.y - startPoint.y
            self.frame.size = NSSize.init(width: self.frame.width + width ,
                                          height: self.frame.size.height + height)
            break
        case .pointD:
            let width = startPoint.x - point.x
            let height = point.y - startPoint.y
            self.frame.size = NSSize.init(width: self.frame.width + width ,
                                          height: self.frame.size.height + height)
            self.frame.origin.x -= width
            break
        //---- 線 ----
        case .lineAB:
            let height = startPoint.y - point.y
            self.frame.size = NSSize.init(width: self.frame.width,
                                          height: self.frame.size.height + height)
            self.frame.origin.y -= height
            break
            
        case .lineBC:
            let width = point.x - startPoint.x
            self.frame.size = NSSize.init(width: self.frame.width + width,
                                            height: self.frame.size.height)
            break
        case .lineCD:
            let height = point.y - startPoint.y
            self.frame.size = NSSize.init(width: self.frame.width,
                                          height: self.frame.size.height + height)
            break
        case .lineDA:
            let width = startPoint.x - point.x
            self.frame.size = NSSize.init(width: self.frame.width + width,
                                          height: self.frame.size.height)
            self.frame.origin.x -= width
            break
        //エリア
        case .area:
            self.frame.origin.x += point.x - startPoint.x
            self.frame.origin.y += point.y - startPoint.y
            break
        default:
            return
        }
        startPoint = point
    }
    //---- 点が近い ----
    private func nearPoint( _ point1:NSPoint, _ point2:NSPoint) -> Bool{
        if fabs(point1.x - point2.x) <= tolerance &&
            fabs(point1.y - point2.y) <= tolerance{
            return true
        }
        return false
    }
    //---- 線が近い ----
    private func nearLine(_ inline :(NSPoint, NSPoint), _ point :NSPoint) -> Bool{
        if inline.0.y == inline.1.y{
            //水平線
            var line = inline
            if line.0.x > line.1.x {
                line = (line.1, line.0)
            }
            if (line.0.x <= point.x  && point.x <= line.1.x) &&
                (fabs(point.y - line.0.y) < tolerance){
                return true
            }
        }else{
            //垂直線
            var line = inline
            if line.0.y > line.1.y {
                line = (line.1, line.0)
            }
            if (line.0.y <= point.y  && point.y <= line.1.y) &&
                (fabs(point.x - line.0.x) < tolerance){
                return true
            }
        }
        return false
    }
    //---- 矩形の領域内 ----
    private func inArea(_ rect: (NSPoint, NSPoint), _ point: NSPoint) -> Bool{
        if rect.0.x <= point.x && point.x <= rect.1.x {
            if rect.0.y <= point.y && point.y <= rect.1.y{
                return true
            }
        }
        return false
    }
}
