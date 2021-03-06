import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var manager: UATableManager?
    
    //アプリケーション開始時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        manager = UATableManager(point: NSPoint(x: 20, y: 20), view: window.contentView!)
        //pointは、テーブルビューを貼り付ける起点
        if let mgr = manager{
            mgr.dataList = self.getData()   //データの設定
            mgr.firstDisplay()              //表示           
        }
    }
    //DBレコードの取得
    private func getData() -> [[String:Any]]{
        var dataList = [[String:Any]]()
        
        // DBからデータを取得することを想定
        // [["id": 500, "date": 20181001, "upper": 123, "lower": 95, "pulse": 28], ... ] 
        
        /*
        let cmd = "http://192.168.11.3/doc_health_calendar/php/sql_r12.php"
        //let cmd = "http://localhost/doc_health_calendar/php/sql_r12.php"
        let fromDate = "20180910"
        let toDate = "20181231"
        let param = "id=500&from_date=\(fromDate)&to_date=\(toDate)"
        let list = UAServerRequest.postSync(urlString:cmd, param:param)
        //受信データのキャスト  Any -> [[String:Any]]
        if let unwrappedList  = list as? [[String:Any]] {
            dataList = unwrappedList
        }
        */
        return dataList
    }
}