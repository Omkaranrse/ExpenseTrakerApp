//
//  FilterTransaactionView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 09/01/24.
//

import SwiftUI
import SwiftData

//Custom View
struct FilterTransaactionView<Content : View >: View {
    
    var content : ([Transaction]) -> Content
    
    @Query(animation: .snappy) private var transaction : [Transaction]
    
    init(category : Category?, searchText : String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        //Custom predicate
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) || transaction.remark.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : transaction.category == rawValue)
            
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)] , animation: .snappy)
        
        self.content = content
    }
    
    init(startDate : Date, endDate : Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        //Custom predicate
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)] , animation: .snappy)
        
        self.content = content
    }
    
    //optional for your customized usage
    init(startDate : Date, endDate : Date, category : Category?, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        //Custom predicate
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transaction = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)] , animation: .snappy)
        
        self.content = content
    }
    
    var body: some View {
        content(transaction)
    }
}

