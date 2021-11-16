import Foundation
class Node: NSObject {
    var url: URL?
    var children = [Node]()
    init(url: URL?) {
        self.url = url
    }
}
