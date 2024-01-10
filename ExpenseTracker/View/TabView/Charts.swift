//
//  Charts.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 05/01/24.
//

import SwiftUI
import Charts
import SwiftData

struct Charts: View {
    
    //view properties
    @Query(animation : .snappy) private var transactions : [Transaction]
    @State private var chartGroups : [ChartGroup] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(chartGroups){ group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, formate:"MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            
                            NavigationLink{
                                ListOfExpenses(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)

                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear{
                //Creating chart group
                createChartGroup()
        }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        //Chart view
        Chart{
            ForEach(chartGroups){ group in
                ForEach(group.categories){ chart in
                    BarMark(
                        x: .value("Month", format(date: group.date, formate: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        //Making chart scrollable
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis(content: {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel{
                    Text(axisLabel(doubleValue))
                }
            }
        })
        //Foreground Colors
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroup(){
        Task.detached(priority: .high){
            let calendar = Calendar.current
            
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                
                return components
            }
            
            //sorting Groups by dates
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let expense = dict.value.filter({ $0.category == Category.expenses.rawValue })
                
                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .expenses)
                
                return .init(
                    date: date,
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue,
                    categories: [
                        .init(totalValue: incomeTotalValue, category: .income),
                        .init(totalValue: expenseTotalValue, category: .expenses)
                    ]
                )
            }
            
            //Ui must be updated on main thread
            await MainActor.run{
                self.chartGroups = chartGroups
            }
        }
    }
    
    func axisLabel(_ value : Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}

//List of transaction for the selected month
struct ListOfExpenses : View {
    
    let month : Date
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Section{
                    FilterTransaactionView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transaction in
                        ForEach(transaction){ transaction in
                            NavigationLink{
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)

                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
                
                Section{
                    FilterTransaactionView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expenses) { transaction in
                        ForEach(transaction){ transaction in
                            NavigationLink{
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
            }
            .padding(15)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, formate: "MMM yy"))
    }
}

#Preview {
    Charts()
}
