
import Cocoa

class PanelCtrl: NSWindowController {
    @objc @IBOutlet weak var height: NSTextField!
    @IBOutlet weak var maxValue: NSTextField!
    @IBOutlet weak var unitWidth: NSTextField!
    @IBOutlet weak var nameHeight: NSTextField!
    @IBOutlet weak var scaleWidth: NSTextField!
    @IBOutlet weak var scaleValue: NSTextField!
    @IBOutlet weak var midashi: NSTextField!

    override var windowNibName: NSNib.Name?  {
        return "Panel"
    }
    //イニシャライザ
    init(){
        super.init(window: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //ウィンドウオブジェクトのロード時（一回だけ実行）
    override func windowDidLoad() {
        super.windowDidLoad()
        //定義辞書のデータをテキストフィールド設定する
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        for (key, value) in appDelegate.definition{
            if let textField: NSTextField = self.value(forKey: key) as? NSTextField{
                textField.stringValue = value
            }
        }
    }
    //未定義のキーがあった
    override func value(forUndefinedKey key: String) -> Any?{
        print("\(key)は存在しません")
        return nil
    }
    //閉じるボタン
    @IBAction func closeBotton(_ sender: NSButton){
        //テキストフィールドのデータを定義辞書に上書きする
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        for (key, _) in appDelegate.definition{
            if let textField: NSTextField = self.value(forKey: key) as? NSTextField{
                appDelegate.definition[key]  = textField.stringValue
            }
        }
        //シートを閉じる
        self.window?.sheetParent?.endSheet(self.window!,
                                           returnCode: NSApplication.ModalResponse.OK)
    }

}
