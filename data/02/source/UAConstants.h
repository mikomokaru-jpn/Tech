//------------------------------------------------------------------------------
//  UAConstants 定数定義
//------------------------------------------------------------------------------
#ifndef UAConstants_h
#define UAConstants_h
// HTTP

//送信先URL
//static const NSString* DB_URL = @"http://192.168.11.3/01_health/";
static NSString* const DB_URL = @"http://localhost/01_health/";
static NSString* const DB_URL_READ1 = @"http://localhost/01_health/sql_r10.php";
static NSString* const DB_URL_READ2 = @"http://localhost/01_health/sql_r20.php";
static NSString* const DB_URL_WRITE1 = @"http://localhost/01_health/sql_w10.php";
static NSString* const DB_URL_READ1_JSON = @"http://localhost/01_health/sql_r10_json.php";

// UAView ----------------------------------------------------------------------
//カレンダーの構造
static const CGFloat CELL_WIDTH = 40;               //日付ビューの幅
static const CGFloat CELL_HEIGHT = 40;              //日付ビューの高さ
static const CGFloat FONT_SIZE = 24.0;              //日付のフォントサイズ
static const CGFloat FONT_SIZE_SMALL = 16.0;        //日付の小さいフォントサイズ（当月以外）
static const CGFloat FONT_SIZE_HEADER = 24.0;       //見出し年月のフォントサイズ
static const CGFloat FONT_SIZE_WEEK = 15.0;         //見出し曜日のフォントサイズ
static const CGFloat WIDTH = CELL_WIDTH*7+10;       //カレンダビューの幅 (日付ビューの幅×７日＋定数)
static const CGFloat HEADER = 70;                   //カレンダーの上余白の高さ
static const CGFloat FOTTER = 50;                   //カレンダーの下余白の高さ
static const CGFloat HEIGHT = HEADER+CELL_HEIGHT*6+FOTTER;   //カレンダビュー全体の高さ
//血圧管理
static const CGFloat BP_LIMMIT = 200;               //対象となる血圧の上限値
static const CGFloat BP_NORMAL_LOW = 85;            //最低血圧　基準上限値
static const CGFloat BP_NORMAL_HIGH = 135;          //最高血圧　基準上限値

//カレンダービューを表示(移動)したときのカーソル(FirstResoinder)の位置の指定
typedef enum : NSInteger{
    CURRENT_DATE = 0,       //現在日：初期表示
    FIRST_DATE = 1,         //月初日
    LAST_DATE = 2,          //月末日
    NEXT_DATE = 3,          //翌日
    PRE_DATE = 4,           //前日
} StartPosTyp;

// UAItemView ------------------------------------------------------------------
//カーソルによる日付の移動方向
typedef enum : NSInteger{
    THIS = 0,        //当日
    RIGHT = 1,       //翌日
    LEFT = 2,        //前日
    DOWN = 3,        //翌週
    UP = 4,          //前週
} MoveTyp;

// UACalendar ------------------------------------------------------------------
//カレンダーの週数
typedef enum : NSInteger{
    DAYS_OF_5WEEKS = 35,
    DAYS_OF_6WEEKS = 42
} CalendarTYpe;

// UADate ----------------------------------------------------------------------
//日付属性フラグ（ビット定義：複数選択可）
typedef enum : NSInteger{
    Weekday = 1,        //平日
    Saturday = 2,       //土曜日
    Sunday = 3,         //日曜日
} DayType;

typedef enum : NSInteger{
    PreMonth = 1,       //前月
    ThisMonth = 2,      //当月
    NextMonth = 3,      //翌月
} MonthType;

#endif /* UAConstants_h */
