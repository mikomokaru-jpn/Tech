//---- ComboBox.swift ----
import Cocoa

protocol ComboBoxDelegate: class {
    func selectedIndex(_ index: Int)
}
class ComboBox: NSView, NSWindowDelegate,
                        ComboButtonDelegate,
                        ComboItemDelegate {
    
    var selectedIndex :Int = 0
    var itemList = [String]()
    private var completionHandler:((Int) -> Void)? = nil
    //プルダウンビュー
    private let pullDownView = FlipedView.init(frame: NSZeroRect)
    private var isShowing :Bool = false
    //テキストフィールド
    private let textField = NSTextField.init(frame: NSZeroRect)
    //プルダウンシート
    private let pullDownSheet = NSPanel.init(contentRect: NSMakeRect(0, 0, 0, 0),
                                             styleMask: [],
                                             backing: .buffered,
                                             defer: false)
    //コンボボックスの要素の配列
    private var comboItemList = [ComboItem]()
    //デリゲートへの参照
    weak var delegate: ComboBoxDelegate?  = nil
    //x軸反転
    override var isFlipped:Bool {
        get {return true}
    }
    //イニシャライザ
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    convenience init(_ rect: NSRect,
                     completionHandler:@escaping (Int) -> Void ) {
        self.init(frame: rect)
        self.completionHandler = completionHandler
    }
    override init(frame frameRect: NSRect) {
        //大きさ：テキストフィールド+ボタン
        var myRect = frameRect
        myRect.size = NSMakeSize(frameRect.size.width + frameRect.size.height - 1,
                                 frameRect.size.height)
        super.init(frame: myRect)
        //背景色
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        //テキストフィールドの大きさ
        textField.frame = NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)
        textField.isEditable = false
        textField.isBordered = true
        //テキストフィールドの追加
        self.addSubview(textField)
        //ボタンの大きさと属性
        let buttonRect = NSMakeRect(frameRect.size.width - 1,
                                    0,
                                    frameRect.size.height,
                                    frameRect.size.height)
        let button = ComboButton.init(frame: buttonRect)
        button.frame = buttonRect
        button.delegate = self  //delegate not action
        //ボタンの追加
        self.addSubview(button)
        //プルダウンビューの属性
        pullDownView.wantsLayer = true
        pullDownView.layer?.backgroundColor = NSColor.white.cgColor
        pullDownView.layer?.borderWidth = 1
        pullDownView.layer?.borderColor = NSColor.gray.cgColor
 
        //ウィンドウ以外のスクリーン領域をクリックしたらプルダウンを閉じる
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown],
        handler: { (mouseEvent: NSEvent?) in
            if self.isShowing{
                self.pullDownSheet.close()
                self.isShowing = false
            }
        })
        //ウィンドウのプルダウンビュー以外をクリックしたらプルダウンを閉じる
        NSEvent.addLocalMonitorForEvents(matching:  [.leftMouseDown],
        handler: { (mouseEvent: NSEvent?) in
            if self.isInPullDown(NSEvent.mouseLocation){
                //プルダウンシート上をクリックされたらスルー -> ComboItem の mouseUpが実行される
                return mouseEvent
            }
            if self.isShowing{
                //開いていたら閉じる
                self.pullDownSheet.close()
                self.isShowing = false
                return nil //mouseEventは捨てる
            }else{
                //閉じているたらmouseEventは生かす
                return mouseEvent
            }
        })
    }
    //プルダウンウィンドウの領域か？
    private func isInPullDown(_ point: NSPoint) -> Bool{
        if self.isShowing{
            //プルダウンシートの領域を求める
            guard let frame = self.pullDownView.window?.contentView?.superview?.frame else{
                return false
            }
            //スクリーン上の相対位置
            guard let winRect = self.pullDownView.window?.convertToScreen(frame) else {
                return false
            }
            //プルダウンシート上の点か？（わかりづらい）
            if (winRect.origin.x <= point.x &&
                point.x <= winRect.origin.x + winRect.size.width)
                &&
                (winRect.origin.y <= point.y &&
                 point.y <= winRect.origin.y + winRect.size.height){
                return true
            }
        }
        return false
    }
    //プルダウンウィンドウを開くボタン（デリゲートメソッドの実装）
    func clickPulldownButton(){
        if self.isShowing{
            //シートを閉じる
            self.pullDownSheet.close()
            self.isShowing = false
        }else{
            //プルダウンビューの大きさ
            let pullDownRect = NSMakeRect(0, 0,
                                          self.frame.size.width,
                                          self.frame.size.height * CGFloat(itemList.count))
            pullDownView.frame = pullDownRect
            //プルダウンシートの大きさ
            pullDownSheet.setContentSize(pullDownView.frame.size)
            //コンボボックスの要素の作成
            var ypos: CGFloat = 0
            for i in 0 ..< itemList.count{
                ypos = self.frame.size.height *  CGFloat(i)
                let item = ComboItem.init(frame:
                    NSMakeRect(0, ypos,
                               self.frame.size.width,
                               self.frame.size.height))
                item.index = i
                item.stringValue = itemList[i]
                item.delegate = self
                self.comboItemList.append(item)
                self.pullDownView.addSubview(item)
            }
            //--- シートを開く位置の計算 ----
            //ウィンドウ領域・原点は左上（0,0）
            guard let winFrame = window?.contentView?.frame else{
                return
            }
            //ウィンドウの原点をスクリーン上の相対位置にする・原点は左下
            guard let winPoint = window?.convertToScreen(winFrame).origin else{
                return
            }
            //プルダウンシートの高さ
            guard let sheetHeight = pullDownSheet.contentView?.frame.size.height else{
                return
            }
            //スクリーンの高さ
            guard let screenHeight = NSScreen.main?.visibleFrame.size.height else{
                return
            }
            //テキストフィールドの原点・右上（ウィンドウ上の相対位置）
            let textFieldOrigin = self.convert(textField.frame.origin,
                                               to: window?.contentView)
            //シート表示の開始点（スクリーン上の相対位置）
            let startYpos = winPoint.y
                          + winFrame.size.height
                          - textFieldOrigin.y
                          - textField.frame.size.height
            //シートの表示位置X・ウィンドウのスクリーン上の表示位置は左下が原点
            var sheetYpos :CGFloat = 0
            //下側に表示できるか判定
            if sheetHeight > startYpos{
                //足りない
                let startYposUpper = startYpos + textField.frame.size.height
                let screenUpper = screenHeight - startYposUpper
                if sheetHeight < screenUpper{
                    //上側に表示
                    sheetYpos = startYposUpper
                }
            }else{
                //下側に表示
                sheetYpos = startYpos - sheetHeight
            }
            //シートの表示位置X・ウィンドウのスクリーン上の表示位置は左下が原点
            let sheetXpos = winPoint.x + textFieldOrigin.x
            //プルダウンビューをシートに追加する
            pullDownSheet.contentView?.addSubview(pullDownView)
            //シートの位置を設定する
            pullDownSheet.setFrameOrigin(NSMakePoint(sheetXpos, sheetYpos))
            //シートを表示する
            pullDownSheet.makeKeyAndOrderFront(nil)
            self.isShowing = true
        }
    }
    //コンボボックスの要素を選択した（デリゲートメソッドの実装）
    func clickItem(_ index: Int, _ aString: NSAttributedString?) {
    }
    //コンボボックスの要素を選択した（デリゲートメソッドの実装）
    func selectItem(_ index: Int, _ aString: NSAttributedString?) {
        //選択値をテキストフィールドにセットする
        if let attributedString =  aString{
            self.textField.attributedStringValue = attributedString
        }
        //プロパティ
        self.selectedIndex = index
        //デリゲートアクション
        delegate?.selectedIndex(index)
        
        if let completionHandler = self.completionHandler{
            completionHandler(index)
        }
        //シートを閉じる
        self.pullDownSheet.close()
        self.isShowing = false
    }

    deinit{
    }
}



