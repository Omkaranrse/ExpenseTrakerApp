//
//  NewExpenseView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 08/01/24.
//

import SwiftUI
import WidgetKit

struct TransactionView: View {
    
    //Env properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var editTransaction : Transaction?
    
    //View Properties
    @State private var title : String = ""
    @State private var remark : String = ""
    @State private var amount : Double = .zero
    @State private var dateAdded : Date = .now
    @State private var category : Category = .expenses
    //Random Tint
    @State var tint : TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                //preview transition card view
                TransactionCardView(transaction:
                        .init(
                            title: title.isEmpty ? "Title" : title,
                            remark: remark.isEmpty ? "Remarks" : remark,
                            amount: amount,
                            dateAdded: dateAdded,
                            category: category,
                            tintColor: tint
                        ))
                
                CustomSection("Title", "Title...", value: $title)
                CustomSection("Remarks", "remarks...", value: $remark)
                
                //Amount & Category
                VStack(alignment: .leading, spacing: 10){
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15){
                        HStack(spacing: 4){
                            
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)

                        
                        //Custom Check Box
                        CategoryCheckBox()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                }

            }
            .padding(15)
        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    save()
                } label: {
                    Text("Save")
                }
            }
        })
        .onAppear{
            if let editTransaction {
                //Load all data from exisiting transaction data
                title = editTransaction.title
                remark = editTransaction.remark
                dateAdded = editTransaction.dateAdded
                amount = editTransaction.amount
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                if let tint = editTransaction.tint{
                    self.tint = tint
                }
            }
        }
    }
    
    //Saving data
    func save(){
        //saving item to swiftData
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remark = remark
            editTransaction?.amount = amount
            editTransaction?.dateAdded = dateAdded
            editTransaction?.category = category.rawValue
        } else {
            let transaction = Transaction(title: title, remark: remark, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            
            context.insert(transaction)
        }
        
        //Dismissing the view
        dismiss()
        
        //updating the widget
        WidgetCenter.shared.reloadAllTimelines()

    }
    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10){
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    //Custom Check Box
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10){
            ForEach(Category.allCases, id: \.rawValue){ category in
                HStack(spacing: 5){
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    
    //number formater
    var numberFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
