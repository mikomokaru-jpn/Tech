import UIKit

class ViewController: UIViewController {
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    
    let imgView = UIImageView()

    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //ビューの属性設定
        view1.backgroundColor = UIColor.red
        view2.backgroundColor = UIColor.lightGray
        view3.backgroundColor = UIColor.blue
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        //イメージビューの属性設定
        imgView.backgroundColor = UIColor.black
        if let image:UIImage = UIImage(named:"sakura.png"){
            imgView.image = image
        }
        self.view.addSubview(imgView)
        //ラベルのの属性設定
        label1.text = "左側"
        label2.text = "中央"
        label3.text = "右側"
        label1.font = UIFont.systemFont(ofSize: 30)
        label2.font = UIFont.systemFont(ofSize: 30)
        label3.font = UIFont.systemFont(ofSize: 30)
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        label1.textColor = UIColor.white
        label3.textColor = UIColor.white
        label1.backgroundColor = UIColor.red
        label2.backgroundColor = UIColor.lightGray
        label3.backgroundColor = UIColor.blue
        self.view.addSubview(label1)
        self.view.addSubview(label2)
        self.view.addSubview(label3)

        //制約の設定の準備
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        view3.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        //制約の設定
        let constraints = [
            //左側のビュー
            view1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view1.widthAnchor.constraint(equalToConstant: 70),
            view1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            view1.heightAnchor.constraint(equalToConstant: 100),
            //中央のビュー
            view2.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            view2.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            view2.bottomAnchor.constraint(equalTo: imgView.topAnchor, constant: -75),
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor),
            //右側のビュー
            view3.widthAnchor.constraint(equalToConstant: 70),
            view3.heightAnchor.constraint(equalToConstant: 50),
            view3.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            view3.leadingAnchor.constraint(equalTo: self.view2.trailingAnchor),
            view3.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            //イメージビュー
            imgView.widthAnchor.constraint(equalToConstant: 160),
            imgView.heightAnchor.constraint(equalToConstant: 120),
            imgView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            //左側のラベル
            label1.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            label1.heightAnchor.constraint(equalToConstant: 50),
            label1.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 75),
            label1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            //中央のラベル
            label2.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            label2.heightAnchor.constraint(equalToConstant: 50),
            label2.topAnchor.constraint(equalTo: label1.topAnchor),
            label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor),
            //右側のラベル
            label3.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            label3.heightAnchor.constraint(equalToConstant: 50),
            label3.topAnchor.constraint(equalTo: label1.topAnchor),
            label3.leadingAnchor.constraint(equalTo: label2.trailingAnchor),
            label3.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        //優先度
        label1.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        label2.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        label3.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
    }
}
