//2タップの取得
let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapped(_:)))
tapGesture.numberOfTapsRequired = 2
self.addGestureRecognizer(tapGesture)

//アクション
@objc func tapped(_ sender: UITapGestureRecognizer){
    delegate?.dateSelect(index: index)
}