//
//  Practicle.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import UIKit.UIImage

//Emitter Configuration Struct encapsulates the values that needs to be passed
//to the CA Emitter Cells

struct EmitterConfiguration {
    let birthRate: Float
    let lifeTime: Float
    
    let velocity: CGFloat
    let velocityRange: CGFloat
    let xAcceleration: CGFloat
    let yAcceleration: CGFloat
    let emissionRange: CGFloat
    
    let spin: CGFloat
    let spinRange: CGFloat
    let scale: CGFloat
    let scaleRange: CGFloat
    let content: CGImage? = UIImage (named: FillRandomiser.getRandomFill().rawValue)?.cgImage
}
