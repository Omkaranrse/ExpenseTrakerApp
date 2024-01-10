//
//  LockView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 07/01/24.
//

import SwiftUI
import LocalAuthentication

//Custom View
struct LockView<Content : View>: View {
    
    var lockType : LockType
    var lockPin : String
    var isEnabled : Bool
    var lockWhenAppGoesBackground : Bool = true
    
    @State private var pin : String = ""
    @State private var animateField : Bool = false
    @State private var isUnLocked : Bool = false
    @State private var noBiometricAccess : Bool = false
    
    @ViewBuilder var content : Content
    
    //Lock Context
    let context = LAContext()
    
    //secne phase
    @Environment(\.scenePhase) private var phase
    
    var forgotPin : () -> () = { }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnLocked {
                ZStack{
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()

                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric{
                        Group{
                            if noBiometricAccess {
                                Text("Unable Biometric authentication in settinigs to unlock the view")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                                //BioMetric / pin lock
                                VStack(spacing: 12){
                                    VStack(spacing: 6){
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unLockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                        
                    } else {
                        //Custom number pad to enter password
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unLockView()
            }
        }
        //lock when app goes background
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnLocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnLocked && isEnabled {
                unLockView()
            }
        }
    }
    
    private func unLockView() {
        //Checking and unlocking view
        Task{
            if isBiometricAvailable && lockType != .number {
                //Requesting Biometric Unlock
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlocked the View"), result {
                    print("UnLocked")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete){
                        isUnLocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            //No biometric permission || lock type is set as number pin
            //updating bipmetric status
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    private var isBiometricAvailable : Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    //Number Pad
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing : 15){
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    //Back BUtton only for both lockType
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            //Adding wiggling animation for wrong password with Keyframe Animator
            HStack(spacing: 10){
                ForEach(0..<4, id: \.self){ index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                    //showing pin at each box with the help of index
                        .overlay{
                            //safe check
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                content
                    .offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack{
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing){
                Button(action: {
//                    forgotPin
                }, label: {
                    Text("Forgot Pin?")
                        .foregroundStyle(.white)
                        .offset(y: 40)
                })
            }
            .frame(maxHeight: .infinity)
            
            //Custom Number Pad
            GeometryReader{ _ in
                LazyVGrid(
                    columns: Array(repeating: GridItem(), count: 3), content: {
                        ForEach(1...9, id: \.self){ number in
                            Button(action: {
                                //Add Number Pin maxLimit = 4
                                if pin.count < 4 {
                                    pin.append("\(number)")
                                }
                            }, label: {
                                Text("\(number)")
                                    .font(.title)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .contentShape(.rect)
                            })
                            .tint(.white)
                        }
                        
                        // 0 and back Button
                        Button(action: {
                            if !pin.isEmpty{
                                pin.removeLast()
                            }
                        }, label: {
                            Image(systemName: "delete.backward")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)

                        Button(action: {
                            if pin.count < 4 {
                                pin.append("0")
                            }
                        }, label: {
                            Text("0")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)

                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    //Validate Pin
                    if lockPin == pin {
//                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete){
                            isUnLocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        print("Wrong Pin")
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    
    //Lock Type
    enum LockType : String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric and if it's not available, than it will go for number lock"
    }
}

#Preview {
    LockConentView()
}
