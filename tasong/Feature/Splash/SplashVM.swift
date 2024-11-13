//
//  SplashVM.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/14.
//

import Foundation

final class SplashVM: ObservableObject {
    
    @Published var remainingSeconds = 3
    
    var timer : Timer? = nil
    

    func loadData(){
        delayToNext()
    }
    
    func delayToNext(_ remainingSeconds: Int = 1){
        self.remainingSeconds = remainingSeconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//                    self?.updateCountdown()
//                }
    }
    
    @objc func updateCountdown(){
        if remainingSeconds > 0{
            remainingSeconds -= 1
        }else{
            endCountDownTimer()
        }
    }
    
    func endCountDownTimer(){
        timer?.invalidate()
        AppState.shared.doFinishSplash()
    }
}
