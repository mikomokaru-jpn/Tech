//------------------------------------------------------------------------------
//  UADateUtil.m
//------------------------------------------------------------------------------
#import "UADateUtil.h"
@interface UADateUtil(){
    unsigned unitDay;
    unsigned unitTime;
}
//日付ライブラリのオブジェクト
@property NSCalendar *calendar;
@property NSDateFormatter* warekiFormat;
@property NSDateFormatter* yobiFormat;
@end

//------------------------------------------------------------------------------
// 日付操作ユーティリティ
//------------------------------------------------------------------------------
@implementation UADateUtil
static UADateUtil *sharedData = nil;  //自身のオブジェクト(シングルトン)
//------------------------------------------------------------------------------
//日付操作ユーティリティオブジェクト(シングルトン)を返す。
//------------------------------------------------------------------------------
+(UADateUtil *)dateManager{ //singleton{
    if (!sharedData) {
        sharedData = [[UADateUtil alloc] init];
    }
    return sharedData;
}
//------------------------------------------------------------------------------
//イニシャライザ
//------------------------------------------------------------------------------
-(id)init{
    self = [super init];
    if (self == nil){
        return self;
    }
    // NSCalendarオブジェクト
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // NSDateComponentsフラグ(年、月、日、曜日)
    unitDay = NSCalendarUnitYear|
              NSCalendarUnitMonth|
              NSCalendarUnitDay|
              NSCalendarUnitWeekday;
    // NSDateComponentsフラグ(時、分、秒)
    unitTime = NSCalendarUnitHour|
               NSCalendarUnitMinute|
               NSCalendarUnitSecond;
    // --- 和暦変換 ---
    // 時刻書式指定子を設定
    _warekiFormat = [[NSDateFormatter alloc] init];
    [_warekiFormat setDateStyle:NSDateFormatterFullStyle];
    [_warekiFormat setTimeStyle:NSDateFormatterNoStyle];
    // ロケールを設定
    NSLocale* loc = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [_warekiFormat setLocale:loc];
    // カレンダーを指定
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierJapanese];
    [_warekiFormat setCalendar: cal];
    // 和暦を出力するように書式指定
    [_warekiFormat setDateFormat:@"GG yy"];
    //曜日フォーマット
    _yobiFormat = [[NSDateFormatter alloc] init];
    _yobiFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja"];
    return self;
}

//指定の日付から日数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addDays:(NSInteger)days{
    NSDateComponents *diff = [[NSDateComponents alloc] init];
    diff.day = days;
    return [_calendar dateByAddingComponents:diff toDate:date options:0];
}
//指定の日付から月数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addMonths:(NSInteger)months{
    NSDateComponents *diff = [[NSDateComponents alloc] init];
    diff.month = months;
    return [_calendar dateByAddingComponents:diff toDate:date options:0];
}

//指定の日付から年数を加算した日付を返す
-(NSDate*)date:(NSDate*)date addYears:(NSInteger)years{
    NSDateComponents *diff = [[NSDateComponents alloc] init];
    diff.year = years;
    return [_calendar dateByAddingComponents:diff toDate:date options:0];
}

//指定の日の月の初日を返す：
-(NSDate*)firstDate:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    dateComp.day = 1;
    return [_calendar dateFromComponents:dateComp];
}
//指定の日の月の末日を返す：
-(NSDate*)lastDate:(NSDate*)date{
    NSInteger lastDay =[_calendar rangeOfUnit:NSCalendarUnitDay
                                       inUnit:NSCalendarUnitMonth
                                      forDate:date].length;
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    dateComp.day = lastDay;
    return [_calendar dateFromComponents:dateComp];
}
//指定した日の月の日数
-(NSInteger)daysOfMonth:(NSDate*)date
{
    NSDateComponents* comp = [_calendar components:unitDay fromDate:date];
    NSInteger days =[_calendar rangeOfUnit:NSCalendarUnitDay
                                    inUnit:NSCalendarUnitMonth
                                   forDate:[_calendar dateFromComponents:comp]].length;
    return days;
}
//指定した日付の年
-(NSInteger)integeryear:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return dateComp.year;
}
//指定した日付の月
-(NSInteger)integerMonth:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return dateComp.month;
}
//指定した日付の日
-(NSInteger)integerDay:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return dateComp.day;
}
//指定した日付の曜日（コード）
-(NSInteger)integerWeekday:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return dateComp.weekday;
}
//指定した日付の曜日（文字列）
-(NSString*)stringWeekday:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return _yobiFormat.shortWeekdaySymbols[dateComp.weekday-1];
}
//指定した日付の整数表現（yyyymmdd）
-(NSInteger)integerDate:(NSDate*)date{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date];
    return (dateComp.year*10000 + dateComp.month*100 + dateComp.day);
}
//日付の比較
-(BOOL)isEqualDate:(NSDate*)date1 to:(NSDate*)date2{
    NSDateComponents *dateComp = [_calendar components:unitDay fromDate:date1];
    NSInteger integerdate1 = dateComp.year*10000 + dateComp.month*100 + dateComp.day;
    dateComp = [_calendar components:unitDay fromDate:date2];
    NSInteger integerdate2 = dateComp.year*10000 + dateComp.month*100 + dateComp.day;
    return (integerdate1 == integerdate2);
}
//西暦年月->和暦年月の変換（元号・半角スペース・和暦："平成 30"）
-(NSArray*)yearOfWareki:(NSDate*)date{
    NSArray* values = [[_warekiFormat stringFromDate:date]
                       componentsSeparatedByString:@" "];
    return values;
}
@end

