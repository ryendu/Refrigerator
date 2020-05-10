//
//  IndivisualRefrigeratorView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData


struct IndivisualRefrigeratorView: View {
    var storageIndex: StorageLocation
    // use vision software to recognize the text from the image below.
    @State var image: Image? = nil
    @State var showCaptureImageView = false
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: []) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: []) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext


    var body: some View {
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    
                    
                    
                    HStack {
                        Text(storageIndex.wrappedStorageName)
                            .font(.custom("SF Compact Display", size: 38))
                        Button(action: {
                            self.refrigeratorViewModel.isInAddFridgeItemView.toggle()
                        }, label: {
                            Image("plus")
                                .renderingMode(.original)
                        })
                        Button(action: {
                            self.showCaptureImageView.toggle()
                        }, label: {
                            Image(systemName: "doc.text.viewfinder")
                            .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            
                        })
                    }
                    Text("swipe left to throw away and swipe right to eat").padding()
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(.gray)
                    ForEach(self.storageIndex.foodItemArray, id:\.self) { item in
                        RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                    }
                }
                .sheet(isPresented: $refrigeratorViewModel.isInAddFridgeItemView, content: {
                    AddFoodItemSheet(storage: self.storageIndex).environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
                })
                    
                
                    
                
            })
            
            if (showCaptureImageView) {
              CaptureImageView(isShown: $showCaptureImageView, image: $image)
            }
        }
            
        
    }
}


//struct IndivisualRefrigeratorView_Previews: PreviewProvider {
//    static var previews: some View {
//        IndivisualRefrigeratorView(storageLocationTitle: "Upstairs fridge").environmentObject(refrigerator)
//    }
//}



  struct CaptureImageView {
      
      /// MARK: - Properties
      @Binding var isShown: Bool
      @Binding var image: Image?
      
      func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
      }
  }

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

import SwiftUI
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
  @Binding var imageInCoordinator: Image?
  init(isShown: Binding<Bool>, image: Binding<Image?>) {
    _isCoordinatorShown = isShown
    _imageInCoordinator = image
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     imageInCoordinator = Image(uiImage: unwrapImage)
     isCoordinatorShown = false
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
  }
}
