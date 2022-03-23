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
    
    @State var viewModel = ItemsViewModel()
    var auth = Auth.auth()
    var body: some View {
        
        VStack{
            
            itemListView(viewModel: viewModel)
            AddItemView(viewModel: viewModel)
            
        }.onAppear(perform: {
            
            auth.signInAnonymously{ authResult, error in
                guard let _ = authResult?.user else {return}
                viewModel.listenToFirestore()
            }
            
            
        })
    }
    
    
    
}

struct itemListView: View{
    
    @ObservedObject var viewModel : ItemsViewModel
    
    var body: some View{
        
        List{
            
            ForEach(viewModel.items){ item in
                
                HStack{
                    Text(item.name).strikethrough(item.done)
                    Spacer()
                    Button(action: {
                        viewModel.toggleDone(item: item)
                        
                    }, label: {
                        Image(systemName: item.done ? "checkmark.square" : "square")
                    })
                    
                }
                
            }.onDelete(perform: { indexSet in
                viewModel.deleteItem(at: indexSet)
            })
            
        }
    }
}

struct AddItemView: View{
    
    var viewModel: ItemsViewModel
    @State var newItemName: String = ""
    
    var body: some View{
        
        HStack{
            
            TextField("Item Name", text: $newItemName)
                .padding()
            
            Button(action: {
                if newItemName != ""{
                    
                    viewModel.createItem(name: newItemName)
                    newItemName = ""
                    
                }else{
                    return
                }
                
                
            }, label: {
                Text("Add")
            }).padding()
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
