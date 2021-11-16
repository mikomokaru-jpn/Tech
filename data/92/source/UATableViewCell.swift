import UIKit
class UATableViewCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!    //左側のボタン
    @IBOutlet weak var item: UILabel!       //右側のラベル
    //ラベルの色
    var itemColor: UIColor = UIColor.clear{
        didSet{
            self.item.backgroundColor = itemColor
        }
    }
    //オブジェクトロード時
    override func awakeFromNib() {
        button.addTarget(self, action:  #selector(buttonDown(_:)), for: .touchDown)
        button.addTarget(self, action:  #selector(buttonUp(_:)), for: .touchUpInside)
    }
    //アクション
    @objc private func buttonDown(_ btn: UIButton){
        self.item.backgroundColor = UIColor.red
        
    }
    //アクション
    @objc private func buttonUp(_ btn: UIButton){
        self.becomeFirstResponder()
        self.item.backgroundColor = itemColor
    }
}
