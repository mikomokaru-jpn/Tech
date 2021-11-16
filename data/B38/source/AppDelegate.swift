import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,
                             ComboBoxDelegate{
    @IBOutlet weak var window: NSWindow!
    let itemList = [" 1月 睦月",
                    " 2月 如月",
                    " 3月 弥生",
                    " 4月 卯月",
                    " 5月 皐月",
                    " 6月 水無月",
                    " 7月 文月",
                    " 8月 葉月",
                    " 9月 長月",
                    "10月 神無月",
                    "11月 霜月",
                    "12月 師走"]
    //コンボボックス・オブジェクトの作成
    let comboBox = ComboBox.init(frame: NSMakeRect(10, 10, 110, 22))
    //コンボボックス・オブジェクトの作成：選択値の取得はクロージャ方式
    /*
    let comboBox = ComboBox.init(NSMakeRect(10, 10, 110, 22),
        completionHandler: { (index) in
            print("++++ \(index) selectd ++++ >>>>")
        }
    )
    */
    //アプリケーション開始時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.contentView?.wantsLayer = true
        self.window.contentView?.layer?.backgroundColor = NSColor.lightGray.cgColor
        //選択値リストの設定
        comboBox.itemList = self.itemList
        //デリゲートの設定
        comboBox.delegate = self
        //コンボボックスをビューに追加
        self.window.contentView?.addSubview(comboBox)
    }
    //デリゲートメソッド
    func selectedIndex(_ index: Int){
        print("<<<< \(index) selectd >>>>")
    }
    //選択値の表示
    @IBAction func display(_ sendrt: Any?){
        let alert = NSAlert()
        alert.informativeText = String(format:"index: %ld", comboBox.selectedIndex)
        alert.messageText = itemList[comboBox.selectedIndex]
        alert.runModal()
    }
}
