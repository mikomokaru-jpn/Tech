import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    weak var fileNameField: NSTextField!    //アップロードするファイル名
    weak var imageView: NSImageView!        //イメージファイルの場合イメージを表示
    var urlOfUpfateFile: URL?               //アップロードするファイルのURL
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let vew = UAView.init(frame: self.window.contentView!.bounds)
        self.window.contentView!.addSubview(vew)
    }
    //Openパネルからアップロードするファイルを選択する
    @objc func selectFile(_ sender: NSButton){
        let openPanel = NSOpenPanel.init()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.message = "ファイルを選択する"
        let url = NSURL.fileURL(withPath: NSHomeDirectory() + "/Pictures")
        //最初に位置付けるディレクトリパス
        openPanel.directoryURL = url
        //オープンパネルを開く
        openPanel.beginSheetModal(for: self.window, completionHandler: { (result) in
            if result == .OK{
                //ディレクトリの選択
                self.urlOfUpfateFile = openPanel.urls[0]
                self.fileNameField.stringValue = self.urlOfUpfateFile?.lastPathComponent ?? "?"
                if let url = self.urlOfUpfateFile{
                    self.imageView.image = NSImage(contentsOf:url)
                }
            }
        })
    }
    //アップロード処理・multipart/form-data形式
    @objc func upload1(_ sender: NSButton){
        if self.urlOfUpfateFile == nil{
            return
        }
        let url = URL.init(string: "http://192.168.11.3/50_test/upload_multipart.php")!
        //境界文字列
        let boundary = generateRandomString(length: 30)
        //URL Request
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(String(format:"multipart/form-data;  boundary=%@", boundary),
                         forHTTPHeaderField: "Content-Type")
        //http Body
        var body = Data()
        //----------------------------------------------------------------------
        body.append(String(format:"--%@", boundary).data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        //----------------------------------------------------------------------
        //ファイル本体
        body.append(String(format:"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"",
                           fileNameField.stringValue).data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream".data(using: .utf8)!)
        body.append("\r\n\r\n".data(using: .utf8)!)
        do{
            try body.append(Data.init(contentsOf: urlOfUpfateFile!))
        }catch{
            return
        }
        body.append("\r\n".data(using: .utf8)!)
        //----------------------------------------------------------------------
        body.append(String(format:"--%@", boundary).data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        //----------------------------------------------------------------------
        //POSTパラメータ
        body.append("Content-Disposition: form-data; name=\"MAX_FILE_SIZE\"".data(using: .utf8)!)
        body.append("\r\n\r\n".data(using: .utf8)!)

        body.append(String(format:"10000000").data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        //----------------------------------------------------------------------
        body.append(String(format:"--%@\r\n", boundary).data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        //----------------------------------------------------------------------
        request.httpBody = body
        print(String(data:body, encoding: .utf8) ?? "?")
        let resultText = sendRequest(request: request)  //送受信
        let alert = NSAlert()
        alert.messageText = resultText
        alert.informativeText = self.fileNameField.stringValue
        alert.runModal()
    }
    //アップロード処理・BASE64形式
    @objc func upload2(_ sender: NSButton){
        if self.urlOfUpfateFile == nil{
            return
        }
        let url = URL.init(string: "http://192.168.11.3/50_test/upload_mime.php")!
        //URL Request
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var dataList = [String:String]()
        dataList["file_name"] = fileNameField.stringValue
        dataList["MAX_FILE_SIZE"] = "10000000"
        var body: Data
        do{
            dataList["mime_data"] = try Data.init(contentsOf: urlOfUpfateFile!).base64EncodedString()
            body = try JSONSerialization.data(withJSONObject: dataList, options: [.prettyPrinted])
        }catch{
            return
        }
        request.setValue(String(format:"%ld", body.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = body
        let resultText = sendRequest(request: request)
        let alert = NSAlert()
        alert.messageText = resultText
        alert.informativeText = self.fileNameField.stringValue
        alert.runModal()
    }
    
    //HTTP Request/Response
    private func sendRequest(request: URLRequest) -> String{
        //ネットワーク通信オブジェクトの生成（一時セッション）
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession.init(configuration: configuration)
        var resultText = ""
        //同期用セマフォの作成
        let semaphore = DispatchSemaphore(value: 0)
        //データ送受信処理の定義
        let task = session.dataTask(with: request,completionHandler:
            {(data,response,error) in
            if let error = error{ //error=nil is OK
                //エラー発生
                print("HTTP request error occured \(error)")
                semaphore.signal()
                return
            }
            guard let validResponse = response as? HTTPURLResponse,
                  let data = data else {
                //受信データがnil または　responseがキャストできないときはエラー
                print("response not received")
                semaphore.signal()
                return
            }
            if validResponse.statusCode != 200{
                //ステータスコード200(OK)以外はエラーとする
                print("status error \(validResponse.statusCode)")
                semaphore.signal()
                return
            }
            resultText  = String(decoding: data, as: UTF8.self)
            semaphore.signal()//処理の再開
        })
        task.resume() //実行
        semaphore.wait() //送受信が終了するまで待機する
        return resultText
    }
    //ランダム文字列の生成
    private func generateRandomString(length :Int) ->  String{
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJLKMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in chars.randomElement()! })
    }
}
