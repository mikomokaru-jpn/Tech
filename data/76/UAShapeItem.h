@interface UAShapeItem : NSView
@property CGPoint origin;       //矩形の原点
@property CGSize size;          //矩形のサイズ
@property CGRect shapeRect;     //矩形の位置とサイズ
@property CGFloat lineWidth;    //線の太さ
@property CGColorRef lineColor; //線の色
@property BOOL unUsed;          //削除フラグ
@property NSInteger transformKind;   //変形方法
@property CGPoint fromPoint;    //変形（移動・拡大・縮小）の開始点
@property CGPoint toPoint;      //変形（移動・拡大・縮小）の終了点
//イニシャライザ
-(id)initWithFrame:(NSRect)rect startPoint:(CGPoint)point;
//図形（矩形）の描画中の処理
-(void)shapeCreating:(CGPoint)toPoint;
//図形（矩形）の描画の完了
-(void)shapeCreated:(CGPoint)toPoint;
//図形の移動・拡大・縮小の開始
-(void)startTransform:(CGPoint)fromPoint;
//図形の移動・拡大・縮小中
-(void)updateTransform:(CGPoint)toPoint;
//図形の移動・拡大・縮小の完了
-(void)performTransform:(CGPoint)toPoint;
//図形を選択状態にする
-(void)selectOn;
//図形を選択状態を解除する
-(void)selectOff;
//点が図形の中か否か
-(BOOL)inTheArea:(CGPoint)point;
//点同士は近いか？
-(BOOL)nearToPoint:(CGPoint)point;
@end
