import Cocoa

class UATextField: NSTextField {
    override func awakeFromNib() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        self.formatter = formatter
    }
}
