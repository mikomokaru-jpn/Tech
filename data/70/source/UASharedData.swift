//---- UASharedData.swift ----
import Cocoa
class UASharedData: NSObject {
    @objc dynamic var text: String //@objc dynamic必須
    //イニシャライザ
    override init() {
        text = ""
        super.init()
    }
}