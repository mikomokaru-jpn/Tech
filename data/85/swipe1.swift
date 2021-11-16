//スワイプの取得（右へ）
let swipeRight = UISwipeGestureRecognizer(
                 target: self, 
                 action: #selector(self.respondToSwipeGesture))
swipeRight.direction = UISwipeGestureRecognizerDirection.right
self.addGestureRecognizer(swipeRight)

//アクション
@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            clickNextButton()
        case UISwipeGestureRecognizerDirection.left:
            clickPreButton()
        default:
            break
        }
    }
}