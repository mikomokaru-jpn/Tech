"use strict";    
//グローバル変数    
let demo = true;
let year, month, days;
let valuesList;
//適正血圧    
const NORMAL_LOW = 85; 
const NORMAL_HIGH = 135;     
//グラフの色
const lowNormal = "rgba(100, 100, 100, 0.2)";
const highNormal = "rgba(100, 100, 100, 0.3)";
const lowWarning = "rgba(255, 100, 100, 0.6)";
const highWarning = "rgba(255, 100, 100, 0.9)";

window.onload = init();     

//-------------------------------------------------------------------------    
// 初期処理    
//-------------------------------------------------------------------------    
function init(){
    let params = (new URL(document.location)).searchParams;
    year = params.get('year');
    month = ("0"+params.get('month')).slice(-2);
    days = new Date(year, month, 0).getDate();   
    //血圧レコードの取得：HTTP Request & SQL
    let request = new XMLHttpRequest()
    if (demo){
        request.open('POST', './php_demo/sql_r10.php'); 
    }else{
        request.open('POST', './php/sql_r10.php'); 
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    //パラメータ
    let id=500;
    let from_date=`${year}${month}01`;
    let to_date=`${year}${month}${days}`;
    let param = `id=${id}&from_date=${from_date}&to_date=${to_date}`;        
    request.send(param);

    //受信後の処理
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
                let jsonText = request.responseText;
                valuesList = JSON.parse(jsonText); 
                console.log(jsonText);
                makeTable();
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
// 表の作成
//-------------------------------------------------------------------------    
function makeTable(){   
    //一覧表の要素を追加する開始位置
    const startPos = document.querySelector('div.chart'); 
    //年月の設定
    let ymRef = document.querySelector('.thisYearMonth');
    ymRef.textContent = `${year}年${month}月`;
    //曜日の取得
    let firstDt = new Date(year, month-1, 1);    //月初日
    let week = firstDt.getDay();
    let yobis = ['日', '月', '火', '水', '木', '金', '土'];
    //日数分繰り返す
    for (let i=0; i<days; i++){
        //日付
        let dayRef = document.createElement('div');  //要素オブジェクトの作成
        dayRef.textContent = i+1;                    //表示テキストのセット   
        dayRef.setAttribute('class', 'box1');        //class属性の追加
        startPos.appendChild(dayRef);                //HTMLドキュメントに追加する（以下同様）
        //曜日
        let weekRef = document.createElement('div');
        weekRef.textContent = yobis[(week+i)%7];
        weekRef.setAttribute('class', 'box2');
        startPos.appendChild(weekRef);
        //血圧値の取得
        let dayStr = (i+1).toString();
        dayStr = ('0'+dayStr).slice(-2);
        let low = '';
        let high = ''; 
        let dt = year+month+dayStr;
        for(let record of valuesList){           //DBから取得した血圧データを検索する
            if (record.date.toString() === dt){
                if(record.confirm === 1){
                    low = record.lower;
                    high = record.upper;
                }
                break;
            }
        } 
        //最低血圧
        let lowValueRef = document.createElement('div');
        lowValueRef.textContent = low;
        lowValueRef.setAttribute('class', 'box3');
        if (low > NORMAL_LOW){
            lowValueRef.style.color = "red";
        }
        startPos.appendChild(lowValueRef);
        //最高血圧
        let highValueRef = document.createElement('div');
        highValueRef.textContent = high;
        highValueRef.setAttribute('class', 'box4');
        if (high > NORMAL_HIGH){
            highValueRef.style.color = "red";
        }
        startPos.appendChild(highValueRef);            
        
        //棒グラフ
        let graphBoxRef = document.createElement('div');
        graphBoxRef.setAttribute('class', 'box5');
        startPos.appendChild(graphBoxRef);
        
        let graph1Ref = document.createElement('div');
        graph1Ref.setAttribute('class', 'graph');
        graphBoxRef.appendChild(graph1Ref);

        let graph2Ref = document.createElement('div');
        graph2Ref.setAttribute('class', 'graph');
        graphBoxRef.appendChild(graph2Ref);

        let graph3Ref = document.createElement('div');
        graph3Ref.setAttribute('class', 'graph');
        graphBoxRef.appendChild(graph3Ref);

        //最低血圧のグラフ
        let x1 = low * (100 / 200);
        if (low <= NORMAL_LOW){
            graph1Ref.style.backgroundColor = lowNormal;
        }else{
            graph1Ref.style.backgroundColor = lowWarning;
        } 
        //最高血圧のグラフ
        let x2 = (high - low)  * (100 / 200);
        if (high <= NORMAL_HIGH){
            graph2Ref.style.backgroundColor = highNormal;
        }else{
            graph2Ref.style.backgroundColor = highWarning;
        } 
        //余白
        let x3 = (200 - high) *  (100 / 200);
        //グリッドの比率の変更
        graphBoxRef.style.gridTemplateColumns = `${x1}fr ${x2}fr ${x3}fr`;
    }

    let borderRef;
    for(let i=0; i<5; i++){  
        borderRef = document.createElement('div');
        borderRef.setAttribute('class', 'frameBorder');
        startPos.appendChild(borderRef);
    }

}  
