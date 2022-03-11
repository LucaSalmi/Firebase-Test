//
//  ContentView.swift
//  Firebase Test
//
//  Created by Luca Salmi on 2022-03-11.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ContentView: View {
    
    let db = Firestore.firestore()
    @State var items = [Item]()
    @State var newItemName: String = ""
    
    var body: some View {
        
        VStack{
            
            List{
                ForEach(items){ item in
                    
                    HStack{
                        Text(item.name)
                        Spacer()
                        Button(action: {
                            if let id = item.id{
                                
                                db.collection("Items").document(id).updateData(["done":!item.done])
                            }
                            
                        }, label: {
                            Image(systemName: item.done ? "checkmark.square" : "square")
                        })
                        
                    }
                    
                }.onDelete(perform: { IndexSet in
                    for index in IndexSet{
                        let item = items[index]
                        if let id = item.id{
                            db.collection("Items").document(id).delete()
                        }
                    }
                })
                
                
            }
            HStack{
                
                TextField("Item Name", text: $newItemName)
                    .padding()
                
                Button(action: {
                    if newItemName != ""{
                        
                        addItem(name: newItemName)
                        newItemName = ""
                    }else{
                        return
                    }
                    
                    
                }, label: {
                    Text("Add")
                }).padding()
                    .onAppear(perform: {
                    listenToFirestore()
                })
            }
            
        }
    }
    
    func addItem(name: String){
        
        let newItem = Item(name: name)
        
        do{
            _ = try db.collection("Items").addDocument(from: newItem)
        }catch{
            print("firebase error")
        }
    }
    
    func listenToFirestore(){
        
        db.collection("Items").addSnapshotListener{ snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err{
                print("error fetching documents \(err)")
            }else{
                
                items.removeAll()
                
                for document in snapshot.documents{
                    
                    let result = Result{
                        try document.data(as: Item.self)
                    }
                    
                    switch result {
                    case .success(let item):
                        items.append(item)
                    case .failure(let error):
                        print("error deconding Item\(error)")
                    }
                }
            }
        }
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
