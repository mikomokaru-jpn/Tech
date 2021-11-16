//設定データを格納する辞書
var dict = [String:String]()

//plistの読み込み
let url = URL.init(fileURLWithPath:NSHomeDirectory() + 
                   "/Documents/99_test.plist")
guard let plist = NSDictionary.init(contentsOf: url) else{
    return
}
if let tmp =  plist as? [String:String]{
    dict = tmp
    for (key, value) in dict{
        //keyと同じ変数名のNSTextFieldオブジェクトを取得する
        if let textField = self.value(forKey: key) as? NSTextField{
            //値の設定
            textField.stringValue = value
        }
    }
}
