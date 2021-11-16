//---- AppDelegate.swift ----
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    let sharedData: UASharedData
    let viewCtrl1: UAViewController1
    let viewCtrl2: UAViewController2
    var viewnum :Int = 1
    //イニシャライザ
    override init() {
        sharedData = UASharedData.init()
        viewCtrl1 = UAViewController1.init(sharedData: sharedData)
        viewCtrl2 = UAViewController2.init(sharedData: sharedData)
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        sharedData.text = "むかしむかし、あるところに、" +
                          "おじいさんとおばあさんが住んでいました。\n";
        viewnum = 1
        window.contentView?.addSubview(viewCtrl1.view)
        viewCtrl1.getFocus()
    }
    //ビューの切り替え
    @IBAction func chengeButton(sender:NSButton){
        if viewnum == 1{ //to 2
            viewCtrl1.view.removeFromSuperview()
            window.contentView?.addSubview(viewCtrl2.view)
            viewCtrl2.getFocus()
            viewnum = 2
        }else if viewnum == 2{ //to 1
            viewCtrl2.view.removeFromSuperview()
            window.contentView?.addSubview(viewCtrl1.view)
            viewCtrl1.getFocus()
            viewnum = 1
        }
    }
}