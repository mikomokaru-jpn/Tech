//---- UAViewController1.swift ----
import Cocoa
class UAViewController1: NSViewController {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var label: NSTextField!
    @objc weak var sharedData: UASharedData? //共用データ @objc必須
    //イニシャライザ
    init(sharedData: UASharedData) {
        self.sharedData = sharedData
        //ビューのロード
        super.init(nibName: NSNib.Name(rawValue: "UAViewController1"), bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("xxxx")
    }
    //ビューのロード後
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.lightGray.cgColor
        label.textColor = NSColor.black
    }
    func getFocus(){
        self.view.window?.makeFirstResponder(textField)
    }
}
