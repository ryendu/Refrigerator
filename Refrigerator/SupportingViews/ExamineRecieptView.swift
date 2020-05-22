//
//  ExamineRecieptView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/18/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit
import CoreML
import NaturalLanguage
import Foundation
import UIKit



struct ExamineRecieptView: View {
    let arrayOfFoods = ["oranges", "eggs", "bread", "cake", "watermellon", "grapes", "chicken wings", "mug cake", "cup cake", "pizza", "hot dog", "caviar", "parmesean", "chesse", "bbq", "pork", "eggs", "milk", "soy milk", "creme caremal", "brocolie", "onion", "donut", "cherries", "green apple", "banana", "carrot", "pumpkin pie", "pastrys", "cookies", "mandarine", "spinach", "bok choi", "ramen", "noodles", "chipotle", "taco", "burrito", "sugar", "mango", "asparagus", "acorn squash", "almond", "apple sauce", "asian noodles", "antalope", "tuna", "apple juice", "avacado roll", "bacon", "black beans", "bagels", "baked beans", "bbq", "beer", "fish", "cabbage", "celery", "cat fish", "chips", "chocolate", "chowder", "clams", "coffee", "corn", "crab", "curry", "cereal", "kimchi", "dates", "dips", "duck", "dumplings", "donuts", "eggs", "enchilada", "eggrolls", "english muffins", "muffins", "edimame", "sushi", "fagida", "fondue", "french toast", "french dip", "garlic", "ginger", "gnocchi", "goose", "granola", "green beans", "beens", "guacamole", "grahm crakers", "ham", "hamburger", "honey", "hashbrowns", "hikurolls", "hummus", "irish stew", "indian food", "italian bread", "jam", "jelly", "jerky", "jalapeno", "kale", "ketchup", "kiwi", "beans", "kingfish", "lobster", "lamb", "lasagna", "meatballs", "moose", "milk", "milkshake", "noodles", "ostritch", "pizza", "peperoni", "pancakes", "quesadila", "spaghetti", "tatter tots", "toast", "udon noodles", "udon", "venison", "waffles", "wasabi", "wine", "walnuts", "yougart", "ziti", "zucchini", "ugli", "tangerine", "oatmeal", "goat cheese", "mushrooms", "pears", "rasberry", "strawberrys", "rasberyys", "strawberry", "mango", "pinenuts", "cherries", "cherry", "olives", "cottage cheese", "tuna", "refried beans", "bell peppers", "salmon", "pinnaple", "sweet potatos", "rice cake", "mochi", "beans", "pinto beans", "coconut", "purple yam", "urchins", "ugali", "ukarian rools", "umbrella fruit", "papya", "steak", "extreme candy", "hot sauce", "xo sauce", "shrimp", "xiami", "xiangcai", "parsly", "sausage", "tomato", "ximi powder", "tapioca perals", "tortillas", "vanilla", "fries", "mushroom", "radish", "yam", "oranges", "potato", "orange", "blueberrys", "blackberrys", "brandy", "butter", "pork", "beets", "cider", "cauliflower", "clam", "cramberries", "dressing", "doritos", "chettos", "takis", "fritos", "french fries", "juice", "lettus", "mayonase", "mozerella", "macaroonie", "mustard", "meatloaf", "popcorn", "peppers", "peaches", "pretzles", "popsicle", "pomogrant", "quail", "rum", "rasins", "ravioli", "sage", "salmon", "subway sandwich", "subway", "tostata", "turkey", "left overs", "frosting", "fudge", "flour", "gravy", "grapefruit", "ground beef", "hazelnut", "asparagus", "almonds", "burgurs", "crisps", "eggs", "kiwi", "kale", "meatballs", "noodles", "turnip", "pasta", "appracot", "breadfruit", "bamboo sheets", "buck wheat", "cucumber", "lemons", "red velvet cake", "star fruit", "dragonfruit", "peanut butter", "oreo pie", "cheese cake", "brownies", "sauce", "pickels", "peas", "rice", "chinese food", "japanese food", "beef stew", "chicken soup", "chicken noodle soup", "sweet potatos", "dandaline", "grape", "brussel sprouts", "corn salad", "dill", "lettuce", "pak choy", "pea", "poke", "sea beet", "sea kale", "shepherds purse", "turnip greends", "water grass", "wheatgrass", "bittermellon", "eggplant", "olive fruit", "pumpkin", "squash", "sweet pepper", "winter mellon", "chick peas", "common peas", "indian pea", "peanut", "ricebean", "soybean", "chives", "garlic chives", "lemongrass", "leek", "lotus root", "topal", "peral onion", "potato onion", "spring onion", "green onion", "mandrian wild rice", "bamboo shoot", "beetroot", "canna", "cassava", "horseradish", "parshnip", "turnip", "tea", "tigernut", "sea lettuce", "ability", "about", "biscut", "meat", "meat", "lamb", "hot pot", "beef", "pork chop", "pannacota", "pancake mix", "wongtons", "frozen dumplings", "dumplings", "sourdough", "sourdough bread", "grahm cracker", "macaroni", "macaroni and cheese", "chicken alfredo", "mochi icecream", "pineapple", "pineapple cake", "banana bread", "blueberry muffins", "aloe juice", "aloe vera drink", "smoothie", "macaroon", "marinara sauce", "mini potatos", "honeycrisp apples", "cilantro", "japanese pumpkin", "basil", "frozen mango", "dried mango", "beef jerky", "tangerines", "clementines", "sugar canes", "honeydew", "asian pears", "congee", "yellow onions", "baby carrots", "grape tomatoes", "tomatoes on the vine", "squash yellow", "white mushrooms", "sweet onions", "romanine lettuce", "sweet corn cobs", "corn", "shallot", "brocolie florets", "golden potatos", "russet potatoes", "chayote squash", "peeled garlic", "napa", "spaghetti squash", "boston lettuce", "diced yellow onions", "butternut squash", "curly mustard", "lime", "lemons", "seedless grapes", "red mango", "seedless watermellon", "navel oranges", "granny smith apples", "gala apples", "seeded red watermellon", "barlett pear", "bosc pear", "sungold kiwi", "honeydew melon", "lunchables", "ground beef", "ground pork", "smoked bacon", "cracker crunchers", "nachos", "chicken drumsticks", "mashed potatos", "ground turkey", "italian sausage", "chinese sausage", "sausage", "shrimp", "frozen shrimp", "tuna", "frito-lay", "tortilla chips", "hot dog buns", "ramen noodle soup", "potato chips", "ritz stacks origional crackers", "barbecue sauce", "toasted coconut chips", "coconut", "white sliced bread", "canned green beans", "oreos", "taco seasoning", "flamin hot cheetos", "diced tomatos", "chili", "shells and cheese dinner", "king hawaiians origional sweet rolls", "beef ravioli", "burger buns", "honey maid grahm crackers", "cheez it", "cream of chicken soup", "pringles", "nutter puffs", "penne pasta", "bbq potato chips", "ranch", "tomato paste", "chicken broth", "vegtable broth", "fat free skim milk", "chocolate milk", "sharp cheddar cheese", "cheddar", "yougart", "greek yougart", "pasteurized milk", "egg whites", "mexican style blend", "american cheese", "coffe-mate french vanilla liquid coffee creamer", "coffee creamer", "sour cream", "unsalted butter", "salted butter", "wipped cream", "cream cheese", "half and half", "half & half", "heavy cream", "cinnamon rolls", "chobani greek yougart", "almond milk", "soy milk", "oat milk", "buttermilk biscuts", "macaroni salad", "mustard potato salad", "chicken teners", "fresh mozerella", "feta cheese", "pretzel", "dinner rools", "crossants", "mini crossants", "savory butter rolls", "choclate chip cookies", "m&m cookies", "flat bread", "desert shells", "donettes", "mini donuts", "apple pie", "garlic naan flatbread", "brownies", "bakery fresh goodness mini cinnamon rolls", "sugar cookies", "reese\'s peanut butter cups", "kitkat", "m&ms", "spinach", "Cappuccino", "bacon", "sunnyside up", "cinnamon"]
    let newArrayOfFoods = ["oranges" : "🍊", "eggs":"🥚"]
    var image: UIImage
    var storageIndex: StorageLocation
    var foodsToDisplay: [refrigeItem]
    func getRandomEmoji () -> String{
        let listOfEmojis = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚"),emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢"),emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
        return listOfEmojis.randomElement()!.emoji
        
        }
    var percentDone: Double
    
    var body: some View {
        ZStack{
        ScrollView(.vertical, showsIndicators: false, content: {
            ZStack{
            VStack {
                HStack{
                    NavigationLink(destination: RefrigeratorView(), label: {
                        Image(systemName: "chevron.left")
                        .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 19, height: 29)
                            .padding()
                    })
                Spacer()
                }
                
                Image(uiImage: image)
                .resizable()
                .padding()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                Text("Analyzing Your Image...")
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Text("\(percentDone * 100)% done")
                //TODO: change to only showing foods from the text detected
                ForEach(foodsToDisplay, id: \.self) { food in
                    DetectItemCell(icon: food.icon, title: food.title, lastsFor: food.daysLeft)
                }
                Spacer()
            }.onAppear(perform: {
                print("appearing")
            })
                
            }
            
        }
        )
        }.background(Rectangle()
        .foregroundColor(.white))
        .navigationBarBackButtonHidden(true)
        
    }
}






//class DocumentScanningViewController: UIViewController, ObservableObject {
//
//    @Published var scannedImage: UIImage? = nil
//    @Published var showingResult = false
//    @Published var scannedResults = [VNRecognizedTextObservation]()
//    static let businessCardContentsIdentifier = "businessCardContentsVC"
//    static let receiptContentsIdentifier = "receiptContentsVC"
//    static let otherContentsIdentifier = "otherContentsVC"
//
//    enum ScanMode: Int {
//        case receipts
//        case businessCards
//        case other
//    }
//
//
//
//
//    var scanMode: ScanMode = .receipts
//    var textRecognitionRequest = VNRecognizeTextRequest()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("doccument view did load")
//        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
//            if let results = request.results, !results.isEmpty {
//                if let requestResults = request.results as? [VNRecognizedTextObservation] {
//                    DispatchQueue.main.async {
//                        self.scannedResults = requestResults
//                        for observation in requestResults {
//                            print(observation)
//                        }
//                    }
//                }
//            }
//        })
//        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
//        textRecognitionRequest.recognitionLevel = .accurate
//        textRecognitionRequest.usesLanguageCorrection = true
//        DispatchQueue.main.async { self.scan() }
//    }
//
//    func scan() {
//        self.scanMode = .receipts
//        let documentCameraViewController = VNDocumentCameraViewController()
//        documentCameraViewController.delegate = self
//        present(documentCameraViewController, animated: true)
//        print("scan and presenting documentCamreaViewController")
//    }
//
//    func processImage(image: UIImage) {
//        guard let cgImage = image.cgImage else {
//            print("Failed to get cgimage from input image")
//            return
//        }
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        do {
//            try handler.perform([textRecognitionRequest])
//        } catch {
//            print(error)
//        }
//    }
//}
//
//extension DocumentScanningViewController: VNDocumentCameraViewControllerDelegate {
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        print("got results")
//        self.scannedImage = scan.imageOfPage(at: 0)
//        self.showingResult = true
//        DispatchQueue.main.async {
//
//            self.dismiss(animated: true, completion: {
//                self.dismiss(animated: true)
//            })
//        }
//
//    }
//    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//        DispatchQueue.main.async {
//
//            self.dismiss(animated: true, completion: {
//            })
//
//        }
//    }
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//        DispatchQueue.main.async {
//
//            self.dismiss(animated: true)
//        }
//        print(error)
//    }
//}
//
//
//
