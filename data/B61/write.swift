//設定データをテキストフィールドから取り出す
for (key, _) in dict{
    //keyと同じ変数名のNSTextFieldオブジェクトを取得する
    if let textField = self.value(forKey: key) as? NSTextField{
        dict[key]  = textField.stringValue
    }
}
//plistの書き出し
let url = URL.init(fileURLWithPath:NSHomeDirectory() + 
                   "/Documents/99_test.plist")
let plist = NSDictionary.init(dictionary: dict)
plist.write(to: url, atomically: true)