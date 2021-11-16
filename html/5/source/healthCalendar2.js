"use strict";    

let highValue = new Value();
let lowValue = new Value();     
let confirm = new Value();  

const midashi = document.querySelector('.INmidashi');       //日付タイトル     
const okButton = document.querySelector('#ok');             //更新ボタン
okButton.addEventListener('click', h_update);               //イベントハンドラの設定...
const cancelButton = document.querySelector('#cancel');     //キャンセルボタン
cancelButton.addEventListener('click', h_cancel);           //イベントハンドラの設定...
highValue.item = document.querySelector('#highValue');      //最高血圧
highValue.item.addEventListener('click', h_inputClick);     //イベントハンドラの設定...
lowValue.item = document.querySelector('#lowValue');        //最高血圧
lowValue.item.addEventListener('click', h_inputClick);      //イベントハンドラの設定...
let currentInput;                                           //現在の入力フィールド
confirm.item =  document.querySelector('#confirm');         //確定チェックボックス
confirm.item.addEventListener('click', h_confirmClick);     //イベントハンドラの設定...
let confirmFlg;                                             //確定フラグ 
const keys = new Array(10);                                 //数字キー
for (let i=0; i<10; i++){
    keys[i] = document.querySelector('.INkey'+i);           //オブジェクト参照の保存
    keys[i].addEventListener('click', h_keyClick);          //イベントハンドラの設定...
}
const keyC = document.querySelector('.INkeyC');             //クリアキー
keyC.addEventListener('click', h_clearClick);               //イベントハンドラの設定...
document.addEventListener('keydown', h_tabKey);             //イベントハンドラの設定...


//---------------------------------------------------------------------
//キーボード入力：イベントハンドラ    
//---------------------------------------------------------------------
function h_tabKey(e){      
    if (e.code === 'Tab'){       
        //Tabキーでフォーカス移動
        e.preventDefault();
        if (currentInput.item === highValue.item){
            changeField(lowValue);
        }else if(currentInput.item === lowValue.item){
            changeField(confirm);
        }else{
            changeField(highValue);
        }
    }
    if (currentInput.item === confirm.item){
        if (e.code === 'Enter'){
        //確定チェックボックスの更新
            confirmFlg = !confirmFlg;
            if (confirmFlg){
                confirm.item.classList.add('INyes');
            }else{
                confirm.item.classList.remove('INyes');
            }
        }       
    }else{
        if (e.keyCode >= 48 && e.keyCode <=  57){
            //数字の入力
            adding(e.keyCode-48);  //********       
        }else if(e.code === 'Backspace' ){
            //入力値の削除
            deleting();
        }else if (e.code === 'KeyC'){
            currentInput.item.textContent = '0';
        }
    }
}       
//---------------------------------------------------------------------
//数字キーのクリック：イベントハンドラ    
//---------------------------------------------------------------------
function h_keyClick(e){      
    if (currentInput.item === confirm.item){
        return;
    }
    let key = e.target.firstChild.textContent;  
    adding(key); 
}
//---------------------------------------------------------------------    
//クリアキーのクリック：イベントハンドラ    
//---------------------------------------------------------------------
function h_clearClick(e){      
    currentInput.item.textContent = '0';
}
//---------------------------------------------------------------------
//確定チェックボックスのクリック：イベントハンドラ  
//---------------------------------------------------------------------
function h_confirmClick(){
    if (currentInput.item === confirm.item){
        confirmFlg = !confirmFlg;
        if (confirmFlg){
            confirm.item.classList.add('INyes');
        }else{
            confirm.item.classList.remove('INyes');
        }        
    }
    changeField(confirm);
}
//---------------------------------------------------------------------
//値の削除：イベントハンドラ  未使用
//---------------------------------------------------------------------
function h_deleting(){
    let base = currentInput.item.textContent;
    if (base.length === 1){
        currentInput.item.textContent = '0';
    }else{
        currentInput.item.textContent = base.substring(0, base.length-1)
    }
}
//---------------------------------------------------------------------
//入力フィールドをクリック：イベントハンドラ  
//---------------------------------------------------------------------
function h_inputClick(e){
    if (e.target === currentInput.item){
        //すでに選択中
        return;
    }
    let next;
    if (e.target === highValue.item){
        next = highValue
    }else if (e.target === lowValue.item){
        next = lowValue;
    }else{
        next = confirm;
    }
    changeField(next);
}
//---------------------------------------------------------------------
//OK:血圧値の更新：イベントハンドラ    
//---------------------------------------------------------------------
function h_update(e){
    let request = new XMLHttpRequest()
    if (demo){
        request.open('POST', './php_demo/sql_w10.php'); 
    }else{
        request.open('POST', './php/sql_w10.php'); 
    }
    request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded');
    request.timeout = 3000; //msec
    let id=500;
    let upper = highValue.item.textContent;
    let lower = lowValue.item.textContent;
    let flg;
    if (confirmFlg){
        flg = 1;
    }else{
        flg = 0;
    }
    let yyyymmdd = `${healthYear}${('0'+healthMonth).slice(-2)}${('0'+healthDay).slice(-2)}`;
    let param = `id=${id}&date=${yyyymmdd}&lower=${lower}&upper=${upper}&confirm=${flg}`; 
    request.send(param);
    request.onload = function(){
        let READYSTATE_COMPLETED = 4;
        let HTTP_STATUS_OK = 200;
        if( this.readyState == READYSTATE_COMPLETED
            && this.status == HTTP_STATUS_OK ){
            //正常
            healthInputForm.style.display = 'none';
            setEventHandler();
            //血圧データの取得＆カレンダー作成
            let savePos = currentPos;
            queryData(function(){
                makeCalendar(function(){
                    currentPos = savePos; //これはすごい（が追えないな）
                })
            });  
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
//---------------------------------------------------------------------
//キャンセル：イベントハンドラ  
//---------------------------------------------------------------------
function h_cancel(e){
    healthInputForm.style.display = 'none';
    setEventHandler();
}

//---------------------------------------------------------------------
//フォーカス移動
//---------------------------------------------------------------------
function changeField(target){
    currentInput = target;
    highValue.item.classList.remove('INfocus');
    lowValue.item.classList.remove('INfocus');
    confirm.item.classList.remove('INfocus');
    currentInput.item.classList.add('INfocus');
    currentInput.initFlg = true;
}
//---------------------------------------------------------------------
//値の入力
//---------------------------------------------------------------------
function adding(num){
    if (currentInput.initFlg === true){
        currentInput.item.textContent = '';
        currentInput.initFlg = false;
    }

    let base = currentInput.item.textContent;
    if (base.length === 3){
        currentInput.item.textContent = '';
        base = '0';
    }
    if (base === '0'){
        if (num === '0'){
            currentInput.item.textContent = '0'     
        }else{
            currentInput.item.textContent = num;    
        }
    }else{
        currentInput.item.textContent = base + num;
        
        if (currentInput.item.textContent.length === 3){
            if (currentInput.item === highValue.item){
                changeField(lowValue);
            }else if(currentInput.item === lowValue.item){
                changeField(confirm);
            }else{
                changeField(highValue);
            }
        }
    }
}
//---------------------------------------------------------------------
//値の削除  
//---------------------------------------------------------------------
function deleting(){
    let base = currentInput.item.textContent;
    if (base.length === 1){
        currentInput.item.textContent = '0';
    }else{
        currentInput.item.textContent = base.substring(0, base.length-1)
    }
}
//---------------------------------------------------------------------
//血圧データオブジェクト
//---------------------------------------------------------------------
function Value(){
    this.item = null;
    this.initFlg = false;
}
