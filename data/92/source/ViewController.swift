import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tblView: UITableView!
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
        goBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self,
                                          action: #selector(goBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [goBarButtonItem]
    }
    //第二画面に移動する
    @objc func goBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSecond", sender: index)
    }
    //UIDableView DataSource/Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? UATableViewCell {
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
