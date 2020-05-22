//
//  IndivisualRefrigeratorView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import VisionKit
import Vision
import Combine
import UIKit



struct IndivisualRefrigeratorView: View {
    var storageIndex: StorageLocation
    // use vision software to recognize the text from the image below.
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    
    @State var image: UIImage? = nil
    @State var foodsToDisplay = [refrigeItem]()
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    //TODO: WHEN I GET BACK FIX THIS SO THAT IT ACTRUALLY SORTS THIS STUFF
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showEatActionSheet = false
    @State var percentDone = 0.0
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    @State var showingView = "fridge"
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
                            print("yaya")
                            self.showingView = "scanner"
                            
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
            
            if self.showingView == "scanner" {
                ScanningView(foodsToDisplay: $foodsToDisplay, percentDone: $percentDone, showingView: $showingView).environmentObject(refrigerator)
            } else if self.showingView == "results" {
                ExamineRecieptView(image: UIImage(cgImage: self.refrigeratorViewModel.images[0]), storageIndex: self.storageIndex, foodsToDisplay: self.foodsToDisplay, percentDone: self.refrigeratorViewModel.percentDone)
            }else {
                
            }
        }
        
        
    }
}





//struct CaptureImageView {
//
//    /// MARK: - Properties
//    @Binding var isShown: Bool
//    @Binding var image: UIImage?
//    @Binding var gotImage: Bool
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(isShown: $isShown, image: $image, gotImage: $gotImage)
//    }
//}
//
//extension CaptureImageView: UIViewControllerRepresentable {
//    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .camera
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController,
//                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
//
//    }
//}
//
//class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    @Binding var isCoordinatorShown: Bool
//    @Binding var imageInCoordinator: UIImage?
//    @Binding var gotImage: Bool
//    init(isShown: Binding<Bool>, image: Binding<UIImage?>, gotImage: Binding<Bool>) {
//        _isCoordinatorShown = isShown
//        _imageInCoordinator = image
//        _gotImage = gotImage
//    }
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//        imageInCoordinator = unwrapImage
//        print("got image")
//        gotImage = true
//        isCoordinatorShown = false
//
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isCoordinatorShown = false
//        gotImage = false
//        print("gotimage false")
//    }
//
//}


//struct ViewControllerWrapper: UIViewControllerRepresentable {
//
//    typealias UIViewControllerType = DocumentScanningViewController
//
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper>) -> ViewControllerWrapper.UIViewControllerType {
//        return DocumentScanningViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: ViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerWrapper>) {
//
//    }
//}
// Ian is the Best

final class RecognizedText: ObservableObject, Identifiable {
    
    let willChange = PassthroughSubject<RecognizedText, Never>()
    
    var value: String = "Scan document to see its contents" {
        willSet {
            willChange.send(self)
        }
    }
    
}

struct ScanningView: UIViewControllerRepresentable {
    
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Binding var foodsToDisplay: [refrigeItem]
    @Binding var percentDone: Double
    @Binding var showingView: String
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(foodsToDisplay: $foodsToDisplay, refrigeratorViewModel: refrigeratorViewModel, percentDone: $percentDone, showingView: $showingView)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanningView>) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScanningView>) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        var foodsToDisplay: Binding<[refrigeItem]>
        private let textRecognizer: TextRecognizer
        var refrigeratorViewModel: RefrigeratorViewModel
        var percentDone: Binding<Double>
        var showingView: Binding<String>
        
        init(foodsToDisplay: Binding<[refrigeItem]>, refrigeratorViewModel: RefrigeratorViewModel, percentDone: Binding<Double>, showingView: Binding<String>) {
            self.showingView = showingView
            self.foodsToDisplay = foodsToDisplay
            self.percentDone = percentDone
            self.refrigeratorViewModel = refrigeratorViewModel
            textRecognizer = TextRecognizer(foodsToDisplay: foodsToDisplay, percentDone: percentDone)
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    self.refrigeratorViewModel.images.append(cgImage)
                }
            }
            
            self.showingView.wrappedValue = "results"
            print(self.showingView.wrappedValue)
            print(self.showingView)
            textRecognizer.recognizeText(from: self.refrigeratorViewModel.images)
            
        }
        
    }
    
}
public struct TextRecognizer {
    
    
    @Binding var foodsToDisplay: [refrigeItem]
    @Binding var percentDone: Double
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                         qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    let newArrayOfFoods = ["oranges" : "🍊", "eggs":"🥚", "mandarines" : "🍊"]
    func recognizeText(from images: [CGImage]) {
        var tmp = ""
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            // Concatenate the recognised text from all the observations.
            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else { continue }
                for (word,emoji) in self.newArrayOfFoods {
                    if bestCandidate.string.lowercased().contains(word) {
                        self.foodsToDisplay.append(refrigeItem(icon: emoji, title: bestCandidate.string, daysLeft: 7))
                        print("found and appended: \(bestCandidate.string)")
                        break
                    }else {
                        print("found but not appended: \(bestCandidate.string)")
                    }
                }
            }
        }
        textRecognitionRequest.usesLanguageCorrection = true
        textRecognitionRequest.minimumTextHeight = 0
        textRecognitionRequest.progressHandler = { (request, value, error) in
            self.percentDone = value
        }
        textRecognitionRequest.recognitionLevel = .accurate
        for image in images {
            let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            
            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
            tmp += "\n\n"
        }
    }
    
}

