import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let view = LotateView.init(frame: NSRect.init(x: 20, y: 70, width: 400, height: 400))
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(view)
    }
    //ボタンアクション
    @IBAction func rotate(_ sender :NSButton){
       view.lotate()
    }
    @IBAction func right(_ sender :NSButton){
        view.right()
    }
    @IBAction func up(_ sender :NSButton){
        view.up()
    }
    @IBAction func left(_ sender :NSButton){
        view.left()
    }
    @IBAction func down(_ sender :NSButton){
        view.down()
    }
    @IBAction func heigher(_ sender :NSButton){
        view.heigher()
    }
    @IBAction func lower(_ sender :NSButton){
        view.lower()
    }
    @IBAction func widen(_ sender :NSButton){
        view.widen()
    }
    @IBAction func narrow(_ sender :NSButton){
        view.narrow()
    }
}

