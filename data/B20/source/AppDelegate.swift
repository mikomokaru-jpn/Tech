//---- AppDelegate.swift ----
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let dtUtil = UADateUtil.dateManager         //シンングルトン・オブジェクト
    @IBOutlet weak var date1: NSTextField!
    @IBOutlet weak var date2: NSTextField!
    @IBOutlet weak var date3: NSTextField!
    @IBOutlet weak var date4: NSTextField!
    @IBOutlet weak var date5: NSTextField!
    @IBOutlet weak var date6: NSTextField!
    @IBOutlet weak var date7: NSTextField!
    @IBOutlet weak var date8: NSTextField!
    @IBOutlet weak var date9: NSTextField!
    @IBOutlet weak var date10: NSTextField!
    
    @IBOutlet weak var inYear1: NSTextField!
    @IBOutlet weak var inMonth1: NSTextField!
    @IBOutlet weak var inDay1: NSTextField!
    @IBOutlet weak var date11: NSTextField!

    @IBOutlet weak var inGengo: NSTextField!
    @IBOutlet weak var inYear2: NSTextField!
    @IBOutlet weak var inMonth2: NSTextField!
    @IBOutlet weak var inDay2: NSTextField!
    @IBOutlet weak var date12: NSTextField!

    @IBOutlet weak var outYear: NSTextField!
    @IBOutlet weak var outMonth: NSTextField!
    @IBOutlet weak var outDay: NSTextField!
    @IBOutlet weak var outDaySum: NSTextField!

    @IBOutlet weak var addYear: NSTextField!
    @IBOutlet weak var addMonth: NSTextField!
    @IBOutlet weak var addDay: NSTextField!
    @IBOutlet weak var date13: NSTextField!
    
    @IBOutlet weak var addDaySum: NSTextField!
    @IBOutlet weak var date14: NSTextField!

    //アプリケーション起動時
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.calc() //再計算
    }
    //再計算ボタン
    @IBAction func calcButton(_ sender: Any){
        self.calc()
    }
    
    //再計算
    func calc(){
        //現在日付・時刻　GMT
        let now = Date.init()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)  //GMT
        //formatter.timeZone = TimeZone(abbreviation:"GMT")
        date1.stringValue = formatter.string(from: now)
    
        //タイムゾーンを日本に戻す
        formatter.timeZone = NSTimeZone.local
        //現在日付・時刻　full format
        date2.stringValue = formatter.string(from: now)
        //現在日付・時刻 long format
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        date3.stringValue = formatter.string(from: now)
        //現在日付・時刻 medium format
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        date4.stringValue = formatter.string(from: now)
        //現在日付・時刻 short format
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        date5.stringValue = formatter.string(from: now)
        //現在日付・時刻 custom format
        formatter.dateFormat = "yyyyねん MMがつ ddにち HHじ mmふん ssびょう E曜日"
        date6.stringValue = formatter.string(from: now)
        
        //和暦
        let formatterJ: DateFormatter = DateFormatter()
        formatterJ.dateFormat = "Gyy年MM月dd日 HH時mm分ss秒"
        let calendarJ = Calendar.init(identifier: .japanese)
        formatterJ.calendar = calendarJ
        date7.stringValue = formatterJ.string(from: now)
        
        //曜日
        let weekDay = Calendar.current.component(.weekday, from: now)
        date8.stringValue = formatter.weekdaySymbols[weekDay-1]
        date9.stringValue = formatter.shortWeekdaySymbols[weekDay-1]

        //現在日の末日
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        date10.stringValue = formatter.string(from:dtUtil.lastDate(date: now))
        /*
        //日付の作成
        //日付A
        inYear1.integerValue = 1960
        inMonth1.integerValue = 3
        inDay1.integerValue = 6
        //日付B
        inGengo.stringValue = "昭和"
        inYear2.integerValue = 47
        inMonth2.integerValue = 8
        inDay2.integerValue = 18
        */
        //String -> DAte
        let inFormatter = DateFormatter()
        var dateA: Date = Date()
        inFormatter.dateFormat = "yyyy_MM/dd"

        let dateStringA = String(format:"%ld_%ld/%ld",
                                 inYear1.integerValue,
                                 inMonth1.integerValue,
                                 inDay1.integerValue)
        if let date = inFormatter.date(from: dateStringA) {
            dateA = date
            date11.stringValue = formatter.string(from: dateA)
        }
        
        var dateB: Date = Date()
        inFormatter.calendar =  Calendar.init(identifier: .japanese)
        inFormatter.dateFormat = "G-yy_MM/dd"
            
        let dateStringB = String(format:"%@-%ld_%ld/%ld",
                                 inGengo.stringValue,
                                 inYear2.integerValue,
                                 inMonth2.integerValue,
                                 inDay2.integerValue)
        
        if let date = inFormatter.date(from: dateStringB) {
            dateB = date
            date12.stringValue = formatter.string(from: dateB)
        }
        //--------------------------------------------------------------------------
        //二つの日付の差を年月日で求める
        //--------------------------------------------------------------------------
        var dComp = Calendar.current.dateComponents( [.year, .month, .day],
                                                     from: dateA, to: dateB)
        outYear.integerValue = dComp.year ?? 0
        outMonth.integerValue = dComp.month ?? 0
        outDay.integerValue = dComp.day ?? 0
        let from = Calendar.current.ordinality(of: .day, in: .era, for: dateA)
        let to = Calendar.current.ordinality(of: .day, in: .era, for: dateB)
        outDaySum.integerValue = (to ?? 0) - (from ?? 0)
        //--------------------------------------------------------------------------
        //日付の計算：日付オブジェクト±年(整数)・月(整数)・日(整数)　d
        //--------------------------------------------------------------------------
        dComp = DateComponents.init()
        dComp.year = addYear.integerValue
        dComp.month = addMonth.integerValue
        dComp.day = addDay.integerValue
        if let date = Calendar.current.date(byAdding: dComp, to: dateA){
            date13.stringValue = formatter.string(from: date)
        }
        //--------------------------------------------------------------------------
        //日付の計算：日付オブジェクト±通算日数(整数)　dateByAddingComponentsメソッッド
        //--------------------------------------------------------------------------
        dComp = DateComponents.init()
        dComp.day = addDaySum.integerValue
        if let date = Calendar.current.date(byAdding: dComp, to: dateA){
            date14.stringValue = formatter.string(from: date)
        }
    }
}

