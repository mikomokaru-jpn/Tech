import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSBrowserDelegate{
    //プロパティ
    @IBOutlet weak var window: NSWindow!
    var myBrowser = NSBrowser()
    var arrayOfURL = [URL]()
    //アプリケーション開始時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.contentView?.addSubview(myBrowser)
        self.setLayout()
        myBrowser.delegate = self
        myBrowser.columnResizingType = .userColumnResizing
        myBrowser.isTitled = false
        myBrowser.minColumnWidth = 100
        myBrowser.setDefaultColumnWidth(150)
        myBrowser.setCellClass(UABrowserCell.self) //セルクラスを変更する
    }
    //NSBrowserDelegate
    func browser(_ sender: NSBrowser, numberOfRowsInColumn column: Int) -> Int{
        var path = ""
        if column > 0{
            path = sender.path(toColumn: column)
        }else{
            path = "/"
        }
        arrayOfURL = self.contentsOfDirectoryOfPath(path)
        return arrayOfURL.count
    }
    func browser(_ sender: NSBrowser, willDisplayCell cell: Any, atRow row: Int, column: Int){
        let myCell = cell as! UABrowserCell
        let url = arrayOfURL[row]
        //ファイル・ディレクトリ名の設定
        myCell.stringValue = url.lastPathComponent
        //アイコンの取得
        let iconImage = NSWorkspace.shared.icon(forFile: url.path)
        iconImage.size = NSMakeSize(16, 16)
        myCell.icon = iconImage
        //種別の判定
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        if isDir.boolValue{
            //ディレクトリ
            myCell.isLeaf = false
        }else{
            //ファイル
            myCell.isLeaf = true
        }
    }
    //ファイル・ディレクトリ情報の取得
    func contentsOfDirectoryOfPath(_ path:String) -> [URL]{
        let fm = FileManager.default
        
        let url = URL(fileURLWithPath: path)
        guard let urlNames = try? fm.contentsOfDirectory(at: url,
                               includingPropertiesForKeys: [],
                               options: [.skipsHiddenFiles]) else{
            return [URL]()
        }
        return urlNames
    }
    //レイアウト設定
    func setLayout(){
        myBrowser.translatesAutoresizingMaskIntoConstraints = false
        let view = self.window.contentView!
        let constraints = [
            myBrowser.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            myBrowser.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            myBrowser.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            myBrowser.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

