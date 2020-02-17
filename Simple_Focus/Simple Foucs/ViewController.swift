//
//  ViewController.swift
//  Simple Foucs
//
//  Created by 高成志 on 2020/2/7.
//  Copyright © 2020 StudentGao. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
private let categoryid = "categoryid"
class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
   
   var backgroundTask = BackgroundTask()

   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }// 隐藏状态栏
    @IBAction func panreco(_ sender: UIPanGestureRecognizer) {
       
    }
   
    
    var player:AVAudioPlayer = AVAudioPlayer()
    @IBOutlet weak var screenInfo: UILabel!
    @IBOutlet weak var timer: UILabel!
     
    let impact = UIImpactFeedbackGenerator()//震动反馈
   
    
    
     
    
    @IBAction func OK(_ sender: UIButton)
    {
        
       
        if  isCounting == false {isCounting = true
        
            backgroundTask.startBackgroundTask()
            
        }
        else                    {isCounting = false}

        impact.impactOccurred()//震动反馈
        
    }
    var transY:CGFloat!
    var transX:CGFloat!
    var restIf:Bool = false
    let selection = UISelectionFeedbackGenerator()//震动反馈
    @IBAction func settimer(_ sender: UIPanGestureRecognizer) {
        transY = sender.translation(in: bigcirle).y
        transX = sender.translation(in: bigcirle).x
        
        inputTime = 60*datatranser(Yvalue: transY,Xvalue: transX)
     
        inputRecord = inputTime
        screenInfo.text = "设置时间"
        timer.text = "\(secondsToTimeString(seconds: inputTime))"
        
    }
    var inputRecord:Int = 0
   
    
    func datatranser(Yvalue:CGFloat,Xvalue:CGFloat) -> Int {
//        selection.selectionChanged()//震动反馈
        if getAngle(x: Float(transX), y: Float(transY)).isNaN {
            inputTime = 0
        }
        else {inputTime = Int(abs(getAngle(x: Float(transX), y: Float(transY))))}
        
        return inputTime
        
    }
    
    
    
    @IBOutlet weak var bigcirle: UIImageView!
    
    
    
    var remainingSeconds: Int = 0
    
    {
         willSet
         {
                screenInfo.text = "剩余时间"
                timer.text = "\(secondsToTimeString(seconds: newValue))"
             if newValue <= 0
             {
                
                var messageText1="\n要不要休息5分钟？"
                               if restIf == true {messageText1="\n重复上一个任务？"}
                var messageText2 = "休息5分钟"
                               if restIf == true {messageText2="重复上一个任务"}
                
                
                
                
                
                backgroundTask.stopBackgroundTask()
             


// 1. 注册通知权限
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
                    print("iOS 10+ 通知授权" + (success ? "成功" : "失败"))
                }
                
                
                    
                 
                    
        
                  
                
                   
                
                func didReceive(_ response: UNNotificationResponse)
                {
                    if response.actionIdentifier == "replayAction" {
                                           if self.restIf == false
                                                                                {self.inputTime = 60*5}
                                                                                else {self.inputTime = self.inputRecord}
                                       self.isCounting = true
                                       if self.restIf == false
                                                                        {self.restIf = true}
                                                                        else {self.restIf = false}}}

                
                // 2. 设置交互
                let replayAction = UNNotificationAction(identifier: "replayAction", title: "\(messageText2)", options:[])
                let stopAction = UNNotificationAction(identifier:"stopAction",title: "不用了",options: .destructive)
                let categroy = UNNotificationCategory(identifier: categoryid,actions: [replayAction, stopAction],intentIdentifiers: [],options: UNNotificationCategoryOptions(rawValue: 0))
                UNUserNotificationCenter.current().setNotificationCategories([categroy])
                // 3.设置通知代理，用于检测交互点击方法
                UNUserNotificationCenter.current().delegate = self;
                func send() {
                
                //4. 设置本地通知相关的属性 // 应该使用UNNotificationContent的子类来进行设定
                let content = UNMutableNotificationContent() //iOS 10
                
                // 设置应用程序的数字角标
                content.badge = 1
                
                // 设置声音
                content.sound = UNNotificationSound.default
                    
                
                // 设置内容
                content.title = "计时结束"
                content.subtitle = "\(messageText1)"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    content.categoryIdentifier = categoryid;
                    let request = UNNotificationRequest(identifier: "local", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                    if error == nil {
                        print("通知完成 \(content)")
                    }
                    }
                }
                func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                    
                    print("收到了点击事件 \(response)")
                }
                
         screenInfo.text = "计时结束"
                timer.text = "\(secondsToTimeString(seconds: newValue))"
   
                  send()
                //时间通知开始
                    let alert = UIAlertController(title:"计时结束",message:"\(messageText1)",preferredStyle:.alert)
                    let cancel=UIAlertAction(title:"不用了",style:.cancel)
                
                    let confirm=UIAlertAction(title:"\(messageText2)",style:.default){(action)in
                            if self.restIf == false
                                                   {self.inputTime = 60*5}
                            else {self.inputTime = self.inputRecord}
                        
                            self.isCounting = true
                        if self.restIf == false
                        {self.restIf = true}
                        else {self.restIf = false}
                    
                        }
                
                    
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    present(alert, animated: true, completion: nil)
                //时间通知结束
                
                 isCounting = false
             }
         }
     }
  
     var inputTime:Int = 0
    
// 后台运行组件

    
   
     var countdownTimer: Timer?
   
    
    
     var isCounting = false {
         
         willSet {
             if newValue
             {
                
                 
                 
                 
                
                countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t: Timer) in
                self.updateTime(timer: self.countdownTimer!)})
               
                 remainingSeconds = inputTime
                 
             } else {
                 countdownTimer?.invalidate()
                countdownTimer = nil; screenInfo.text="停止计时"}

             timer.isEnabled = !newValue
         }
     }
     
    
    
     func updateTime(timer: Timer)
     {
//取消声音
        let audiopath = Bundle.main.path(forResource: "滴答", ofType: "wav")
        do{try self.player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audiopath!) as URL)
        }
        catch{}
        self.player.play()
    
    // 计时开始时，逐秒减少remainingSeconds的值
         remainingSeconds -= 1
     }
    
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    
    
    
    
    
    
//    后台支持
    class BackgroundTask {
        
        // MARK: - Vars
        var player = AVAudioPlayer()
        var timer = Timer()
        
        // MARK: - Methods
        func startBackgroundTask() {
            NotificationCenter.default.addObserver(self, selector: #selector(interruptedAudio), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
            self.playAudio()
        }
        
        func stopBackgroundTask() {
            NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
            player.stop()
        }
        
        @objc fileprivate func interruptedAudio(_ notification: Notification) {
            if notification.name == AVAudioSession.interruptionNotification && notification.userInfo != nil {
                let info = notification.userInfo!
                var intValue = 0
                (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
                if intValue == 1 { playAudio() }
            }
        }
        
        
        
        fileprivate func playAudio()
        {
            do {
                _ = Bundle.main.path(forResource: "blank", ofType: "wav")
                
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [.defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
                
                // Play audio forever by setting num of loops to -1
                self.player.numberOfLoops = -1
                self.player.volume = 0.01
                self.player.prepareToPlay()
                self.player.play()
            } catch { print(error) }
        }
        
        
    }

    
}








