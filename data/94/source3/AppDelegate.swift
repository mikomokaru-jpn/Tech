

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSBrowserDelegate{
    //プロパティ
    @IBOutlet weak var window: NSWindow!
    var mybrowser = NSBrowser()
    //アプリケーション開始時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.contentView?.addSubview(mybrowser)
        self.setLayout()
        mybrowser.delegate = self
        mybrowser.columnResizingType = .userColumnResizing
        mybrowser.isTitled = false
        mybrowser.minColumnWidth = 100
        mybrowser.setDefaultColumnWidth(150)
        mybrowser.rowHeight = 25
    }
    //NSBrowserDelegate
    func rootItem(for browser: NSBrowser) -> Any?{
        let root = Node(url: nil)
        let arrayOfURL = self.contentsOfDirectoryOfPath("/")
        for url in arrayOfURL{
            let node = Node(url: url)
            root.children.append(node)
        }
        return root
    }
    func browser(_ browser: NSBrowser, numberOfChildrenOfItem item: Any?) -> Int{
        let node = item as! Node
        return node.children.count
    }
    func browser(_ browser: NSBrowser, child index: Int, ofItem item: Any?) -> Any{
        let node = item as! Node
        let child = node.children[index]
        child.children.removeAll()
        if let url = child.url{
            let arrayOfURL = self.contentsOfDirectoryOfPath(url.path)
            for url in arrayOfURL{
                let node = Node(url: url)
                child.children.append(node)
            }
        }
        return child
    }
    func browser(_ browser: NSBrowser, objectValueForItem item: Any?) -> Any?{
        let node =  item as! Node
        let text = node.url?.lastPathComponent ?? "noname"
        return text
        /*
        let node =  item as! Node
        let url = node.url!
        let text = url.lastPathComponent
        let aStr = NSMutableAttributedString(string: text)
        let attachment = NSTextAttachment()
        //アイコンの取得
        let iconImage = NSWorkspace.shared.icon(forFile: url.path)
        iconImage.size = NSMakeSize(16, 16)
        attachment.image = iconImage
        attachment.bounds = NSRect(origin: NSPoint(x: 0, y: -4), size: iconImage.size)
        let imageAtr = NSAttributedString(attachment: attachment)
        aStr.insert(imageAtr, at: 0)
        return aStr
        */
    }
    func browser(_ browser: NSBrowser, isLeafItem item: Any?) -> Bool{
        let node = item as! Node
        if let url = node.url{
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
            if isDir.boolValue{
                //ディレクトリ
                return false
            }else{
                //ファイル
                return true
            }
        }
        return false
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
        mybrowser.translatesAutoresizingMaskIntoConstraints = false
        let view = self.window.contentView!
        let constraints = [
            mybrowser.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mybrowser.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            mybrowser.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mybrowser.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

