import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var view: UAView!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        view.wantsLayer = true
        view.layer?.borderWidth = 1.0
        view.layer?.backgroundColor = NSColor.white.cgColor
    }
    //--------------------------------------------------------------------------
    // 開く：ファイルからイメージを読み込む
    //--------------------------------------------------------------------------
    @IBAction func selectFile(_ sender: NSButton){
        let openPanel = NSOpenPanel.init()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.message = "イメージファイルを選択する"
        let url = NSURL.fileURL(withPath: NSHomeDirectory() + "/Pictures")
        //最初に位置付けるディレクトリパス
        openPanel.directoryURL = url
        //オープンパネルを開く
        openPanel.beginSheetModal(for: self.window, completionHandler: { (result) in
            if result == .OK{
                //ディレクトリの選択
                let url: URL = openPanel.urls[0]
                if let cgImageSource = CGImageSourceCreateWithURL(url as CFURL, nil){
                    if let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil){
                        self.view.setUp(cgImage:cgImage)
                    }
                }
            }
        })
    }
    //--------------------------------------------------------------------------
    // イメージを出力する
    //--------------------------------------------------------------------------
    @IBAction func createFile(_ sender: NSButton){
        
        guard let data = self.view.createImageData() else{
            return
        }
        let savaPanel = NSSavePanel.init()
        savaPanel.title = "ファイルを保存する"
        savaPanel.nameFieldStringValue = "savefile.png"
        savaPanel.beginSheetModal(for: self.window, completionHandler: {(result) in
            if result == .OK{
                if let url = savaPanel.url{
                    do {
                        try data.write(to:url)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
}

