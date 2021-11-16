import Cocoa
class UAView: NSView, CAAnimationDelegate {
    let diatance :Double = 4.0  //ベクトルの距離（固定）
    var timer: Timer? = nil     //タイマーオブジェクト
    var x :CGFloat = 0          //図形のx座標
    var y :CGFloat = 0          //図形のy座標
    var vx :CGFloat = 0         //ベクトルのx成分
    var vy :CGFloat = 0         //ベクトルのy成分
    let diameter: CGFloat = 30  //ボールの直径
    
    override var isFlipped:Bool {
        get {return true}
    }
    //---- イニシャライザ ----
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.layer?.borderWidth = 1.0
        self.changeDirection() //方向をランダムに変える
        //定時起動
        self.timer = Timer.scheduledTimer(timeInterval: 0.01,
                                          target: self,
                                          selector: #selector(reDisplay),
                                          userInfo: nil,
                                          repeats: true)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //---- 図形の描画 ----
    override func draw(_ dirtyRect: NSRect) {
        NSColor.red.set()
        let path = NSBezierPath()
        path.appendOval(in: NSRect.init(x: x, y: y, width: diameter, height: diameter))
        path.fill()
    }
    //---- 描画位置の計算 ----
    @objc func reDisplay(){
        x += vx
        y += vy
        if (x > self.frame.width - diameter || x < 0){
            vx = -vx
        }
        if (y > self.frame.height - diameter || y < 0){
            vy = -vy
        }
        self.needsDisplay = true
    }
    //---- 方向をランダムに変える ----
    func changeDirection(){
        //距離4のベクトル成分をランダムに求める
        let angle = Int(arc4random_uniform(UInt32(360)))
        self.vx = CGFloat(diatance * sin(Double(angle) * Double.pi / 180))
        self.vy = CGFloat(diatance * cos(Double(angle) * Double.pi / 180))
    }
}

