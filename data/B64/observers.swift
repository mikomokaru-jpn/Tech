// UACalView2 class
private var observers = [NSKeyValueObservation]()
override init(frame frameRect: NSRect) {    
    ....
    //windowオブジェクトを取得したタイミング（contentViewにaddされたとき）
    observers.append(self.observe(\.window?, options: [.old, .new])
    {_, change in
        for dayView in self.dayViewArray{
            if dayView.isToday{
                dayView.selected = true
                self.window?.makeFirstResponder(dayView)
            }
        }
    })
    ....
}