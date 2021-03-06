//------------------------------------------------------------------------------
// UAShapeItem.m
//------------------------------------------------------------------------------
#import "UAShapeItem.h"

@interface UAShapeItem(){
    float xFrom, xTo, yFrom, yTo;
}
@end

static float const kLineWidth = 5.0;
@implementation UAShapeItem
//指定イニシャライザ
-(id)initWithFrame:(NSRect)rect startPoint:(CGPoint)point{
    if(![super initWithFrame:rect]){
        return nil;
    }
    _origin = point;
    _size = CGSizeMake(0, 0);
    _lineWidth = 1.0;
    _lineColor = [NSColor blackColor].CGColor;
    _unUsed = NO;
    _transformKind = 0;
    _fromPoint = NSZeroPoint;
    _toPoint = NSZeroPoint;
    return self;
}
//ビューの際描画
- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    /*
    float width = CGBitmapContextGetWidth(context);
    float height = CGBitmapContextGetHeight(context);
    NSLog(@"bitmap %.0f %.0f", width, height);
    NSLog(@"frame  %.0f %.0f", dirtyRect.size.width, dirtyRect.size.height);
    */
    CGContextAddRect(context, _shapeRect);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, _lineColor);
    CGContextStrokePath(context);
}
//図形描画中の処理：イメージの表示
-(void)shapeCreating:(CGPoint)point{
    _size.width = point.x - _origin.x; 
    _size.height = point.y - _origin.y;
    _shapeRect = CGRectMake(_origin.x, _origin.y, _size.width, _size.height);
    self.needsDisplay = YES;
}
//図形描画の完了
-(void)shapeCreated:(CGPoint)toPoint{
    [self shapeCreating:toPoint];
    [self selectOn];
}
//図形の移動・拡大・縮小の開始
-(void)startTransform:(CGPoint)fromPoint{
    _fromPoint = fromPoint;
    // 開始点から変形方法を判定する
    if ([self onTheCorner:_fromPoint]){
        //四隅 ->　拡大/縮小
        _transformKind = 1;
    }else if([self onTheHolLine:_fromPoint]){
        //上辺/下辺 ->　垂直方向に拡大/縮小
        _transformKind = 2;
    }else if([self onTheVelLine:_fromPoint]){
        //右辺/左辺 ->　水平方向に拡大/縮小
        _transformKind = 3;
    }else if([self inTheArea:_fromPoint]){
        //矩形内 -> 移動
        _transformKind = 4;
    }
    return;
}
//図形の移動・拡大・縮小中
-(void)updateTransform:(CGPoint)toPoint{
    if (_transformKind == 1){
        [self transformingXY:toPoint];
    }else if (_transformKind == 2){
        [self transformingY:toPoint];
    }else if (_transformKind == 3){
        [self transformingX:toPoint];
    }else if (_transformKind == 4){
        [self moving:toPoint];
    }
}
//図形の移動・拡大・縮小の完了
-(void)performTransform:(CGPoint)toPoint{
    _toPoint = toPoint;
    if (_transformKind == 1){
        //四隅 ->　拡大/縮小
        [self resizeYFrom:_fromPoint To:_toPoint];
        [self resizeXFrom:_fromPoint To:_toPoint];
    }else if (_transformKind == 2){
        //上辺/下辺 ->　垂直方向に拡大/縮小
        [self resizeYFrom:_fromPoint To:_toPoint];
    }else if (_transformKind == 3){
        //右辺/左辺 ->　水平方向に拡大/縮小
        [self resizeXFrom:_fromPoint To:_toPoint];
    }else if (_transformKind == 4){
        //矩形内 -> 移動
        [self moveFrom:_fromPoint To:_toPoint];
    }else{
        NSLog(@"論理エラーだよ　performTransform　transformKLind=%ld",_transformKind);
    }
    return;
}
//図形を選択状態にする
-(void)selectOn{
    _lineWidth = 2;                            //枠線の太さ
    _lineColor = [NSColor redColor].CGColor;   //枠線の色
    self.needsDisplay = YES;
}
//図形を選択状態を解除する
-(void)selectOff{
    _lineWidth = 1;                              //枠線の太さ
    _lineColor = [NSColor blackColor].CGColor; //枠線の色
    self.needsDisplay = YES;
}
//縦・横方向に拡大/縮小中
-(void)transformingXY:(CGPoint)point{
    float width = 0;
    float height = 0;
    CGPoint basePoint = _origin;
    if (![self nearEqualXonSide:_fromPoint.x] && ![self nearEqualYonSide:_fromPoint.y]){
        //起点が原点の対角
        width = _size.width + (point.x - _fromPoint.x);
        height = _size.height + (point.y - _fromPoint.y);
        
    }else if(![self nearEqualXonSide:_fromPoint.x] && [self nearEqualYonSide:_fromPoint.y]){
        //起点は原点の水平方向
        basePoint.y = _origin.y + _size.height;
        width = _size.width + (point.x - _fromPoint.x);
        height = -_size.height + (point.y - _fromPoint.y);
        
    }else if([self nearEqualXonSide:_fromPoint.x] && ![self nearEqualYonSide:_fromPoint.y]){
        //起点は原点の垂直方向
        basePoint.x = _origin.x + _size.width;
        width = -_size.width + (point.x - _fromPoint.x);
        height = _size.height + (point.y - _fromPoint.y);
        
    }else if([self nearEqualXonSide:_fromPoint.x] && [self nearEqualYonSide:_fromPoint.y]){
        //起点が原点
        basePoint.y = _origin.y + _size.height;
        basePoint.x = _origin.x + _size.width;
        width = -_size.width + (point.x - _fromPoint.x);
        height = -_size.height + (point.y - _fromPoint.y);
    }
    _shapeRect= CGRectMake(basePoint.x, basePoint.y, width, height); //矩形の位置と大きさ
    self.needsDisplay = YES;
}
//横方向に拡大/縮小中
-(void)transformingX:(CGPoint)point{
    //水平方向に拡大/縮小
    float distance = 0.0;
    distance = point.x - _fromPoint.x;
    if ([self nearEqualXonSide:_fromPoint.x]){
        //自分側
        float x = _origin.x + distance;
        float width = _size.width - distance;
        _shapeRect = CGRectMake(x, _origin.y, width, _size.height); //矩形の位置と大きさ
    }else{
        //対辺側
        float width = _size.width + distance;
        _shapeRect = CGRectMake(_origin.x, _origin.y, width, _size.height); //矩形の位置と大きさ
    }
    self.needsDisplay = YES;
}
//縦方向に拡大/縮小中
-(void)transformingY:(CGPoint)point{
    //垂直方向に拡大/縮小
    float distance = 0.0;
    distance = point.y - _fromPoint.y;
    if ([self nearEqualYonSide:_fromPoint.y]){
        //自分側
        float y = _origin.y + distance;
        float height = _size.height - distance;
        _shapeRect = CGRectMake(_origin.x, y, _size.width, height); //矩形の位置と大きさ
    }else{
        //対辺側
        float height = _size.height + distance;
        _shapeRect = CGRectMake(_origin.x, _origin.y, _size.width, height); //矩形の位置と大きさ
    }
    self.needsDisplay = YES;
}
//移動中
-(void)moving:(CGPoint)point{
    //原点までの距離
    CGSize distance = CGSizeMake(_fromPoint.x-_origin.x, _fromPoint.y-_origin.y);
    CGPoint nextPoint = CGPointMake(point.x-distance.width, point.y-distance.height);
    _shapeRect = CGRectMake(nextPoint.x, nextPoint.y, _size.width, _size.height); //矩形の位置と大きさ
    self.needsDisplay = YES;
}
//図形のサイズ変更 横方向
-(void)resizeXFrom:(CGPoint)fromPoint To:(CGPoint)toPoint{
    float distance = 0.0;
    distance = toPoint.x - fromPoint.x;
    if ([self nearEqualXonSide:fromPoint.x]){
        //自分側
        _origin.x += distance;
        _size.width -= distance;
    }else{
        //対辺側
        _size.width += distance;
    }
    _shapeRect = CGRectMake(_origin.x, _origin.y, _size.width, _size.height); //矩形の位置と大きさ
    self.needsDisplay = YES;
}
//図形のサイズ変更 縦方向
-(void)resizeYFrom:(CGPoint)fromPoint To:(CGPoint)toPoint{
    float distance = 0.0;
    distance = toPoint.y - fromPoint.y;
    if ([self nearEqualYonSide:fromPoint.y]){
        //自分側
        _origin.y += distance;
        _size.height -= distance;
    }else{
        //対辺側
        _size.height += distance;
    }
    _shapeRect = CGRectMake(_origin.x, _origin.y, _size.width, _size.height); //矩形の位置と大きさ
    self.needsDisplay = YES;
}
//図形の移動
-(void)moveFrom:(CGPoint)fromPoint To:(CGPoint)toPoint{
    _origin.x += toPoint.x - fromPoint.x;
    _origin.y += toPoint.y - fromPoint.y;
    _shapeRect = CGRectMake(_origin.x, _origin.y, _size.width, _size.height); //矩形の位置と大きさ
    self.needsDisplay = YES;
}
// ---- 点の近似 -----
//点同士は近いか？
-(BOOL)nearToPoint:(CGPoint)point{
    if (fabs(_origin.x - point.x) <= kLineWidth &&
        fabs(_origin.y - point.y) <= kLineWidth ){
        return YES;
    }
    return NO;
}
//点は矩形の中か？
-(BOOL)inTheArea:(CGPoint)point{
    [self defineSpan];
    if (point.x >= xFrom - kLineWidth && point.x <= xTo + kLineWidth){
        if (point.y >= yFrom - kLineWidth && point.y <= yTo + kLineWidth){
            return YES;
        }
    }
    return NO;
}
//点は矩形の水平線上か？
-(BOOL)onTheHolLine:(CGPoint)point{
    [self defineSpan];
    if ([self nearEqualYbothSides:point.y]){
        if (point.x >= xFrom && point.x <= xTo){
            return YES;
        }
    }
    return NO;
}
//点は矩形の垂直線上か？
-(BOOL)onTheVelLine:(CGPoint)point{
    [self defineSpan];
    if ([self nearEqualXbothSides:point.x]){
        if (point.y >= yFrom && point.y <= yTo){
            return YES;
        }
    }
    return NO;
}
//点は矩形の線上か？
-(BOOL)onTheLine:(CGPoint)point{
    return ([self onTheVelLine:point] || [self onTheHolLine:point]);
}
//点は矩形の角の上か？
-(BOOL)onTheCorner:(CGPoint)point{
    [self defineSpan];
    if ([self nearEqualXbothSides:point.x] && [self nearEqualYbothSides:point.y]){
        return YES;
    }
    return NO;
}
//X値とほぼ等値か？（自分側と対辺側）
-(BOOL)nearEqualXbothSides:(float)x{
    return ([self nearEqualXonSide:x] || [self nearEqualXoffSide:x]);
}
//Y値とほぼ等値か？（自分側と対辺側）
-(BOOL)nearEqualYbothSides:(float)y{
    return ([self nearEqualYonSide:y] || [self nearEqualYoffSide:y]);
}
//X値とほぼ等値か？（自分側）
-(BOOL)nearEqualXonSide:(float)x{
    if (x <= _origin.x+kLineWidth && x >= _origin.x-kLineWidth){
        return YES;
    }
    return NO;
}
//X値とほぼ等値か？（対辺側）
-(BOOL)nearEqualXoffSide:(float)x{
    if (x <= _origin.x+_size.width+kLineWidth && x >= _origin.x+_size.width-kLineWidth){
        return YES;
    }
    return NO;
}
//Y値とほぼ等値か？（自分側）
-(BOOL)nearEqualYonSide:(float)y{
    if (y <= _origin.y+kLineWidth && y >= _origin.y-kLineWidth){
        return YES; //自分側
    }
    return NO;
}
//Y値とほぼ等値か？（対辺側）
-(BOOL)nearEqualYoffSide:(float)y{
    if (y <= _origin.y+_size.height+kLineWidth && y >= _origin.y+_size.height-kLineWidth){
        return YES; //対辺側
    }
    return NO;
}
//線分の範囲を定める
-(void)defineSpan{
    //X軸上の範囲を求める
    if (_size.width > 0){
        //起点より左側
        xFrom = _origin.x;
        xTo = _origin.x + _size.width;
    }else{
        //起点より右側
        xFrom = _origin.x + _size.width;
        xTo = _origin.x;
    }
    //Y軸上の範囲を求める
    if (_size.height > 0){
        //起点より上側
        yFrom = _origin.y;
        yTo = _origin.y + _size.height;
    }else{
        //起点より下側
        yFrom = _origin.y + _size.height;
        yTo = _origin.y;
    }
}
@end
