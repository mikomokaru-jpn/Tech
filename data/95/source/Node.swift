import Foundation
class Node: NSObject {
    var url: URL?
    var isFile: Bool = false
    var children = [Node]()
    //イニシャライザ
    init(url: URL?) {
        self.url = url
    }
}
