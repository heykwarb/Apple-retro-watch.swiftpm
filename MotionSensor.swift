//
//  MotionSensor.swift
//  Apple retro watch
//
//  Created by Yohey Kuwa on 2023/05/22.
//

import SwiftUI
import CoreMotion

class MotionSensor: ObservableObject {
    
    @Published var isStarted = false
    
    @Published var AccelerateX: CGFloat = 0
    @Published var AccelerateY: CGFloat = 0
    @Published var AccelerateZ: CGFloat = 0
    
    @Published var RotationX: CGFloat = 0
    @Published var RotationY: CGFloat = 0
    @Published var RotationZ: CGFloat = 0
    
    @Published var attitudePitch: CGFloat = 0
    @Published var attitudeRoll: CGFloat = 0
    @Published var attitudeYaw: CGFloat = 0
    
    
    let motionManager = CMMotionManager()
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.updateMotionData(deviceMotion: motion!)
            })
        }
        
        isStarted = true
    }
    
    func stop() {
        isStarted = false
        motionManager.stopDeviceMotionUpdates()
    }
    
    func updateMotionData(deviceMotion:CMDeviceMotion) {
        withAnimation(){
            //acceleration
            ///AccelerateX = deviceMotion.userAcceleration.x
            ///AccelerateY = deviceMotion.userAcceleration.y
            ///AccelerateZ = deviceMotion.userAcceleration.z
            
            //rotation
            ///RotationX = deviceMotion.rotationRate.x
            ///RotationY = deviceMotion.rotationRate.y
            ///RotationZ = deviceMotion.rotationRate.z
            
            //attitude
            attitudePitch = deviceMotion.attitude.pitch
            attitudeRoll = deviceMotion.attitude.roll
            attitudeYaw = deviceMotion.attitude.yaw
        }
    }
}

