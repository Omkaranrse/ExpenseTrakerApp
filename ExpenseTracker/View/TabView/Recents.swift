//
//  Recents.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 05/01/24.
//

import SwiftUI
import SwiftData

//struct Recents: View {
//    @Environment(\.modelContext) private var context
//
//    // User properties
//    @AppStorage("userName") private var userName: String = ""
//
//    // View properties
//    @State private var startDate: Date = .now.startOfMonth
//    @State private var endDate: Date = .now.endOfMonth
//    @State private var selectedCategory: Category = .expenses
//    @State private var showFilterView: Bool = false
//
//    // For animation
//    @Namespace private var animation
//
//    var body: some View {
//        GeometryReader {
//            //For animation purpose
//            let size = $0.size
//
//            NavigationStack {
//                ScrollView(.vertical) {
//                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
//                        Section {
//                            // Date filter button
//                            Button(action: {
//                                showFilterView = true
//                            }, label: {
//                                Text("\(format(date: startDate, formate: "dd - MMM yy")) to \(format(date: endDate, formate: "dd - MMM yy"))")
//                                    .font(.caption2)
//                                    .foregroundStyle(.gray)
//                            })
//                            .hSpacing(.leading)
//
//                            FilterTransaactionView(startDate: startDate, endDate: endDate) { transactions in
//                                // Card View
//                                CardView(
//                                    income: total(transactions, category: .income),
//                                    expense: total(transactions, category: .expenses)
//                                )
//
//                                // Custom Segmented Control
//                                customSegmentedControl()
//                                    .padding(.bottom, 10)
//
//                                // Transaction
//                                VStack(spacing: 10) {
//                                    ForEach(transactions.filter { $0.category == selectedCategory.rawValue }) { transaction in
//                                        NavigationLink(destination: TransactionView(editTransaction: transaction)) {
//                                            TransactionCardView(transaction: transaction)
//                                        }
//                                        .buttonStyle(.plain)
//                                    }
//                                }
//                                .transition(.opacity)
//                            }
//                        } header: {
//                            // Header View
//                            HeaderView(size)
//                        }
//                    }
//                    .padding(15)
//                }
//                .background(.gray.opacity(0.15))
//                .blur(radius: showFilterView ? 8 : 0)
//                .disabled(showFilterView)
//                .navigationDestination(for: Transaction.self) { transaction in
//                    TransactionView(editTransaction: transaction)
//                }
//            }
//            .overlay {
//                if showFilterView {
//                    DateFilterView(
//                        start: startDate,
//                        end: endDate,
//                        onSubmit: { start, end in
//                            startDate = start
//                            endDate = end
//                            showFilterView = false
//                        }, onClose: {
//                            showFilterView = false
//                        })
//                        .transition(.move(edge: .leading))
//                }
//            }
//            .animation(.snappy, value: showFilterView)
//        }
//    }
//    
//    
//    //Header View
//    @ViewBuilder
//    func HeaderView(_ size : CGSize) -> some View {
//        HStack(spacing: 10) {
//            VStack(alignment: .leading, spacing: 15) {
//                Text("Welcome!")
//                    .font(.title.bold())
//
//                if !userName.isEmpty {
//                    Text(userName)
//                        .font(.callout)
//                        .foregroundStyle(.gray)
//                }
//            }
//            .visualEffect { content, geometryProxy in
//                content
//                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
//            }
//
//            Spacer(minLength: 0)
//
//            NavigationLink {
//                TransactionView()
//            } label: {
//                Image(systemName: "plus")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .frame(width: 45, height: 45)
//                    .background(appTint.gradient, in: .circle)
//                    .contentShape(.circle)
//            }
//        }
//        .padding(.bottom, userName.isEmpty ? 10 : 5)
//        .background {
//            VStack(spacing: 0) {
//                Rectangle()
//                    .fill(.ultraThinMaterial)
//
//                Divider()
//            }
//            .visualEffect { content, geometryProxy in
//                content
//                    .opacity(headerBGOpacity(geometryProxy))
//            }
//            .padding(.horizontal, -15)
//            .padding(.top, -(safeArea.top + 15))
//        }
//    }
//    
//    //Segmented Control
//       @ViewBuilder
//       func customSegmentedControl() -> some View {
//           HStack(spacing: 0){
//               ForEach(Category.allCases, id: \.rawValue){ category in
//                   Text(category.rawValue)
//                       .hSpacing()
//                       .padding(.vertical, 10)
//                       .background{
//                           if category == selectedCategory {
//                               Capsule()
//                                   .fill(.background)
//                                   .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
//                           }
//                       }
//                       .contentShape(.capsule)
//                       .onTapGesture {
//                           withAnimation(.snappy) {
//                               selectedCategory = category
//                           }
//                       }
//               }
//           }
//           .background(.gray.opacity(0.15), in: .capsule)
//           .padding(.top, 5)
//       }
//
//
//    // Format function
//    func format(date: Date, formate: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = formate
//        return dateFormatter.string(from: date)
//    }
//
//    // Header BG Opacity function
//    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
//        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
//        return minY > 0 ? 0 : (-minY / 15)
//    }
//
//    // Header Scale function
//    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
//        let minY = proxy.frame(in: .scrollView).minY
//        let screenHeight = size.height
//
//        let progress = minY / screenHeight
//        let scale = (min(max(progress, 0), 1)) * 0.4
//
//        return 1 + scale
//    }
//}
//
//#Preview {
//    ContentView()
//}

//import SwiftUI
//import SwiftData

struct Recents: View {
    @Environment(\.modelContext) private var context
    @AppStorage("userName") private var userName: String = ""
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Category = .expenses
    @State private var showFilterView: Bool = false
    @Namespace private var animation

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            Button(action: {
                                showFilterView = true
                            }, label: {
                                Text("\(format(date: startDate, formate: "dd - MMM yy")) to \(format(date: endDate, formate: "dd - MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                            .hSpacing(.leading)

                            FilterTransaactionView(startDate: startDate, endDate: endDate) { transactions in
                                // Card View
                                CardView(
                                    income: total(transactions, category: .income),
                                    expense: total(transactions, category: .expenses)
                                )

                                // Custom Segmented Control
                                customSegmentedControl()
                                    .padding(.bottom, 10)

                                // Transaction
                                VStack(spacing: 10) {
                                    ForEach(transactions.filter { $0.category == selectedCategory.rawValue }) { transaction in
                                        NavigationLink(destination: TransactionView(editTransaction: transaction)) {
                                            TransactionCardView(transaction: transaction)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .transition(.opacity)
                            }
                        } header: {
                            HeaderView(geometry.size)
                        }
                    }
                    .padding(15)
                }
                .background(Color.gray.opacity(0.15))
                .blur(radius: showFilterView ? 8 : 0)
                .disabled(showFilterView)
                .navigationDestination(for: Transaction.self) { transaction in
                    TransactionView(editTransaction: transaction)
                }
            }
            .overlay {
                if showFilterView {
                    DateFilterView(
                        start: startDate,
                        end: endDate,
                        onSubmit: { start, end in
                            startDate = start
                            endDate = end
                            showFilterView = false
                        }, onClose: {
                            showFilterView = false
                        })
                        .transition(.move(edge: .leading))
                }
            }
            .animation(.easeInOut, value: showFilterView)
        }
    }

    //Segmented Control
       @ViewBuilder
       func customSegmentedControl() -> some View {
           HStack(spacing: 0){
               ForEach(Category.allCases, id: \.rawValue){ category in
                   Text(category.rawValue)
                       .hSpacing()
                       .padding(.vertical, 10)
                       .background{
                           if category == selectedCategory {
                               Capsule()
                                   .fill(.background)
                                   .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                           }
                       }
                       .contentShape(.capsule)
                       .onTapGesture {
                           withAnimation(.snappy) {
                               selectedCategory = category
                           }
                       }
               }
           }
           .background(.gray.opacity(0.15), in: .capsule)
           .padding(.top, 5)
       }


    // Format function
    func format(date: Date, formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }

    // Header BG Opacity function
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }

    // Header Scale function
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height

        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.4

        return 1 + scale
    }
       //Header View
       @ViewBuilder
       func HeaderView(_ size : CGSize) -> some View {
           HStack(spacing: 10) {
               VStack(alignment: .leading, spacing: 15) {
                   Text("Welcome!")
                       .font(.title.bold())
   
                   if !userName.isEmpty {
                       Text(userName)
                           .font(.callout)
                           .foregroundStyle(.gray)
                   }
               }
               .visualEffect { content, geometryProxy in
                   content
                       .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
               }
   
               Spacer(minLength: 0)
   
               NavigationLink {
                   TransactionView()
               } label: {
                   Image(systemName: "plus")
                       .font(.title3)
                       .fontWeight(.semibold)
                       .foregroundStyle(.white)
                       .frame(width: 45, height: 45)
                       .background(appTint.gradient, in: .circle)
                       .contentShape(.circle)
               }
           }
           .padding(.bottom, userName.isEmpty ? 10 : 5)
           .background {
               VStack(spacing: 0) {
                   Rectangle()
                       .fill(.ultraThinMaterial)
   
                   Divider()
               }
               .visualEffect { content, geometryProxy in
                   content
                       .opacity(headerBGOpacity(geometryProxy))
               }
               .padding(.horizontal, -15)
               .padding(.top, -(safeArea.top + 15))
           }
       }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Recents()
    }
}
