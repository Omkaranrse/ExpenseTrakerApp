//
//  EmitterView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

// We'll use the CAEmitter Layer & Add CAEmitterCells inside the Emitter for the particle Animations
// You can play around with the EmitterShape, and the values to customise the animation

// We'll use a UIRepresentable to append the CAEmitterLayer into a UIView, and pass it as a SwiftUI View
struct EmitterView: UIViewRepresentable {
    
    //MARK: - Variables
    let emitterConfiguartions : [EmitterConfiguration] = [
        EmitterConfiguration(
            birthRate: 300,
            lifeTime: 30,
            velocity: 100.0,
            velocityRange: 100,
            xAcceleration: 4,
            yAcceleration: 1,
            emissionRange: 180 * .pi,
            spin: 90 * .pi,
            spinRange: 100 * (.pi / 100.0),
            scale: 0.04,
            scaleRange: 0.25
        ),
        
        EmitterConfiguration(
            birthRate: 150,
            lifeTime: 30,
            velocity: 20,
            velocityRange: 100,
            xAcceleration: 4,
            yAcceleration: 0,
            emissionRange: 10.0 * .pi,
            spin: 90 * .pi,
            spinRange: 100 * (.pi / 180.0),
            scale: 0.05,
            scaleRange: 0.24
        )

    ]
    
    
    //MARK: - Functions
    func makeUIView(context: Context) -> UIView {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 44)
        let containerView = UIView(frame: CGRect(origin: .zero, size: size))
        
        //Array of Emitter Cells
        var emitterCells : [CAEmitterCell] = []
        
        //Particle Layer
        let particlesLayer = CAEmitterLayer()
        particlesLayer.frame = containerView.frame
        
        containerView.layer.addSublayer(particlesLayer)
        containerView.layer.masksToBounds = true
        
        //Customise the particle layer
        particlesLayer.emitterShape = .circle
        particlesLayer.emitterPosition = CGPoint(x: 600, y: 0)
        particlesLayer.emitterSize = CGSize(width: 1648.0, height: 48)
        particlesLayer.emitterMode = .volume
        particlesLayer.renderMode = .unordered
        
        //Iterate over the configuration, create emitter cells, and append the Particle CALayer
        for configuartion in emitterConfiguartions {
            let emitterCell = CAEmitterCell()
            
            //pass the config values
            emitterCell.contents = configuartion.content
            emitterCell.birthRate = configuartion.birthRate
            emitterCell.lifetime = configuartion.lifeTime
            
            emitterCell.velocity = configuartion.velocity
            emitterCell.velocityRange = configuartion.velocityRange
            
            emitterCell.xAcceleration = configuartion.xAcceleration
            emitterCell.yAcceleration = configuartion.yAcceleration
            emitterCell.emissionRange = configuartion.emissionRange
            
            emitterCell.spin = configuartion.spin
            emitterCell.scaleRange = configuartion.scaleRange
            emitterCell.spinRange = configuartion.spinRange
            emitterCell.scale = configuartion.scale
            
            //Append the cell to the emitter Cells Array
            emitterCells.append(emitterCell)
        }
        
        //pass the cells to the emitter layer
        particlesLayer.emitterCells = emitterCells
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    EmitterView()
}
