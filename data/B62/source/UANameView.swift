import Cocoa
class UANameView: NSView {
    enum PositionTate{
        case top
        case middle
        case bottom
    }
    enum PositionYoko{
        case left
        case center
        case right
    }
    var nameString: NSAttributedString?
    var positionTate: PositionTate = .middle
    var positionYoko: PositionYoko = .center
    var name: String = ""{
        didSet{
            nameString = NSAttributedString.init(string: name)
            /*
            self.wantsLayer = true
            self.layer?.borderColor = NSColor.red.cgColor
            self.layer?.borderWidth = 1.0
            */
        }
    }
    override func draw(_ dirtyRect: NSRect) {
        if let size =  nameString?.size(){
            var point:NSPoint = NSZeroPoint
            
            switch positionTate{
            case .top:
                point.y = self.bounds.height - CGFloat(size.height)
            case .middle:
                point.y = self.bounds.height / 2 - CGFloat(size.height) / 2
            default:
                point.y = 0
            }
            switch positionYoko{
            case .center:
                point.x = self.bounds.width / 2 -  CGFloat(size.width) / 2
            case .right:
                point.x = self.bounds.width - CGFloat(size.width)
            default:
                point.x = 0
            }
            nameString?.draw(at: point)
        }
   }
}
