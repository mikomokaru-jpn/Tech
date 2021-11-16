//NSThreadクラスのメソッドを使用 (GCD以前の方式）
-(void)start2{
    [self reset];                   //UIリセッット
    _btnStart.enabled = NO;         //開始ボタン
    _btnCancel.enabled = YES;       //中止ボタン
    //カウント処理を別スレッドで実行（メインスレッドとは非同期）
    [NSThread detachNewThreadSelector:@selector(countNumberByMethod)
                             toTarget:self
                           withObject:nil];
}
//-------- 内部メソッッド --------
//カウント処理：NSObject performSelectorによるコールバック
-(void)countNumberByMethod{
    for(int i=0; i<20; i++){
        [NSThread sleepForTimeInterval:0.1];
        _counter = i+1;
        if (_cancelFlag == YES){
            break;  //中止
        }
        [self performSelectorOnMainThread:@selector(updateUI) 
                              withObject:nil waitUntilDone:NO];
    }
    //終了時のCallBack（メインスレッド）
    [self performSelectorOnMainThread:@selector(postRoutine) 
                             withObject:nil waitUntilDone:NO];
}
//UI更新・終了メッセージ
-(void)postRoutine{
    _btnStart.enabled = YES;        //開始ボタン
    _btnCancel.enabled = NO;        //中止ボタン
    if(!_cancelFlag)
    {   //終了ダイアログ
        //https://openradar.appspot.com/28700495
        NSAlert *msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText:@"終了"];
        [msgBox runModal];
    }
}