import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var fieldA: NSTextField!
    @IBOutlet weak var fieldB: NSTextField!
    @IBOutlet weak var fieldC: NSTextField!
    
    //設定データ
    //key : "fieldA", "fieldB", "fieldC"
    var dict = [String:String]()

    //初期処理
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //plistの読み込み
        let url = URL.init(fileURLWithPath:NSHomeDirectory() + "/Documents/99_test.plist")
        guard let plist =  NSDictionary.init(contentsOf: url) else{
            return
        }
        if let tmp =  plist as? [String:String]{
            dict = tmp
            for (key, value) in dict{
                //keyと同じ変数名のNSTextFieldオブジェクトを取得する
                if let textField: NSTextField = self.value(forKey: key) as? NSTextField{
                    textField.stringValue = value
                }
            }
        }
    }
    //終了処理
    func applicationWillTerminate(_ aNotification: Notification) {
        for (key, _) in dict{
            //keyと同じ変数名のNSTextFieldオブジェクトを取得する
            if let textField: NSTextField = self.value(forKey: key) as? NSTextField{
                dict[key]  = textField.stringValue
            }
        }
        //plistの書き出し
        let url = URL.init(fileURLWithPath:NSHomeDirectory() + "/Documents/99_test.plist")
        let plist: NSDictionary = NSDictionary.init(dictionary: dict)
        plist.write(to: url, atomically: true)
    }
    //キーが存在しないとき実行されるメソッド
    override func value(forUndefinedKey key: String) -> Any?{
        print("\(key) は存在しません")
        return nil
    }
}

