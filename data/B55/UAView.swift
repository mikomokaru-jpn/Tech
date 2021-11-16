import Cocoa
class UAView: NSView, CAAnimationDelegate {
    let diatance :Double = 4.0  //ベクトルの距離（固定）
    let ball = CAShapeLayer()   //図形レイヤーオブジェクト
    //アニメーションオブジェクト
    let animation = CABasicAnimation(keyPath: "position") 
    var x :CGFloat = 0          //図形のx座標
    var y :CGFloat = 0          //図形のy座標
    var vx :CGFloat = 0         //ベクトルのx成分
    var vy :CGFloat = 0         //ベクトルのy成分
    
    override var isFlipped:Bool {
        get {return true}
    }
    //---- イニシャライザ ----
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.blue.cgColor
        //図形（ボール）を作り、レイヤーに追加する
        let path = NSBezierPath()
        path.appendOval(in: NSRect(x: x, y: y, width: 30, height: 30))
        ball.path = path.cgPath
        ball.fillColor = NSColor.red.cgColor
        self.layer?.addSublayer(ball)
        //アニメーションの設定
        animation.duration = 0.01 //秒
        animation.delegate = self
        animation.repeatCount = 1
        self.changeDirection()  //方向をランダムに変える
        self.reAnimate()        //アニメーションの実行
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //---- アニメーションの終了通知 ----
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        self.reAnimate()
    }
    //---- 描画位置の再計算とアニメーションの開始 ----
    @objc func reAnimate(){
        x += vx
        y += vy
        if (x > self.frame.width - 30 || x < 0){
            vx = -vx
        }
        if (y > self.frame.height - 30 || y < 0){
            vy = -vy
        }
        animation.fromValue = [x, y]
        animation.toValue =  [x + vx, y + vy]
        ball.position = CGPoint.init(x: x, y: y)
        ball.removeAllAnimations()
        ball.add(animation, forKey: "bauncing_ball")
    }
    //---- 方向をランダムに変える ----
    func changeDirection(){
        //距離4のベクトル成分をランダムに求める
        let angle = Int(arc4random_uniform(UInt32(360)))
        self.vx = CGFloat(diatance * sin(Double(angle) * Double.pi / 180))
        self.vy = CGFloat(diatance * cos(Double(angle) * Double.pi / 180))
    }
}