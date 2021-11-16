

import UIKit

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {


    let tblView: UITableView = UITableView(frame: CGRect(x: 0, y: 100, width: 300, height: 500))
    var goBarButtonItem: UIBarButtonItem!
    let dataList = ["あああああ", "いいいいい", "ううううう", "えええええ", "おおおおお",
                    "かかかかか", "ききききき", "くくくくく", "けけけけけ", "こここここ",
                    "さささささ", "ししししし", "すすすすす", "せせせせせ", "そそそそそ"]
    //ビューロード時
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.backgroundColor = UIColor.black
        self.view.addSubview(tblView)
        //制約の設定
        tblView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tblView.heightAnchor.constraint(equalToConstant: 500),
            tblView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            tblView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tblView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        //テーブルビューセルの登録
        tblView.register(UATableViewCell2.self, forCellReuseIdentifier: "myCell")
        tblView.reloadData()
    }
    //UIDableView DataSource/Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? UATableViewCell2 {
            cell.item.text = dataList[indexPath.row]
            if indexPath.row % 2 == 0{
                cell.itemColor = UIColor.yellow
            }else{
                cell.itemColor = UIColor.lightGray
            }
            return cell
        }
        return UITableViewCell()
    }
}
