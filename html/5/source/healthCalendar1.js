"use strict";    
//グローバル変数    
let demo = true;
const healthInputForm = document.querySelector('.INwrapper');  //入力フォーム
let healthYear;     //年
let healthMonth;    //月
let healthDay;      //日

//定数   
const LARGE_SIZE = 42;
const REGULAR_SIZE = 35;
//HTML要素への参照    
const thisYearMonth = document.querySelector('.thisYearMonth'); //年月タイトル     
const preButton = document.querySelector('.preButton');         //前月ボタン
const nxtButton = document.querySelector('.nxtButton');         //翌月ボタン
const inputButton = document.querySelector('#inputValue');      //入力ボタン
const resultButton = document.querySelector('#result');         //一覧表示ボタン

//変数    
let wk = new Date();                                         
let nowDt = new Date(wk.getFullYear(), wk.getMonth(), wk.getDate()); //当日(時刻を消去)
let baseDt =  new Date(wk.getFullYear(), wk.getMonth(), 1);         //月初日
let positions = new Array();                                        //td要素参照リスト
let currentPos;                                                     //選択日
let isLargeTable;                                                   //カレンダーの大きさ
let holidaysList;                                                   //休日辞書
let valuesList;                                                     //血圧データリスト

//入力フォームの表示
healthInputForm.style.display = 'none';                     //入力フォーム非表示 
window.onload = setUp();

//------------------------------------------------------------------------- 
//初期処理
//------------------------------------------------------------------------- 
function setUp(){
    //リクエストの作成
    let request = new XMLHttpRequest()
    request.open('GET', 'http://localhost/doc_calendar/holiday.json');
    //リクエストの送信
    request.send();
    
    //レスポンスの受信
    request.onload = function(){
        //休日ファイルの読み込み
        let jsonText = request.responseText;
        holidaysList = JSON.parse(jsonText); 
        //血圧データの取得＆カレンダーの作成
        queryData(function(){makeCalendar(function(){;})});  //        
    }
}
//------------------------------------------------------------------------- 
//血圧データの取得(query)
//------------------------------------------------------------------------- 
function queryData(funcMakeCalendar){
    //リクエストの作成
    let year = baseDt.getFullYear();
    let month = ("0"+(baseDt.getMonth()+1)).slice(-2);
    let days = new Date(year, month, 0).getDate();  
    healthYear = baseDt.getFullYear();
    healthMonth = baseDt.getMonth()+1;
    let request = new XMLHttpRequest();
    if (demo){
        request.open('POST', './php_demo/sql_r10.php'); //relative path OK
    }else{
        request.open('POST', './php/sql_r10.php'); //relative path OK
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let id=500;
    let from_date=`${year}${month}01`;
    let to_date=`${year}${month}${days}`;
    let param = `id=${id}&from_date=${from_date}&to_date=${to_date}`;        
    //リクエストの送信
    request.send(param);
    
    //レスポンスの受信
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            //正常・血圧データ取得
            let jsonText = request.responseText;
            valuesList = JSON.parse(jsonText);
            //カレンダーの作成
            funcMakeCalendar();
            //イベントハンドラの設定
            setEventHandler();
        }else{
            alert('HTTPエラー status:'+this.status);
            return;
        }
    }
    
    //タイムアウト
    request.ontimeout = function () {
        alert("timed out.");
        return;
    };
}
//------------------------------------------------------------------------- 
//イベントハンドラの設定
//------------------------------------------------------------------------- 
function setEventHandler(){
    document.addEventListener('keydown', h_logKey);                   //キーボード入力
    preButton.addEventListener('click', h_preMonth);                  //前月へ
    nxtButton.addEventListener('click', h_nxtMonth);                  //翌月へ
    inputButton.addEventListener('click', h_openForm);                //入力フォーム開く
    resultButton.addEventListener('click', h_openrpResultTable);      //一覧表開く
    for(let cell of positions){
        cell.addEventListener('click', h_dateClicked);                //選択日の移動
        cell.addEventListener('dblclick', h_openForm);                //入力フォーム開く
    }
}
//------------------------------------------------------------------------- 
//イベントハンドラの削除
//------------------------------------------------------------------------- 
function removeEventHandler(){
    document.removeEventListener('keydown', h_logKey);                   //キーボード入力
    preButton.removeEventListener('click', h_preMonth);                  //前月へ
    nxtButton.removeEventListener('click', h_nxtMonth);                  //翌月へ
    inputButton.removeEventListener('click', h_openForm);                //入力フォーム開く
    resultButton.removeEventListener('click', h_openrpResultTable);      //一覧表開く   
    for(let cell of positions){
        cell.removeEventListener('click', h_dateClicked);                //選択日の移動
        cell.removeEventListener('dblclick', h_openForm);                //入力フォーム開く
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
        //血圧データ入力済みの判定
        items.sumi = false;
        for(let record of valuesList){
            if (record.date.toString() === yyyymmdd ){
                if (record.confirm === 1){
                    items.sumi = true;
                }
                break;
            }
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
            cell.removeAttribute('class');　//前回分をクリア
            positions.push(cell); //td要素への参照の確保
            cell.firstChild.textContent = daysList[idx].date;　　//日付のセット
            //休日
            if (daysList[idx].day == 'sunday' || daysList[idx].holiday !== ""){
                cell.classList.add('holiday');
            }else if  (daysList[idx].day == 'saturday'){
                cell.classList.add('saturday');
            }
            //当月日
            if (daysList[idx].month == 'this'){
                cell.classList.add('largeFont');
            }else{
                cell.classList.add('smallFont');
            }
            //血圧データ入力済みか
            if (daysList[idx].sumi){
                cell.classList.add('input');
            }else{
                cell.classList.add('noInput');
            }      
            cell.classList.add('day');          
            idx++;
        }
    }
    setCurrentPos();
    movePosition(currentPos); 
}
//-------------------------------------------------------------------------    
//矢印キーによる選択日の移動：イベントハンドラ    
//------------------------------------------------------------------------- 
function h_logKey(e) {
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
//前月のカレンダー：イベントハンドラ
//------------------------------------------------------------------------- 
function h_preMonth(){
    baseDt =  new Date(baseDt.getFullYear(), baseDt.getMonth()-1, 1);   //前月初日
    //血圧データの取得＆カレンダーの作成            
    queryData(function(){
        makeCalendar(function(){
            if (isLargeTable){
                currentPos = LARGE_SIZE-1;
            }else{
                currentPos = REGULAR_SIZE-1;
            }
        })  
    });
}
//------------------------------------------------------------------------- 
//翌月のカレンダー：イベントハンドラ
//------------------------------------------------------------------------- 
function h_nxtMonth(){
    baseDt = new Date(baseDt.getFullYear(), baseDt.getMonth()+1, 1);   //前月初日
    //血圧データの取得＆カレンダーの作成            
    queryData(function(){
        makeCalendar(function(){
            currentPos = 0;
        })  
    });
}    
//------------------------------------------------------------------------- 
//日付をクリックした：イベントハンドラ
//------------------------------------------------------------------------- 
function h_dateClicked(e){
    for (let i=0; i<positions.length; i++){
        if (e.target === positions[i]){
            currentPos = i;
            movePosition()
            break;
        }
    }
}

//------------------------------------------------------------------------- 
//一覧表ウィンドウを開く：イベントハンドラ
//------------------------------------------------------------------------- 
function h_openrpResultTable(e){
    let url = `result.html?year=${healthYear}&month=${('0'+healthMonth).slice(-2)}`;
    window.open(url, '_blank', 'menubar=0,width=600, height=850, top=0, left=0');
    console.log(url);
}
//---------------------------------------------------------------------
//入力フォーム：イベントハンドラ
//---------------------------------------------------------------------
function h_openForm(){
    healthInputForm.style.display = 'grid';
    //カレンダーのイベントハンドラ削除
    removeEventHandler();
    healthDay = positions[currentPos].firstChild.textContent;

    //日付の表示
    let todayStr = `${healthYear}年${healthMonth}月${healthDay}日`; 
    midashi.textContent = todayStr;
    highValue.item.classList.add('INfocus');
    lowValue.item.classList.remove('INfocus');
    confirm.item.classList.remove('INfocus');
    currentInput = highValue;
    confirmFlg = false;
    //血圧データの取得
    let request = new XMLHttpRequest()
    if (demo){
        request.open('POST', './php_demo/sql_r20.php'); //relative path OK
    }else{
        request.open('POST', './php/sql_r20.php'); //relative path OK  
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let id=500;
    let yyyymmdd = `${healthYear}${('0'+healthMonth).slice(-2)}${('0'+healthDay).slice(-2)}`;
    let param = `id=${id}&date=${yyyymmdd}`;   
    //リクエストの送信
    request.send(param);
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            let jsonText = request.responseText;
            let valuesList = JSON.parse(jsonText);
            //正常
            if (valuesList.length > 0){
                highValue.item.textContent = valuesList[0].upper
                lowValue.item.textContent = valuesList[0].lower;
                if(valuesList[0].confirm === 1){
                    confirmFlg = true;
                    confirm.item.classList.add('INyes');
                }
            }else{
                highValue.item.textContent = '0';
                lowValue.item.textContent = '0';
                confirmFlg = true;
                confirm.item.classList.remove('INyes');
            }
        }else{
            alert('HTTPエラー status:'+this.status);
            return;
        }
    }
    //タイムアウト
    request.ontimeout = function () {
        alert("timed out.");
        return;
    };
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
