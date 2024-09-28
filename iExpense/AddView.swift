//
//  AddView.swift
//  iExpense
//
//  Created by Никита Мартьянов on 14.02.24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Add new Expen"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "BYN"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .toolbar {
                Button("Save") {
                    let items = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(items)
                    dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
