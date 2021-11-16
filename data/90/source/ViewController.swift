
import UIKit
class ViewController: UIViewController, UITextFieldDelegate  {
    @IBOutlet weak var scrollView: UIScrollView!
    private let contentView =  UIView.init(frame: CGRect(x: 0, y: 0, width: 250, height: 1000))
    private let itemHeight: Int = 50
    var keyboadTop: CGFloat = 0
    var selectedTextField: UITextField? = nil
    //ビューロード時
    override func viewDidLoad() {
    super.viewDidLoad()
        contentView.backgroundColor = UIColor.white
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = UIColor.green
        for i in 0 ..< 20{
            //ラベル
            let label = UILabel(frame: CGRect(x: 0, y: i*itemHeight, width: 50, height: itemHeight))
            label.font = UIFont.systemFont(ofSize: 24)
            label.text = String(i+1)
            label.textColor = UIColor.black
            label.textAlignment = .center
            contentView.addSubview(label)
            //テキストフィールド
            let textField = UITextField(frame: CGRect(x: 50, y: i*itemHeight, width: 200, height: itemHeight))
            if i % 2 == 0{
                textField.backgroundColor = UIColor.lightGray
            }else{
                textField.backgroundColor = UIColor.yellow
            }
            textField.text = String(UnicodeScalar(UInt8(i+65)))
            textField.font = UIFont.systemFont(ofSize: 28)
            textField.textAlignment = .center
            textField.delegate = self
            textField.keyboardType = .emailAddress
            contentView.addSubview(textField)
        }
        scrollView.contentSize = contentView.frame.size
        scrollView.contentSize.height += self.view.frame.height //暫定・本当はキーボードの高さにしたい
        //キーボードが開いたときの通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    //UITextFieldDelegate
    //テキストフィールドの編集開始
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField   //編集中のテキストフィールド
    }
    //テキストフィールドの編集終了
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //ファーストレスポンダーの解放 -> キーボードが閉じる
        textField.resignFirstResponder()
        return true
    }
    //keyboardWillShowNotification
    @objc func keyboardWillShow(_ notification : Notification?) -> Void {
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            //キーボードのframeを取得
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                self.keyboadTop = kbFrame.origin.y
                if let textField = selectedTextField{
                    //ビューに対するテキストフィールドの相対位置（yPos）を求める
                    var yPos = textField.frame.origin.y + scrollView.frame.origin.y
                    let offset =  scrollView.contentOffset.y
                    yPos -= offset
                    //テキストフィールドがキーボードに隠れる場合、見えるところまでスクロールする
                    if yPos + textField.frame.height > kbFrame.origin.y{
                        let span = yPos - kbFrame.origin.y + CGFloat(itemHeight)
                        scrollView.setContentOffset(CGPoint(x: 0, y: span + offset), animated: true)
                    }
                }
            }
        }
    }
}

