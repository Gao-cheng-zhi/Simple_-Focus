//
//  data.swift
//  Simple Foucs
//
//  Created by 高成志 on 2020/2/7.
//  Copyright © 2020 StudentGao. All rights reserved.
//

import Foundation
import UIKit

func secondsToTimeString(seconds: Int) -> String {
    //小时计算
    let hours = (seconds)%(24*3600)/3600;
    
    //分钟计算
    let minutes = (seconds)%3600/60;
    
    //秒计算
    let second = (seconds)%60;
    
    let timeString  = String(format: "%02lu:%02lu:%02lu", hours, minutes, second)
    return timeString
}

func getAngle(x:Float,y:Float)->Float {
    let x1:Double=110
    let y1:Double=(sqrt(Double(x*x+y*y+0.1))/2)+2
    
    var a = asin(y1/x1)
    
        var ret = a * 180/Double.pi;//弧度转角度，方便调试
    if (a > 1.4){
        a = a - 1.399
    }
        if (ret > 360){
            ret = ret - 350
        }
    if (ret <= 0.1){
            ret = ret + 1
        }
    return Float(ret)+0.1
    
    }


    










