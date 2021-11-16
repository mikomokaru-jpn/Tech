import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,
                   NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var outlineView: NSOutlineView!
    //ルートノード
    var root = Node(url: nil)
    //アプリケーション起動時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.action = #selector(itemClicked) //クリックイベント
        outlineView.intercellSpacing = NSSize(width: 10, height: 0)
        outlineView.indentationPerLevel = 20.0
        //ルートノードの作成
        let arrayOfURL = self.contentsOfDirectoryOfPath("/")
        for url in arrayOfURL{
            let child = Node(url: url)
            root.children.append(child)
        }
        outlineView.reloadData()
    }

    //DataSource
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as? Node{
            return node.children.count
        }else{
            return root.children.count
        }
    }
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        var node:Node
        if let item = item as? Node{
            node = item
        }else{
            node = root
        }
        let child = node.children[index]
        let url = child.url!
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        child.isFile = !isDir.boolValue
        //孫
        let arrayOfURL = self.contentsOfDirectoryOfPath(url.path)
        for chilChildUrl in arrayOfURL{
            let childChild = Node(url: chilChildUrl)
            child.children.append(childChild)
        }
        return node.children[index]
     }
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let node = item as! Node
        return !node.isFile
            
    }
    //Delegate: 要素の表示
    public func outlineView(_ outlineView: NSOutlineView,
                            viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
//        let myCellView = outlineView.makeView(withIdentifier: tableColumn!.identifier,
//                                              owner: self) as! NSTableCellView
        let myCellView = NSTableCellView()
        let node = item as! Node
        let text = node.url!.lastPathComponent
        myCellView.wantsLayer = true
        myCellView.layer?.backgroundColor = NSColor.black.cgColor
        if !node.isFile{
            myCellView.layer?.backgroundColor = NSColor.lightGray.cgColor
        }
        let cellFrame = NSRect(x: 0, y: 0, width: tableColumn!.width, height: 30)
        let myTextField = UATextField(frame: cellFrame)
        myTextField.isEditable = false
        myCellView.addSubview(myTextField)
        var textColor = NSColor.black
        if node.isFile{
            textColor = NSColor.white
        }
        let aStr = NSAttributedString(string: text, attributes: [.font: NSFont.systemFont(ofSize: 16),
                                                                .foregroundColor: textColor])
        myTextField.attributedStringValue = aStr
        return myCellView
    }
    //行の高さ
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat{
        return 30.0
    }
    //編集禁止
    func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool{
        return false
    }
    //選択禁
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool{
        return false
    }
    //要素をクリックした
    @objc private func itemClicked() {
        let item = outlineView.item(atRow: outlineView.clickedRow) as! Node
        let alert = NSAlert()
        alert.messageText = item.url!.path
        alert.runModal()
    }
    //ファイル・ディレクトリ情報の取得
    func contentsOfDirectoryOfPath(_ path:String) -> [URL]{
        let fm = FileManager.default
        let url = URL(fileURLWithPath: path)
        guard let _urlNames = try? fm.contentsOfDirectory(at: url,
                               includingPropertiesForKeys: [],
                               options: [.skipsHiddenFiles]) else{
            return [URL]()
        }
        let urlNames =  _urlNames.sorted(by: {lurl, rurl -> Bool in
            if lurl.lastPathComponent < rurl.lastPathComponent{
                return true
            }
            return false
        })
        return urlNames
    }
}

