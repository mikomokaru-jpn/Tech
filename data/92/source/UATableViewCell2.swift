
import UIKit
class UATableViewCell2: UITableViewCell {
    var button = UIButton() //左側のボタン
    var item = UILabel()    //右側のラベル
    //ラベルの色
    var itemColor: UIColor = UIColor.clear{
        didSet{
            self.item.backgroundColor = itemColor
        }
    }
    //イニシャライザ
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //ボタンの作成
        button.setImage(UIImage(systemName: "play.rectangle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action:  #selector(buttonDown(_:)), for: .touchDown)
        button.addTarget(self, action:  #selector(buttonUp(_:)), for: .touchUpInside)
        self.addSubview(button)
        //ラベルの作成
        item.font = UIFont.systemFont(ofSize: 30)
        item.textAlignment = .center
        self.addSubview(item)
        //制約の設定の準備
        button.translatesAutoresizingMaskIntoConstraints = false
        item.translatesAutoresizingMaskIntoConstraints = false
        //制約の設定
        let constraints = [
            button.widthAnchor.constraint(equalToConstant: 75),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            item.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            item.topAnchor.constraint(equalTo: self.topAnchor),
            item.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            item.leadingAnchor.constraint(equalTo: button.trailingAnchor),
            item.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
