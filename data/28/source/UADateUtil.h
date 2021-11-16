//------------------------------------------------------------------------------
//  UADateUtil.h
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
@interface UADateUtil : NSObject
//日付操作ユーティリティオブジェクト(シングルトン)を返す。
+(UADateUtil *)dateManager;
//指定の日付から日数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addDays:(NSInteger)days;
//指定の日付から月数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addMonths:(NSInteger)months;
//指定の日付から年数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addYears:(NSInteger)years;
//指定の日付の月の初日を返す：
-(NSDate*)firstDate:(NSDate*)date;
//指定の日付の月の末日を返す：
-(NSDate*)lastDate:(NSDate*)date;
//指定した日付の月の日数
-(NSInteger)daysOfMonth:(NSDate*)date;
//指定した日付の年
-(NSInteger)integeryear:(NSDate*)date;
//指定した日付の月
-(NSInteger)integerMonth:(NSDate*)date;
//指定した日付の日
-(NSInteger)integerDay:(NSDate*)date;
//指定した日付の曜日（コード）
-(NSInteger)integerWeekday:(NSDate*)date;
//指定した日付の曜日（文字列）
-(NSString*)stringWeekday:(NSDate*)date;
//日付の比較
-(BOOL)isEqualDate:(NSDate*)date1 to:(NSDate*)date2;
//西暦年月->和暦年月の変換（元号・半角スペース・和暦："平成 30"）
-(NSArray*)yearOfWareki:(NSDate*)date;
@end

