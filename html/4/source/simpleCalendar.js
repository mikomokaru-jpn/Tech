//------------------------------------------------------------------------- 
//JavaScript
//------------------------------------------------------------------------- 
//定数   
const LARGE_SIZE = 42;
const REGULAR_SIZE = 35;
//HTML要素への参照    
const thisYearMonth = document.querySelector('.thisYearMonth'); //年月タイトル     
const preButton = document.querySelector('.preButton');         //前月ボタン
const nxtButton = document.querySelector('.nxtButton');         //翌月ボタン
//グローバル変数    
let wk = new Date();                                         
let nowDt = new Date(wk.getFullYear(), wk.getMonth(), wk.getDate()); //当日:時刻はなし
let baseDt =  new Date(wk.getFullYear(), wk.getMonth(), 1);          //月初日:時刻はなし
let positions = new Array();                                         //td要素参照リスト
let currentPos;                                                      //選択日
let isLargeTable;                                                    //カレンダーの大きさ 5週or6週
let holidaysList;                                                    //休日辞書
//イベントハンドラの定義
document.addEventListener('keydown', logKey);   //キーボード入力・矢印キーを補足
preButton.addEventListener('click', preMonth);  //前月ボタン
nxtButton.addEventListener('click', nxtMonth);  //翌月ボタン
window.addEventListener('load', init);          //ページロード後 
//------------------------------------------------------------------------- 
//休日ファイル（JSON）の読み込み
//------------------------------------------------------------------------- 
function init(){    
    let request = new XMLHttpRequest()
    request.open('GET', '/doc_calendar/holiday.json');
    request.send();

    //非同期
    request.onload = function(){ 
        let jsonText = request.responseText;
        console.log(jsonText);
        holidaysList = JSON.parse(jsonText); //休日ファイルの読み込み        
        //カレンダーの作成
        makeCalendar(function(){
            ; //初期処理では、currentPosは当日。移動は行わない。
        }); 
    }
}
//------------------------------------------------------------------------- 
//カレンダーの作成
//------------------------------------------------------------------------- 
function makeCalendar(setCurrentPos){
    //年月見出し
    let seireki = baseDt.getFullYear()+'年'+(baseDt.getMonth()+1)+'月';
    let opt = {era:'short', year:'numeric'};
    let wareki = baseDt.toLocaleDateString("ja-JP-u-ca-japanese", opt);
    thisYearMonth.textContent = seireki+'('+wareki+')';
    //カレンダの作成
    let firstDt = new Date(baseDt.getTime());     //月初日（1日）
    let lastDt = new Date(baseDt.getFullYear(), baseDt.getMonth()+1, 0);    //月末日
    let daysList = new Array(LARGE_SIZE);   //日付リスト
    //前月末の日数を求める.  月曜始まりのカレンダーなので、月曜:0日,,,土曜:5日,日曜:6日となる
    let preDays = firstDt.getDay()-1;          
    if (preDays < 0){ preDays = 6 };
    isLargeTable = (lastDt.getDate() + preDays > REGULAR_SIZE); //カレンダの大きさ
    //前月の最終月曜日、すなわちカレンダの最初（左上隅）の日を求める。
    let current = new Date(firstDt.getTime());
    current.setDate(firstDt.getDate()-preDays); 
    //日付オブジェクトの作成 0..42
    for (let i=0; i<daysList.length; i++){
        let items = new Object();
        items.date = current.getDate(); //日付のセット
        //当月の判定
        if (baseDt.getMonth() === current.getMonth()){
            items.month = "this";
        }else{
            items.month = "";
        } 
        //土日の判定
        if (current.getDay() == 0){
            items.day = "sunday";
        }else if (current.getDay() == 6){
            items.day = "saturday";
        }else{
            items.day = "";
        }    
        //当日の判定 
        if (current.getTime() === nowDt.getTime()){
            currentPos = i;            
        }
        //休日の判定
        let yyyymmdd = current.getFullYear() + 
                       ("0"+(current.getMonth() + 1)).slice(-2) + 
                       ("0"+current.getDate()).slice(-2);
        let holiday = holidaysList[yyyymmdd];
        if(holiday !== void 0){
            items.holiday = holiday;
        }else{
            items.holiday = "";
        }
        //日付リストに追加
        daysList[i] = items;        
        current.setDate(current.getDate()+1);   //１日進める
    }
    //tableの編集
    let table = document.querySelector('table').tBodies[0];    
    let rowCount = table.rows.length;
    let cellCount = table.rows[0].cells.length;
    //日付のセット
    let idx = 0;
    positions　= []; //td要素参照テーブルのクリア
    for (let i=0; i<rowCount; i++){
        if (!isLargeTable && i==5){
                table.rows[i].hidden = true;
                break;
        }
        table.rows[i].hidden = false;
        for (let j=0; j<cellCount; j++){
            let cell = table.rows[i].cells[j];
            cell.addEventListener('click', dateClicked);
            positions.push(cell);                               //td要素への参照の確保
            cell.firstChild.textContent = daysList[idx].date;   //日付のセット
            let value = '';  
            //休日
            if (daysList[idx].day == 'sunday' || daysList[idx].holiday !== ""){
                value = 'holiday';
            }else if  (daysList[idx].day == 'saturday'){
                value = 'saturday';
            }
            //当月日
            if (daysList[idx].month == 'this'){
                value += ' largeFont';
            }else{
                value += ' smallFont';
            }
            cell.setAttribute('class', value);
            idx++;
        }
    }     
    setCurrentPos();
    movePosition(currentPos);
}

//-------------------------------------------------------------------------    
//矢印キーによる選択日の移動    
//------------------------------------------------------------------------- 
function logKey(e) {
    //console.log(`${e.code} ${e.shiftKey}`);
    switch (e.code){
        case 'ArrowLeft':
            if (currentPos === 0) {
                preMonth(); //月初日は前月へ
                return;
            }
            currentPos--;
            movePosition();
        break;
        case 'ArrowRight':
            if ((isLargeTable &&  currentPos === LARGE_SIZE-1) || 
                (!isLargeTable && currentPos === REGULAR_SIZE-1)){
                nxtMonth(); //月末日は翌月へ
                return;
            };
            currentPos++;
            movePosition();
            break;
        case 'ArrowUp':
            if (currentPos <= 6) {return};
            currentPos -= 7;
            movePosition();
        break;
        case 'ArrowDown':
            if (isLargeTable){
                if (currentPos >= REGULAR_SIZE) {return};
            }else{
                if (currentPos >= REGULAR_SIZE-7) {return};
            }
            currentPos += 7;
            movePosition();
        break;
        case 'Comma':    
            if (e.shiftKey){
                preMonth(); //前月へ
            }
            break;
        case 'Period':    
            if (e.shiftKey){
                nxtMonth(); //前月へ
            }
            break;
        default:
            return;
        break;
    }
    movePosition(currentPos);
}
//------------------------------------------------------------------------- 
//選択日のハイライト
//------------------------------------------------------------------------- 
function movePosition(){
    for (let i=0; i<positions.length; i++){
        if (positions[i] === void 0){
            break;
        }
        if (i === currentPos){                 
            positions[i].classList.add('currentDay')
        }else{
            positions[i].classList.remove('currentDay')
        }

    }
}
//------------------------------------------------------------------------- 
//前月のカレンダー    
//------------------------------------------------------------------------- 
function preMonth(){
    baseDt =  new Date(baseDt.getFullYear(), baseDt.getMonth()-1, 1);   //前月初日
    makeCalendar(function(){
        if (isLargeTable){
            currentPos = LARGE_SIZE-1;
        }else{
            currentPos = REGULAR_SIZE-1;
        }
    });
}
//------------------------------------------------------------------------- 
//翌月のカレンダー    
//------------------------------------------------------------------------- 
function nxtMonth(){
    baseDt = new Date(baseDt.getFullYear(), baseDt.getMonth()+1, 1);   //前月初日
    makeCalendar(function(){
        currentPos = 0;
    });
}    
//------------------------------------------------------------------------- 
//日付をクリックした
//------------------------------------------------------------------------- 
function dateClicked(e){
    for (let i=0; i<positions.length; i++){
        if (e.target === positions[i]){
            currentPos = i;
            movePosition()
            break;
        }
    }
}