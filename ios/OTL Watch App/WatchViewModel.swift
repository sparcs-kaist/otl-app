//
//  WatchViewModel.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/8/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var sessionID: String = ""
    @Published var userID: String = ""
    
    enum WatchReceiveMethod: String {
        case sendSessionID
        case sendUserID
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension WatchViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            guard let rawMethod = userInfo["method"] as? String, let method = WatchReceiveMethod(rawValue: rawMethod) else {
                return
            }
            
            switch method {
            case .sendSessionID:
                self.sessionID = userInfo["data"] as? String ?? ""
                UserDefaults.standard.set(userInfo["data"] as? String ?? "", forKey: "sessionID")
            case .sendUserID:
                self.userID = userInfo["data"] as? String ?? ""
                UserDefaults.standard.set(userInfo["data"] as? String ?? "", forKey: "userID")
            }
        }
    }
}
