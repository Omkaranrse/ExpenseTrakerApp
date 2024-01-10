//
//  SwiftUIView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 06/01/24.
//

import SwiftUI

//struct Home : View {
//    
//    @State private var colors: [Color] =
//    [.black, .yellow, .purple, .brown]
//    
//    var body: some View{
//        ScrollView(.vertical) {
//            LazyVStack(spacing: 10) {
//                ForEach(colors, id: \.self){ color in
//                    SwipeAction(cornerRadius: 15, direction: .traling) {
//                        CardView(color)
//                    } actions: {
//                        
//                        Action(tint: .blue, icon: "star.fill") {
//                            print("BookMark")
//                        }
//                        
//                        Action(tint: .red, icon: "trash.fill") {
//                            withAnimation(.easeInOut){
//                                colors.removeAll(where: { $0 == color })
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(15)
//        }
//        .scrollIndicators(.hidden)
//    }
//
//    @ViewBuilder
//    func CardView(_ color: Color) -> some View {
//        HStack(spacing: 12){
//            Circle()
//                .frame(width: 50, height: 50)
//            
//            VStack(alignment: .leading, spacing: 6){
//                RoundedRectangle (cornerRadius: 5)
//                    .frame(width: 80, height: 5)
//                
//                RoundedRectangle (cornerRadius: 5)
//                    .frame(width: 60, height: 5)
//            }
//            
//            Spacer (minLength: 0)
//        }
//        .foregroundStyle(.white.opacity(0.4))
//        .padding(.horizontal, 15)
//        .padding(.vertical, 10)
//        .background(color.gradient)
//    }
//}

//Custom swipe action
//struct SwipeAction<Content: View>: View {
//    
//    var cornerRadius : CGFloat = 0
//    var direction : SwipeDirection = .traling
//    
//    @ViewBuilder var content: Content
//    @ActionBuilder var actions : [Action]
//    
//    let viewID = UUID()
//    @State private var isEnabled : Bool = true
//    
//    var body: some View {
//        ScrollViewReader { scrollProxy in
//            ScrollView(.horizontal){
//                LazyHStack(spacing: 0) {
//                    content
//                    /// To Take Full Available Space
//                        .containerRelativeFrame(.horizontal)
//                        .background{
//                            if let firstAction = actions.first {
//                                Rectangle()
//                                    .fill(firstAction.tint)
//                            }
//                        }
//                        .id(viewID)
//                    
//                    ActionButtons{
//                        withAnimation(.snappy) {
//                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
//                        }
//                    }
//                }
//                .scrollTargetLayout()
//                .visualEffect { content, geometryProxy in
//                    content
//                        .offset(x: scrollOffset(geometryProxy))
//                }
//            }
//            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.viewAligned)
//            .background{
//                if let lastAction = actions.last {
//                    Rectangle()
//                        .fill(lastAction.tint)
//                }
//            }
//            .clipShape(.rect(cornerRadius: cornerRadius))
//        }
//        .allowsHitTesting(isEnabled)
//    }
    
//    //Action Button
//    @ViewBuilder
//    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
//        //Each button will have 100 width
//        Rectangle()
//            .fill(.clear)
//            .frame(width: CGFloat(actions.count) * 100)
//            .overlay(alignment: direction.alignment) {
//                HStack(spacing: 0) {
//                    ForEach(actions) { button in
//                        Button(action: {
//                            Task {
//                                isEnabled = false
//                                resetPosition()
//                                try? await Task.sleep(for: .seconds(0.25))
//                                try? await Task.sleep(for: .seconds(0.1))
//                                button.action()
//                                isEnabled = true
//                            }
//                        }, label: {
//                            Image (systemName: button.icon)
//                                .font(button.iconFont)
//                                .foregroundStyle (button.iconTint)
//                                .frame(width: 100)
//                                .frame(maxHeight: .infinity)
//                                .contentShape(.rect)
//                        })
//                        .buttonStyle(.plain)
//                        .background(button.tint)
//                    }
//                }
//            }
//    }
//    
//    func scrollOffset(_ proxy : GeometryProxy) -> CGFloat {
//        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
//        
//        return direction == .traling ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
//    }
//}

//Swipe direction
//enum SwipeDirection {
//    case leading
//    case traling
//    
//    var alignment : Alignment {
//        switch self {
//        case .leading:
//            return .leading
//        case .traling:
//            return .trailing
//        }
//    }
//}
//
////ActionModel
//struct Action: Identifiable {
//    private(set) var id: UUID = .init()
//    var tint: Color
//    var icon: String
//    var iconFont: Font = .title
//    var iconTint: Color = .white
//    var isEnabled: Bool = true
//    var action: () -> ()
//}
// 
//@resultBuilder
//struct ActionBuilder {
//    static func buildBlock(_ components: Action...) -> [Action] {
//        return components
//    }
//}
//            
//#Preview {
//    Home()
//}
//
