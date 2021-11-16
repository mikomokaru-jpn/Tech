
import UIKit
class ViewController: UIViewController, UITextFieldDelegate,
                      UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    let itemHeight: Int = 50
    var keyboadTop: CGFloat = 0
    var selectedTextField: UITextField? = nil
    var dataList = [(UILabel, UITextField)]()
    //ビューロード時
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.orange
        tableView.dataSource = self
        tableView.delegate = self
        for i in 0 ..< 20{
            //ラベル
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: itemHeight))
            label.font = UIFont.systemFont(ofSize: 24)
            label.text = String(i+1)
            label.textColor = UIColor.black
            label.textAlignment = .center
            //テキストフィールド
            let textField = UITextField(frame: CGRect(x: 50, y: 0, width: 200, height: itemHeight))
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
            dataList.append((label, textField)) //データソースの作成
        }
        //キーボードが開いたときの通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    //UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(itemHeight)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 250, height: itemHeight))
        
    
        cell.selectionStyle = .default
        let idx = indexPath.row
        cell.contentView.addSubview(dataList[idx].0)
        cell.contentView.addSubview(dataList[idx].1)
        return cell
    }
    //UITextFieldDelegate
    //テキストフィールドの編集開始
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField   //編集中のテキストフィールド
        /*
        let view1 = selectedTextField?.superview
        print(view1?.description ?? "view1?")

        let view2 = selectedTextField?.superview?.superview
        print(view2?.description ?? "view2?")
        */
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
                    if let cell = textField.superview?.superview as? UITableViewCell{
                        //テキストトフィールドを格納するTableViewCellを取得し、ビューに対する相対位置（yPos）を求める
                        var yPos = cell.frame.origin.y + tableView.frame.origin.y
                        let offset =  tableView.contentOffset.y
                        yPos -= offset
                        //テキストフィールドがキーボードに隠れる場合、見えるところまでスクロールする
                        if yPos + textField.frame.height > kbFrame.origin.y{
                            let span = yPos - kbFrame.origin.y + CGFloat(itemHeight)
                            tableView.setContentOffset(CGPoint(x: 0, y: span + offset), animated: true)
                        }
                    }
                }
            }
        }
    }
}
