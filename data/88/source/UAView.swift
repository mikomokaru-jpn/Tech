import Cocoa
class UAView: NSView {
    //var image:CGImage?
    var newImage: CGImage?
    var bitmapContext: CGContext?

    //--------------------------------------------------------------------------
    //ビューの再表示
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: NSRect) {
        //グラフィックコンテキストの取得
        if let context = NSGraphicsContext.current?.cgContext{
            //グラフィックコンテキストにイメージを表示する。
            if let image = self.newImage{
                
                context.draw(image, in: self.displaySize(image: image))
            }
        }
    }
    //--------------------------------------------------------------------------
    // CGImageオブジェクトのグレースケール変換
    //--------------------------------------------------------------------------
    func setUp(cgImage: CGImage){
        let dataSize = cgImage.width * cgImage.height * 4 //ピクセル数x4バイト(RGBA)
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //変換用コンテキストの生成・入力イメージと同じ大きさ
        bitmapContext = CGContext(data: &pixelData,
                                 width: Int(cgImage.width),
                                 height: Int(cgImage.height),
                                 bitsPerComponent: 8,
                                 bytesPerRow: 4 * Int(cgImage.width),
                                 space: colorSpace,
                                 bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        //作業用コンテキストにイメージオブジェクトを描画する
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        bitmapContext?.draw(cgImage, in: rect)
        //bindMemoryによりコンテキストのデータをポインタ経由で参照する
        let count = Int(cgImage.width) * Int(cgImage.height)
        if let buffer = bitmapContext?.data?.bindMemory(to: UInt8.self, capacity: count){
            //グレースケール変換
            for i in stride(from:0, to: dataSize-1, by:4){
                //グレースケール変換 HDTV係数
                
                let grayInt = UInt8(0.2126 * CGFloat(buffer[i]) +
                                    0.7152 * CGFloat(buffer[i+1])  +
                                    0.0722 * CGFloat(buffer[i+2]))
                //グレースケール変換 NTSC係数
                /*
                let grayInt = UInt8(0.2989 * CGFloat(buffer[i]) +
                                    0.5866 * CGFloat(buffer[i+1])  +
                                    0.1145 * CGFloat(buffer[i+2]))
                */
                buffer[i] = grayInt
                buffer[i+1] = grayInt
                buffer[i+2] = grayInt
                //ネガポジ変換
                /*
                buffer[i] = 255 - buffer[i]
                buffer[i+1] = 255 - buffer[i+1]
                buffer[i+2] = 255 - buffer[i+2]
                */
            }
        }
        self.newImage = bitmapContext?.makeImage()
        self.needsDisplay = true
    }
    //--------------------------------------------------------------------------
    // イメージをpng形式のDataオブジェクトに変換する
    //--------------------------------------------------------------------------
    func createImageData() -> Data?{
        //ビットマップコンテキストからCGImageオブジェクトを取得する NG
        //NG EXC_BAD_ACCESS 何故かビットマップコンテキストにアクセスできない
        /*
        guard let cgImage = self.bitmapContext?.makeImage() else {
            return nil
        }
        */

        if let image = newImage{
            let bitmap = NSBitmapImageRep.init(cgImage: image)
            let exporttData: Data? = bitmap.representation(using: .png,
                                               properties: [:])
            return exporttData
        }else{
            return nil
        }
    }
    //--------------------------------------------------------------------------
    // イメージの表示サイズ
    //--------------------------------------------------------------------------
    func displaySize(image: CGImage) -> CGRect{
        let maxSize = CGSize.init(width: self.frame.width, height: self.frame.height)
        var origin = CGPoint.init(x: 0, y: 0)
        
        var newSize = CGSize.init(width: 0, height: 0)
        if ( CGFloat(image.height) / CGFloat(image.width) < maxSize.height / maxSize.height) {
            //横長・上下に余白
            newSize.width = maxSize.width
            newSize.height = floor(maxSize.width * CGFloat(image.height) / CGFloat(image.width))
            origin.y = floor((maxSize.height - newSize.height) / 2) //余白
        }else{
            //縦長。左右に余白
            newSize.width = floor(maxSize.height * CGFloat(image.width) / CGFloat(image.height))
            newSize.height = maxSize.height
            origin.x = floor((maxSize.width - newSize.width) / 2) //余白
        }
        return  CGRect.init(x: origin.x, y: origin.y,
                        width: newSize.width, height: newSize.height)
    }
    //--------------------------------------------------------------------------
    // NG: pixelDataへの色の更新が反映されない。参照のみできる。
    //--------------------------------------------------------------------------
    func newImage2(cgImage: CGImage) -> CGImage {
        let dataSize = cgImage.width * cgImage.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(cgImage.width),
                                height: Int(cgImage.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(cgImage.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        for i in stride(from:0, to: pixelData.count - 1, by:4){
            //グレースケール変換 HDTV係数
            let grayInt = UInt8(0.2126 * CGFloat(pixelData[i]) +
                                0.7152 * CGFloat(pixelData[i+1])  +
                                0.0722 * CGFloat(pixelData[i+2]))
            pixelData[i] = grayInt
            pixelData[i+1] = grayInt
            pixelData[i+2] = grayInt
        }
        return cgImage
    }
}


