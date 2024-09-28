//
//  ContentView.swift
//  iExpense
//
//  Created by Никита Мартьянов on 13.02.24.
//

import SwiftUI

struct ExpenseItem : Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personalExpenses: [ExpenseItem] {
          return items.filter { $0.type == "Personal" }
      }
      
      var businessExpenses: [ExpenseItem] {
          return items.filter { $0.type == "Business" }
      }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.personalExpenses, id:\.id) { item in
                    Section("Personal") {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "BYN"))
                                .foregroundStyle(colorExpense(amount: item.amount))
                            
                        }
                    }
                }
                .onDelete(perform: removeItems)
                
                Section("Business") {
                    ForEach(expenses.businessExpenses, id:\.id) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "BYN"))
                                    .foregroundStyle(colorExpense(amount: item.amount))
                                
                            }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add") {
                    AddView( expenses: expenses)
                }
            }
        }
    }
    
    func removeItems(at offsets : IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func colorExpense(amount: Double) -> Color {
        if amount <= 10 {
                   return Color.green
               } else if amount <= 100 {
                   return Color.blue
               } else {
                   return Color.red
               }
    }
}

#Preview {
    ContentView()
}
