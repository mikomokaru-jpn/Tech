func windowWillResize(_ sender: NSWindow,
                      to frameSize: NSSize) -> NSSize{
    //最小サイズ                  
    let minVewSize = NSSize.init(width: 740, height: 630)        
    //通知された高さ・メニューバーの高さも含んでいるので注意
    var size = frameSize
    //メニューバーの高さ
    let barHight = (window.contentView?.superview?.frame.height)! -
                   (window.contentView?.frame.height)!
    //幅が狭すぎれば最小値に戻す
    if frameSize.width < minVewSize.width {
        size.width = minVewSize.width
    }
    //高さが低すぎれば最小値に戻す
    if frameSize.height < minVewSize.height + barHight {
        size.height = minVewSize.height + barHight
    }
    return size
}