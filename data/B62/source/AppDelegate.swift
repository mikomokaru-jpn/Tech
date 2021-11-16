
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var titleField: NSTextField!

    //コンテントビューの最小サイズ
    let minVewSize = NSSize.init(width: 740, height: 630)
    //グラフビューサイズ
    var graphSize = NSZeroSize
    //スクロールビューサイズ
    var scrollSize = NSZeroSize
    //グラフビューの定義
    var definition: [String:String] = ["height": "400",         //高さ
                                       "maxValue": "20000000",  //最大値
                                       "unitWidth": "14",       //1要素の幅
                                       "nameHeight": "75",      //要素名の高さ
                                       "scaleWidth": "75",      //目盛見出しりの幅
                                       "scaleValue": "1000000", //補助線の単位
                                       "topMargin": "25",       //上余白
                                       "midashi": ""]           //見出し
    //環境設定パネル
    var panelCtrl: PanelCtrl = PanelCtrl.init()

    //---- 初期処理 ----
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //グラフビューの定義を読み込む
        let plistURL: URL = URL.init(fileURLWithPath:
            NSHomeDirectory() + "/Documents/34_graph.plist")
        if let plist =  NSDictionary.init(contentsOf: plistURL){
            for (key, _) in definition{
                if let value = plist[key] as? String{
                    definition[key] = value
                }
            }
        }
        self.makeGraph()
    }
    //---- 環境設定パネルを開く ----
    @IBAction func clickOpen(_ sender: NSButton){
        window?.beginSheet(
            panelCtrl.window!,
            completionHandler:{(response) in
                //コールバック処理
                if response == .OK{
                    self.makeGraph() //グラフの作成
                }
        })
    }
    //---- グラフの作成 ----
    private func makeGraph(){
        //ウィンドウの初期サイズ
        window.setContentSize(minVewSize)
        //データを読み込む（汎用性なし）
        let path = NSHomeDirectory() + "/Desktop/population.txt"
        guard let contents = try? String.init(contentsOfFile: path) else{
            return
        }
        let recordList = contents.components(separatedBy: "\n")
        var data = [Float]()            //データ格納域
        var nameList = [String]()       //項目名格納域
        for record in recordList{
            let items = record.components(separatedBy: ",")
            if let value = Float(items[2].trimmingCharacters(in: CharacterSet.whitespaces)){
                data.append(value)
            }
            nameList.append(items[1].trimmingCharacters(in: CharacterSet.whitespaces))
        }
        //見出し
        self.titleField.stringValue = definition["midashi"]!
        //スクロールビューの作成
        let scrollView = NSScrollView(frame: CGRect(x: 20, y: 50, width: 700, height: 530))
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.borderType = .bezelBorder
        scrollView.autoresizingMask = [.width, .height]
        self.window?.contentView?.addSubview(scrollView)
        //グラフビューの作成
        let graphView = UAGraphView(frame: NSZeroRect)
        window.contentView?.addSubview(graphView)
        graphView.definition = definition
        graphView.nameList = nameList
        graphView.data = data
        graphView.makeGraph()
        graphSize = graphView.bounds.size
        scrollSize = scrollView.contentSize
        scrollView.documentView = graphView
    }
    //---- 終了処理 ----
    func applicationWillTerminate(_ aNotification: Notification) {
        let plistURL: URL = URL.init(fileURLWithPath:
            NSHomeDirectory() + "/Documents/34_graph.plist")
        let plist = NSMutableDictionary.init()
        for (key, value) in definition{
            plist[key] = value
        }
        plist.write(to: plistURL, atomically: true)
    }
    //---- ウィンドウの大き変える ----
    func windowWillResize(_ sender: NSWindow,
                          to frameSize: NSSize) -> NSSize{
        var size = frameSize
        //メニューバーの高さ
        let barHight = (window.contentView?.superview?.frame.height)! -
                       (window.contentView?.frame.height)!

        
        var maxViewSize = NSZeroSize
        if self.graphSize.width > 683{
            maxViewSize.width = self.graphSize.width + 57
        }else{
            maxViewSize.width = 740
        }
        if self.graphSize.height > 513{
            maxViewSize.height = self.graphSize.height + 117
        }else{
            maxViewSize.height = 630
        }
        //変更されたサイズの判定
        if frameSize.width < minVewSize.width {
            //幅が大きすぎれば戻す
            size.width = minVewSize.width
            
        }else if frameSize.width > maxViewSize.width {
            //幅が小さすぎれば戻す
            size.width = maxViewSize.width
        }
        
        if frameSize.height < minVewSize.height + barHight {
            //高さが低すぎれば戻す・通知された高さはメニューバーの高さも含んでいるため補正する
            size.height = minVewSize.height + barHight
            
        }else if frameSize.height > maxViewSize.height {
            //高さが高すぎれば戻す
            size.height = maxViewSize.height + barHight
        }
        return size
    }
}

