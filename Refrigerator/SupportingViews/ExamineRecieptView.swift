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
import Firebase
import UserNotifications


struct ExamineRecieptView: View {
    let newArrayOfFoods:KeyValuePairs = ["bread":"🍞", "cake":"🎂", "watermelon":"🍉", "grapes":"🍇", "chicken wings":"🍗", "mug cake":"🧁", "cup cake":"🧁", "pizza":"🍕", "hot dog":"🌭", "caviar":"🐟", "parmesan":"🧀", "cheese":"🧀", "bbq":"🍖", "eggs":"🥚", "milk":"🥛", "creme caramel":"🍮", "broccoli":"🥦", "onion":"🧅", "donut":"🍩", "cherries":"🍒", "green apple":"🍏", "banana":"🍌", "carrot":"🥕", "pumpkin pie":"🥧", "pastries":"🥐", "cookies":"🍪", "mandarine":"🍊", "bok choi":"🥬", "ramen":"🍜", "chipotle":"🥙", "taco":"🌮", "burrito":"🌯", "sugar":"🍬", "mango":"🥭", "asparagus":"🌲", "acorn squash":"🌰", "almond":"🌰", "apple sauce":"🍎", "asian noodles":"🍜", "cantaloupe":"🍈", "tuna":"🐟", "apple juice":"🧃", "avocado roll":"🥑", "black beans":"🌰", "bagels":"🥐", "baked beans":"🌰", "beer":"🍺", "fish":"🐠", "cabbage":"🥬", "celery":"🥬", "cat fish":"🐟", "chips":"🍟", "chocolate":"🍫", "chowder":"🍲", "clams":"🦪", "coffee":"☕️", "crab":"🦀", "curry":"🍛", "cereal":"🥣", "kimchi":"🇰🇷", "dates":"🌰", "dips":"🥣", "duck":"🦆", "donuts":"🍩", "enchilada":"🥘", "egg rolls":"🍳", "english muffins":"🧁", "muffins":"🧁", "edamame":"🥬", "sushi":"🍣", "fondue":"🧀", "french toast":"🍞", "garlic":"🧄", "ginger":"🥕", "gnocchi":"🍝", "goose":"🦆", "granola":"🍫", "green beans":"🌰", "beans":"🌰", "guacamole":"🥑", "graham crackers":"🍘", "ham":"🐖", "hamburger":"🍔", "honey":"🍯", "hash browns":"🍟", "hikurolls":"🥞", "hummus":"🥫", "irish stew":"🍲", "indian food":"🇮🇳", "italian bread":"🥖", "jam":"🥫", "jelly":"🥫", "jerky":"🥓", "jalapeno":"🌶", "kale":"🥬", "ketchup":"🥫", "kiwi":"🥝", "kingfish":"🐠", "lobster":"🦞", "lamb":"🐑", "lasagna":"🍝", "moose":"🦌", "milkshake":"🥤", "peperoni":"🍕", "pancakes":"🥞", "quesadilla":"🌮", "spaghetti":"🍝", "tater tots":"🍟", "toast":"🍞", "udon noodles":"🍜", "udon":"🍜", "venison":"🥩","waffles":"🧇", "wasabi":"🍣", "wine":"🍷", "walnuts":"🌰", "ziti":"🍝", "zucchini":"🥒", "ugli":"🍊", "tangerine":"🍊","oatmeal":"🥣", "goat cheese":"🧀", "mushrooms":"🍄", "pears":"🍐", "raspberry":"🍇", "strawberry":"🍓", "fig":"🥭", "passion fruit":"🍊", "pineuts":"🌰", "olives":"🍐", "cottage cheese":"🧀", "refried beans":"🌰", "bell peppers":"🌶", "salmon":"🐠", "rice cake":"🍙", "mochi":"🍡", "pinto beans":"🌰", "purple yam":"🍠", "urchins":"🐡", "ukraine rolls":"🥞", "umbrella fruit":"🍐", "papaya":"🥭", "steak":"🥩", "extreme candy":"🍬", "hot sauce":"🌶", "xo sauce":"🥫", "parsley":"🥬", "sausage":"🥓", "tomato":"🍅", "tapioca pearls":"⚫️", "tortillas":"🌮", "vanilla":"🍨", "fries":"🍟", "mushroom":"🍄", "radish":"🥕", "yam":"🍠", "oranges":"🍊", "potato":"🥔", "orange":"🍊", "blueberries":"🍇", "blackberries":"🍇", "brandy":"🍺", "butter":"🧈", "pork":"🐖", "beets":"🥕", "cider":"🍺", "cauliflower":"🥦", "clam":"🐚", "cranberries":"🍇", "dressing":"🥫", "doritos":"🍟", "cheetos":"🍟", "takis":"🍟", "french fries":"🍟", "mayonnaise":"🥫", "mozzarella":"🧀", "macaroon":"🍜", "mustard":"🥫", "meatloaf":"🍖", "popcorn":"🍿", "peppers":"🌶", "peaches":"🍑", "pretzels":"🥨", "popsicle":"🧊", "pomegranate":"🍎", "quail egg":"🥚", "rum":"🍺", "raisins":"🍇", "ravioli":"🥟", "salmon":"🐟", "sandwich":"🥪", "turkey":"🦃", "left overs":"🍲", "frosting":"🧁", "fudge":"🍫", "flour":"🌾", "gravy":"🍲", "grapefruit":"🍊", "ground beef":"🥩", "hazelnut":"🌰", "burgers":"🍔", "meatballs":"🧆", "noodles":"🍜", "turnip":"🍠", "pasta":"🍝", "appracot":"🍑", "breadfruit":"🍐", "buckwheat":"🌾", "cucumber":"🥒", "red velvet cake":"🍰", "star fruit":"🍋", "dragon fruit":"🍎", "peanut butter":"🥜", "oreo pie":"🥧", "cheese cake":"🧀", "brownies":"🍫", "sauce":"🥫", "pickles":"🥒", "peas":"🌰", "rice":"🍚", "chinese food":"🇨🇳", "japanese food":"🇯🇵", "beef stew":"🍲", "chicken soup":"🐣", "chicken noodle soup":"🍜", "sweet potatoes":"🍠", "dandelion":"🌼", "grape":"🍇", "brussel sprouts":"🥬", "corn salad":"🥗", "dill":"🥬", "lettuce":"🥬", "sea beet":"🥬", "sea kale":"🥬", "water grass":"🥬", "wheatgrass":"🌾", "bittermelon":"🍈", "eggplant":"🍆", "olive fruit":"🍐", "pumpkin":"🎃", "sweet pepper":"🌶", "winter melon":"🍈", "chickpeas":"🌰", "common peas":"🌰", "indian pea":"🌰", "peanut":"🥜", "soybean":"🌰", "chives":"🥬", "garlic chives":"🥬", "lemon grass":"🥬", "leek":"🥬", "lotus root":"🥥", "pearl onion":"🧅", "spring onion":"🧅", "green onion":"🧅", "mondrian wild rice":"🍚", "bamboo shoot":"🎍", "beetroot":"🥕", "canna":"🌼", "cassava":"🥕", "horseradish":"🥕", "parsnip":"🥕", "tea":"🍵", "tigernut":"🌰", "sea lettuce":"🥬", "biscuit":"🍪", "meat":"🥩", "hot pot":"🍲", "pork chop":"🐖", "panna cotta":"🍮", "pancake mix":"🥞", "wontons":"🥟", "frozen dumplings":"🥟", "sourdough":"🌾", "sourdough bread":"🍞", "graham cracker":"🍪", "macaroni":"🍝", "macaroni and cheese":"🍝", "chicken alfredo":"🍝", "mochi ice cream":"🍦", "pineapple":"🍍", "pineapple cake":"🍰", "banana bread":"🍞", "blueberry muffins":"🧁", "aloe juice":"🥤", "aloe vera drink":"🥤", "smoothie":"🥤", "macaroon":"🍬", "marinara sauce":"🥫", "mini potatoes":"🥔", "honeycrisp apples":"🍎", "japanese pumpkin":"🎃", "basil":"🥬", "frozen mango":"🥭", "dried mango":"🥭", "beef jerky":"🥓", "tangerines":"🍊", "clementines":"🍊", "sugar canes":"🍬", "honeydew":"🍈", "asian pears":"🍐", "congee":"🍚", "yellow onions":"🧅", "baby carrots":"🥕", "grape tomatoes":"🍅", "white mushrooms":"🍄", "sweet onions":"🧅", "romaine lettuce":"🥬", "sweet corn cobs":"🌽", "shallot":"🧅", "broccoli florets":"🥦", "golden potatoes":"🥔", "russet potatoes":"🥔", "chayote squash":"🍈", "peeled garlic":"🧄", "spaghetti squash":"🍝", "boston lettuce":"🥬", "diced yellow onions":"🧅", "butternut squash":"🍟", "curly mustard":"🥬", "lime":"🍋", "lemons":"🍋", "seedless grapes":"🍇", "red mango":"🥭", "seedless watermelon":"🍉", "navel oranges":"🍊", "granny smith apples":"🍏", "gala apples":"🍎", "seeded red watermelon":"🍉", "bartlett pear":"🍐", "bosc pear":"🍐", "sungold kiwi":"🥝", "honeydew melon":"🍈", "lunchables":"🍱", "ground beef":"🍖", "ground pork":"🐖", "smoked bacon":"🥓", "cracker crunchers":"🍪", "nachos":"🇲🇽", "chicken drumsticks":"🍗", "mashed potatoes":"🥔", "ground turkey":"🦃", "italian sausage":"🌭", "chinese sausage":"🌭", "sausage":"🌭", "shrimp":"🦐", "frozen shrimp":"🦐", "frito-lay":"🍟", "tortilla chips":"🍟", "hot dog buns":"🌭", "ramen noodle soup":"🍜", "potato chips":"🍟", "ritz stacks original crackers":"🍪", "barbecue sauce":"🥫", "toasted coconut chips":"🍟", "coconut":"🥥", "white sliced bread":"🍞", "canned green beans":"🥫", "oreo":"🍪", "taco seasoning":"🌮", "flaming hot cheetos":"🍟", "diced tomatoes":"🍅", "chili":"🌶", "beef ravioli":"🥟", "burger buns":"🍔", "honey maid graham crackers":"🍪", "cheez it":"🍟", "cream of chicken soup":"🍲", "pringles":"🍟", "penne pasta":"🍝", "bbq potato chips":"🍟", "ranch":"🥫", "tomato paste":"🍅", "chicken broth":"🍲", "vegetable broth":"🍲", "fat free skim milk":"🥛", "chocolate milk":"🥛", "sharp cheddar cheese":"🧀", "cheddar":"🧀", "yogurt":"🥛", "greek yogurt":"🥛", "pasteurized milk":"🥛", "egg whites":"🥚", "mexican style blend":"🇲🇽", "american cheese":"🧀", "coffee mate":"☕️", "coffee creamer":"☕️", "sour cream":"🥛", "unsalted butter":"🧈", "salted butter":"🧈", "whipped cream":"", "cream cheese":"", "heavy cream":"", "cinnamon rolls":"🍬", "chobani greek yogurt":"🥛", "almond milk":"🥛", "soy milk":"🥛", "oat milk":"🥛", "buttermilk biscuits":"🍪", "macaroni salad":"🥗", "mustard potato salad":"🥗", "chicken tenders":"🍗", "fresh mozzarella":"🧀", "feta cheese":"🧀", "pretzel":"🥨", "dinner rolls":"🍞", "croissants":"🥐", "mini croissants":"🥐", "savory butter rolls":"🧈", "chocolate chip cookies":"🍪", "m&m cookies":"🍬", "flat bread":"🍞", "desert shells":"🐚", "mini donuts":"🍩", "apple pie":"🥧", "garlic naan flatbread":"🍞", "bakery fresh goodness mini cinnamon rolls":"🍬", "sugar cookies":"🍪", "reese's peanut butter cups":"🥜", "kitkat":"🍫", "m&ms":"🍬", "spinach":"🥬", "cappuccino":"☕️", "bacon":"🥓", "sunnyside up":"🍳", "cinnamon":"🍬", "juice":"🧃", "pepsi":"🥤","coke":"🥤","sprite":"🥤","dr peper":"🥤","mountatin dew":"🥤","sparkling water":"🥤","aloe drink":"🥤", "yakult":"🥤", "sunchip":"🍿"]

    @Binding var image: [CGImage]?
    @Binding var showingView: String?
    var storageIndex: StorageLocation
    @State var ref: DocumentReference!
    @State var foodsToDisplay = [refrigeItem]()
    func getRandomEmoji () -> String{
        let listOfEmojis = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚"),emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢"),emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
        return listOfEmojis.randomElement()!.emoji
        
        }
    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {

            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
        var returnValue = false
        print(denomenator)
        if Int.random(in: 1...denomenator.newBottom) == 1 {
        returnValue = true
      }
       return returnValue
    }
    @Binding var scan: VNDocumentCameraScan?
    @State var percentDone = 0.0
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @State var interstitial: GADInterstitial!
    var adDelegate = MyDInterstitialDelegate()
    var body: some View {
        ZStack{
            Color("whiteAndBlack")
        ScrollView(.vertical, showsIndicators: false, content: {
            ZStack{
            VStack {
                
                Text("Analyzing Your Image...")
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Image(uiImage: UIImage(cgImage: self.image![0]))
                .resizable()
                .padding()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()

                Text("\(percentDone * 100)% done")
                ForEach(foodsToDisplay) { food in
                    DetectItemCell(foodsToDisplay: self.$foodsToDisplay, index: self.foodsToDisplay.firstIndex(of: food)!, icon: food.icon, title: food.title, lastsFor: food.daysLeft)
                }
                Spacer()
                
                Button(action: {
                    self.foodsToDisplay.append(refrigeItem(icon: "⍰", title: "to be named", daysLeft: 7))
                }, label: {
                    Image("plus")
                    .renderingMode(.original)
                }).onDisappear{
                    print("DISSAPEARED")
                    self.showingView = "fridge"
                }
                
                NavigationLink(destination: RefrigeratorView(showingView: self.$showingView, scan: self.$scan, image: self.$image), label: {
                    Image("addOrange")
                        .renderingMode(.original)
                    }).simultaneousGesture(TapGesture().onEnded{
                        self.showingView = "fridge"
                        for i in self.foodsToDisplay{
                            let id = UUID()
                               let newFoodItem = FoodItem(context: self.managedObjectContext)
                            newFoodItem.staysFreshFor = Int16(i.daysLeft)
                            newFoodItem.symbol = i.icon
                            newFoodItem.name = i.title
                            newFoodItem.inStorageSince = Date()
                            newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                            newFoodItem.origion?.storageName = self.storageIndex.wrappedStorageName
                            newFoodItem.origion?.symbolName = self.storageIndex.wrappedSymbolName
                            newFoodItem.id = id
                            
                            
                               let center = UNUserNotificationCenter.current()
                               let content = UNMutableNotificationContent()
                               content.title = "Eat This Food Soon"
                               let date = Date()
                               let twoDaysBefore = addDays(days: i.daysLeft - 2, dateCreated: date)
                               content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                               content.sound = UNNotificationSound.default
                               var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                               dateComponents.hour = 10
                               dateComponents.minute = 0
                               let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                               let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                               center.add(request)
                               do{
                                   try self.managedObjectContext.save()
                               } catch let error{
                               print(error)
                               }
                            Analytics.logEvent("addedFoodItem", parameters: nil)
                        }
                        
                        
                    })
                    .padding(.top, 200)
                
                NavigationLink(destination: RefrigeratorView(showingView: self.$showingView, scan: self.$scan, image: self.$image), label: {
                Text("Cancel")
                    
                    }).padding()
                    .simultaneousGesture(TapGesture().onEnded{
                    self.showingView = "fridge"
                    
                })
                
                }
                
            .onAppear(perform: {
                var secondArray: [[String:Any]]? = nil
                self.ref = Firestore.firestore().document("Others/SecondArrayOfFoods")
                self.ref.getDocument{(documentSnapshot, error) in
                    guard let docSnapshot = documentSnapshot, docSnapshot.exists else {
                        print("docSnapshot does not exist")
                        return}
                    
                    let myData = docSnapshot.data()
                    let secondArrayOfFoods = myData?["data"] as? [[String: Any]]
                    secondArray = secondArrayOfFoods
                    print("secondArrayOfFoods: \(secondArrayOfFoods)")
                }
                
                
                if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 3 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "ExamineRecieptViewLoadedAd") == false{
                    self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
                    self.interstitial.delegate = self.adDelegate
                    
                    let req = GADRequest()
                    self.interstitial.load(req)

                    UserDefaults.standard.set(true, forKey: "ExamineRecieptViewLoadedAd")
                    
                }else {

                }
                
                
                
                DispatchQueue.main.async {
                    let images = (0..<self.scan!.pageCount).compactMap({ self.scan!.imageOfPage(at: $0).cgImage })

                    let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                        guard let observations = request.results as? [VNRecognizedTextObservation] else {
                            print("The observations are of an unexpected type.")
                            return
                        }
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
                            if let secArray = secondArray{
                                print("countssss: \(secArray.count)")
                                for index in 0...secArray.count - 1{
                                    print("nametest: \(((secArray[index])["name"] as? String) ?? "")")
                                if bestCandidate.string.lowercased().contains(((secArray[index])["name"] as? String) ?? "") {
                                    self.foodsToDisplay.append(refrigeItem(icon: (((secArray[index])["emoji"] as? String) ?? ""), title: bestCandidate.string, daysLeft: 7))
                                    print("found and appended: \(bestCandidate.string)")
                                    break
                                }else {
                                    print("found but not appended: \(bestCandidate.string)")
                                }
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
                    }
                }
                
                print(self.foodsToDisplay)
                print("appearing")
            })
                
            }
        }
        )
            
        }
    
        
    }
}

