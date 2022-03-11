//
//  ItemsViewModel.swift
//  Firebase Test
//
//  Created by Luca Salmi on 2022-03-11.
//

import Foundation
import Firebase

class ItemsViewModel: ObservableObject{
    
    @Published var items = [Item]()
    let db = Firestore.firestore()
    
    func createItem(name: String){
        
        let newItem = Item(name: name)
        
        do{
            _ = try db.collection("Items").addDocument(from: newItem)
        }catch{
            print("firebase error")
        }
    }
    
    func listenToFirestore(){
        
        db.collection("Items").addSnapshotListener{ [self] snapshot, err in
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
    
    
    func toggleDone(item: Item){
        
        if let id = item.id{
            
            db.collection("Items").document(id).updateData(["done":!item.done])
        }
        
    }
    
    func deleteItem(at indexSet: IndexSet){
        
            for index in indexSet{
                let item = items[index]
                if let id = item.id{
                    db.collection("Items").document(id).delete()
                }
            }
        
    }
    
    
    
    
    
    
}
