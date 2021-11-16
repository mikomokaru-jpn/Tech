import Cocoa
//------------------------------------------------------------------------------
// UIコントロールを作成し親ビューに貼り付ける
//------------------------------------------------------------------------------
class UAView: NSView {
    //座標の変換
    override var isFlipped: Bool{
        return true
    }
    //コントロールの生成
    let selectButton = NSButton(frame: CGRect(x: 10, y: 15, width: 120, height: 20))
    let fileNameField = NSTextField(frame: CGRect(x: 10, y: 40, width: 210, height: 20))
    let imageView = NSImageView(frame: CGRect(x: 10, y: 70, width: 210, height: 210))
    let uploadButton1 = NSButton(frame: CGRect(x: 10, y: 290, width: 80, height: 20))
    let uploadButton2 = NSButton(frame: CGRect(x: 10, y: 320, width: 80, height: 20))
    let label1 = NSTextField(frame: CGRect(x: 90, y: 290, width: 140, height: 20))
    let label2 = NSTextField(frame: CGRect(x: 90, y: 320, width: 140, height: 20))
    
    //イニシャライザ
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //初期処理
    private func initialize()
    {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        selectButton.target = appDelegate
        selectButton.action = #selector(appDelegate.selectFile(_:))
        selectButton.bezelStyle = .rounded
        selectButton.title = "Select File"
        self.addSubview(selectButton)

        self.addSubview(self.fileNameField)
        appDelegate.fileNameField = self.fileNameField
        
        self.addSubview(self.imageView)
        self.imageView.imageFrameStyle = .photo
        appDelegate.imageView = self.imageView

        label1.stringValue = "multipart/form-data"
        label1.isEditable = false
        label1.isBordered = false
        label1.backgroundColor = NSColor.clear
        self.addSubview(label1)

        label2.stringValue = "BASE64形式"
        label2.isEditable = false
        label2.isBordered = false
        label2.backgroundColor = NSColor.clear
        self.addSubview(label2)

        uploadButton1.target = appDelegate
        uploadButton1.action = #selector(appDelegate.upload1(_:))
        uploadButton1.bezelStyle = .rounded
        uploadButton1.title = "Upload"
        self.addSubview(uploadButton1)
        
        uploadButton2.target = appDelegate
        uploadButton2.action = #selector(appDelegate.upload2(_:))
        uploadButton2.bezelStyle = .rounded
        uploadButton2.title = "Upload"
        self.addSubview(uploadButton2)
    }
}
