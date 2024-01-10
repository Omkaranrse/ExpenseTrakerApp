//
//  SwiftUIView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 06/01/24.
//

import SwiftUI

//struct Home: View {
//    @State private var colors: [Color] = [.black, .yellow, .purple, .brown]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView(.vertical) {
//                LazyVStack(spacing: 10) {
//                    ForEach($colors, id: \.self) { color in
//                        ZStack {
//                            CardView(color)
//
//                            SwipeAction(cornerRadius: 15, direction: .traling, lastActionTint: Color.red) {
//                                CardView(color)
//                            } actions: {
//                                Action(tint: .blue, icon: "star.fill") {
//                                    print("BookMark")
//                                }
//
//                                Action(tint: .red, icon: "trash.fill") {
//                                    withAnimation(.easeInOut) {
//                                        colors.removeAll { $0 == color }
//                                    }
//                                }
//                            }
//                        }
//                        .contentShape(Rectangle()) // Enable hit testing for the entire card
//                        .onTapGesture {
//                            // Handle tap on the card here
//                        }
//                    }
//                }
//                .padding(15)
//            }
//            .scrollIndicators(.hidden)
//            .navigationTitle("Messages")
//        }
//    }
//
//    @ViewBuilder
//    func CardView(_ color: Color) -> some View {
//        HStack(spacing: 12) {
//            Circle()
//                .frame(width: 50, height: 50)
//
//            VStack(alignment: .leading, spacing: 6) {
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 80, height: 5)
//
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 60, height: 5)
//            }
//
//            Spacer(minLength: 0)
//        }
//        .foregroundStyle(.white.opacity(0.4))
//        .padding(.horizontal, 15)
//        .padding(.vertical, 10)
//        .background(color.gradient)
//    }
//}

//Custom swipe action
struct SwipeAction<Content: View>: View {
    var lastActionTint: Color

    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]

    let viewID = UUID()
    @State private var isEnabled: Bool = true
    @State private var swipeOffset: CGFloat = 0

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Rectangle()
                .fill(scheme == .dark ? Color.black : Color.white)
                .frame(maxWidth: .infinity)
                .opacity(swipeOffset < -100 ? 1 : 0)
                .background(
                    Rectangle()
                        .fill(lastActionTint)
                        .opacity(swipeOffset < -100 ? 1 : 0)
                )
                .offset(x: swipeOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            swipeOffset = value.translation.width
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut) {
                                swipeOffset = 0
                            }
                        }
                )

            HStack {
                content
            }
            .frame(maxWidth: .infinity)
            .clipShape(Rectangle().offset(x: swipeOffset))
        }
        .allowsHitTesting(isEnabled)
        .coordinateSpace(name: "scrollView")
    }

    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        HStack(spacing: 0) {
            ForEach(actions) { button in
                Button(action: {
                    Task {
                        isEnabled = false
                        resetPosition()
                        try? await Task.sleep(for: .seconds(0.25))
                        try? await Task.sleep(for: .seconds(0.1))
                        button.action()
                        isEnabled = true
                    }
                }, label: {
                    Image(systemName: button.icon)
                        .font(button.iconFont)
                        .foregroundStyle(button.iconTint)
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                })
                .buttonStyle(.plain)
                .background(button.tint)
            }
        }
    }
}

// Preference key to communicate swipe action button width
struct SwipeActionWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//offset key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//custom trasition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset (y: phase  == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

//Swipe direction
enum SwipeDirection {
    case leading
    case traling

    var alignment : Alignment {
        switch self {
        case .leading:
            return .leading
        case .traling:
            return .trailing
        }
    }
}

//ActionModel
struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}

//#Preview {
//    Home()
//}


