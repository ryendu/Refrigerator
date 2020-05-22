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
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @State var image: UIImage? = nil
    @State var showCaptureImageView = false
    @State var gotImage = false
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    //TODO: WHEN I GET BACK FIX THIS SO THAT IT ACTRUALLY SORTS THIS STUFF
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showEatActionSheet = false

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
                    Text("Long hold for more options").padding()
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(.gray)
                    
                    ForEach(self.storageIndex.foodItemArray, id:\.self) { item in
                        
                        RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince))
                        .gesture(LongPressGesture()
                            .onEnded({ i in
                                self.showEatActionSheet.toggle()
                            })
                        )
                            //TODO: Make a diffrence between eat all and throw away
                            .actionSheet(isPresented: self.$showEatActionSheet, content: {
                           ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                               .default(Text("Eat All"), action: {
                                 self.managedObjectContext.delete(item)
                                   try? self.managedObjectContext.save()
                           })
                            ,.default(Text("Throw Away"), action: {
                                self.managedObjectContext.delete(item)
                                try? self.managedObjectContext.save()
                            })
                            
                            ,.default(Text("Cancel"))
                           ])
                        })
                            
                    }
                }
            
                .sheet(isPresented: $refrigeratorViewModel.isInAddFridgeItemView, content: {
                    AddFoodItemSheet(storage: self.storageIndex).environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
                })
                    
                
                    
                
            })
            
            if (showCaptureImageView) {
              CaptureImageView(isShown: $showCaptureImageView, image: $image, gotImage: $gotImage)
            } else if gotImage{
                ExamineRecieptView(image: $image, storageIndex: storageIndex)
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
      @Binding var image: UIImage?
    @Binding var gotImage: Bool
      
      func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, gotImage: $gotImage)
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

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
  @Binding var imageInCoordinator: UIImage?
  @Binding var gotImage: Bool
    init(isShown: Binding<Bool>, image: Binding<UIImage?>, gotImage: Binding<Bool>) {
    _isCoordinatorShown = isShown
    _imageInCoordinator = image
    _gotImage = gotImage
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     imageInCoordinator = unwrapImage
    print("got image")
    gotImage = true
     isCoordinatorShown = false
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
    gotImage = false
    print("gotimage false")
  }
    
}


