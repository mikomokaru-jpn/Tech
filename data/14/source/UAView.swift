import Cocoa

class UAView: NSView, CAAnimationDelegate {

    let circleLayer1 = CAShapeLayer()
    let animation1 = CABasicAnimation(keyPath: "position")
    
    let circleLayer2 = CAShapeLayer()
    let animation2 = CABasicAnimation(keyPath: "position")

    var animatedStatus = false //ステータス
    
    override var isFlipped:Bool {
        get {return true}
    }
    //--------------------------------------------------------------------------
    // イニシャライザ
    //--------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        
        let x1 = self.frame.width - 100
        let y1 = self.frame.height - 100
        
        let x2 = self.frame.width / 2 - 50
        let y2 = self.frame.height / 2 - 50

        let path1 = NSBezierPath.init()
        path1.appendOval(in: NSRect.init(x: 0, y: 0, width: 100, height: 100))
        circleLayer1.path = path1.cgPath
        circleLayer1.fillColor = NSColor.red.cgColor
        circleLayer1.position = CGPoint.init(x: 0, y: y2)
        
        self.layer?.addSublayer(circleLayer1)
        animation1.fromValue = [0, y2]
        animation1.toValue = [x1, y2]
        animation1.duration = 2.0
        animation1.autoreverses = true
        animation1.repeatCount = .infinity
        animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        
        let path2 = NSBezierPath.init()
        path2.appendOval(in: NSRect.init(x: 0, y: 0, width: 100, height: 100))
        circleLayer2.path = path2.cgPath
        circleLayer2.fillColor = NSColor.blue.cgColor
        circleLayer2.position = CGPoint.init(x: 0, y: y2)
        
        self.layer?.addSublayer(circleLayer2)
        animation2.fromValue = [x2, 0]
        animation2.toValue = [x2, y1]
        animation2.duration = 1.0
        animation2.autoreverses = true
        animation2.repeatCount = .infinity
        animation2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)

        self.pauseAnimation()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //--------------------------------------------------------------------------
    // マウスクリック
    //--------------------------------------------------------------------------
    override func mouseDown(with event: NSEvent) {
        if (animatedStatus == true){
            self.pauseAnimation()
        }else{
            self.resumeAnimation()
        }
    }
    //--------------------------------------------------------------------------
    // ビューの再表示
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: NSRect) {
        circleLayer1.add(animation1, forKey: "animation1")
        circleLayer2.add(animation2, forKey: "animation2")
    }
    //--------------------------------------------------------------------------
    // アニメーションの一時停止（難解だ）
    //--------------------------------------------------------------------------
    func pauseAnimation(){
        let pausedTime1 = circleLayer1.convertTime(CACurrentMediaTime() , from: nil)
        circleLayer1.speed = 0
        circleLayer1.timeOffset = pausedTime1
    
        let pausedTime2 = circleLayer2.convertTime(CACurrentMediaTime() , from: nil)
        circleLayer2.speed = 0
        circleLayer2.timeOffset = pausedTime2
        
        animatedStatus = false
    }
    //--------------------------------------------------------------------------
    // アニメーションの再開
    //--------------------------------------------------------------------------
    func resumeAnimation(){
        let pausedTime1 = circleLayer1.timeOffset
        circleLayer1.speed = 1.0
        circleLayer1.timeOffset = 0.0;
        circleLayer1.beginTime = 0.0;
        circleLayer1.beginTime = circleLayer1.convertTime(CACurrentMediaTime(), from: nil) - pausedTime1
        
        let pausedTime2 = circleLayer2.timeOffset
        circleLayer2.speed = 1.0
        circleLayer2.timeOffset = 0.0;
        circleLayer2.beginTime = 0.0;
        circleLayer2.beginTime = circleLayer2.convertTime(CACurrentMediaTime(), from: nil) - pausedTime2

        animatedStatus = true
    }
}
