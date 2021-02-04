//
//  ContentView.swift
//  CoreDataIntro
//
//  Created by David Svensson on 2021-02-04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        
        VStack {
            List {
                ForEach(items) { item in
                    HStack {
                        if let name = item.name {
                            Text("\(name)")
                        }
                        Spacer()
                        Button(action: {
                            toggle(item: item)
                        }) {
                            Image(systemName: item.done ? "checkmark.square" : "square")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            HStack {
                #if os(iOS)
                EditButton()
                #endif
                Spacer()
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func toggle(item: Item) {
        item.done.toggle()  // = !item.done
        
        do {
            try viewContext.save()
        } catch {
            print("Error toggling object")
        }
        
    }
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = "morot"
            newItem.done = false
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            //offsets.map { items[$0] }.forEach(viewContext.delete)
            
            for index in offsets {
                let item = items[index]
                viewContext.delete(item)
            }
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
