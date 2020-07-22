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

enum DefaultStorageLocation: String {
    case refrigerator
    case freezer
    case pantry
    case changeMe
}

struct ExamineRecieptView: View {
    
    let newArrayOfFoods:KeyValuePairs = [
        "bread":"🍞", "cake":"🎂", "watermelon":"🍉", "grapes":"🍇", "chicken wings":"🍗", "mug cake":"🧁", "cup cake":"🧁", "pizza":"🍕", "hot dog":"🌭", "caviar":"🐟", "parmesan":"🧀", "cheese":"🧀", "bbq":"🍖", "eggs":"🥚", "milk":"🥛", "creme caramel":"🍮", "broccoli":"🥦", "onion":"🧅", "donut":"🍩", "cherries":"🍒", "green apple":"🍏", "banana":"🍌", "carrot":"🥕", "pumpkin pie":"🥧", "pastries":"🥐", "cookies":"🍪", "mandarine":"🍊", "bok choi":"🥬", "ramen":"🍜", "chipotle":"🥙", "taco":"🌮", "burrito":"🌯", "sugar":"🍬", "mango":"🥭", "asparagus":"🌲", "acorn squash":"🌰", "almond":"🌰", "apple sauce":"🍎", "asian noodles":"🍜", "cantaloupe":"🍈", "tuna":"🐟", "apple juice":"🧃", "avocado roll":"🥑", "black beans":"🌰", "bagels":"🥐", "baked beans":"🌰", "beer":"🍺", "fish":"🐠", "cabbage":"🥬", "celery":"🥬", "cat fish":"🐟", "chips":"🍟", "chocolate":"🍫", "chowder":"🍲", "clams":"🦪", "coffee":"☕️", "crab":"🦀", "curry":"🍛", "cereal":"🥣", "kimchi":"🇰🇷", "dates":"🌰", "dips":"🥣", "duck":"🦆", "donuts":"🍩", "enchilada":"🥘", "egg rolls":"🍳", "english muffins":"🧁", "muffins":"🧁", "edamame":"🥬", "sushi":"🍣", "fondue":"🧀", "french toast":"🍞", "garlic":"🧄", "ginger":"🥕", "gnocchi":"🍝", "goose":"🦆", "granola":"🍫", "green beans":"🌰", "beans":"🌰", "guacamole":"🥑", "graham crackers":"🍘", "ham":"🐖", "hamburger":"🍔", "honey":"🍯", "hash browns":"🍟", "hikurolls":"🥞", "hummus":"🥫", "irish stew":"🍲", "indian food":"🇮🇳", "italian bread":"🥖", "jam":"🥫", "jelly":"🥫", "jerky":"🥓", "jalapeno":"🌶", "kale":"🥬", "ketchup":"🥫", "kiwi":"🥝", "kingfish":"🐠", "lobster":"🦞", "lamb":"🐑", "lasagna":"🍝", "moose":"🦌", "milkshake":"🥤", "peperoni":"🍕", "pancakes":"🥞", "quesadilla":"🌮", "spaghetti":"🍝", "tater tots":"🍟", "toast":"🍞", "udon noodles":"🍜", "udon":"🍜", "venison":"🥩","waffles":"🧇", "wasabi":"🍣", "wine":"🍷", "walnuts":"🌰", "ziti":"🍝", "zucchini":"🥒", "ugli":"🍊", "tangerine":"🍊","oatmeal":"🥣", "goat cheese":"🧀", "mushrooms":"🍄", "pears":"🍐", "raspberry":"🍇", "strawberry":"🍓", "fig":"🥭", "passion fruit":"🍊", "pineuts":"🌰", "olives":"🍐", "cottage cheese":"🧀", "refried beans":"🌰", "bell peppers":"🌶", "salmon":"🐠", "rice cake":"🍙", "mochi":"🍡", "pinto beans":"🌰", "purple yam":"🍠", "urchins":"🐡", "ukraine rolls":"🥞", "umbrella fruit":"🍐", "papaya":"🥭", "steak":"🥩", "extreme candy":"🍬", "hot sauce":"🌶", "xo sauce":"🥫", "parsley":"🥬", "sausage":"🥓", "tomato":"🍅", "tapioca pearls":"⚫️", "tortillas":"🌮", "vanilla":"🍨", "fries":"🍟", "mushroom":"🍄", "radish":"🥕", "yam":"🍠", "oranges":"🍊", "potato":"🥔", "orange":"🍊", "blueberries":"🍇", "blackberries":"🍇", "brandy":"🍺", "butter":"🧈", "pork":"🐖", "beets":"🥕", "cider":"🍺", "cauliflower":"🥦", "clam":"🐚", "cranberries":"🍇", "dressing":"🥫", "doritos":"🍟", "cheetos":"🍟", "takis":"🍟", "french fries":"🍟", "mayonnaise":"🥫", "mozzarella":"🧀", "macaroon":"🍜", "mustard":"🥫", "meatloaf":"🍖", "popcorn":"🍿", "peppers":"🌶", "peaches":"🍑", "pretzels":"🥨", "popsicle":"🧊", "pomegranate":"🍎", "quail egg":"🥚", "rum":"🍺", "raisins":"🍇", "ravioli":"🥟", "salmon":"🐟", "sandwich":"🥪", "turkey":"🦃", "left overs":"🍲", "frosting":"🧁", "fudge":"🍫", "flour":"🌾", "gravy":"🍲", "grapefruit":"🍊", "ground beef":"🥩", "hazelnut":"🌰", "burgers":"🍔", "meatballs":"🧆", "noodles":"🍜", "turnip":"🍠", "pasta":"🍝", "appracot":"🍑", "breadfruit":"🍐", "buckwheat":"🌾", "cucumber":"🥒", "red velvet cake":"🍰", "star fruit":"🍋", "dragon fruit":"🍎", "peanut butter":"🥜", "oreo pie":"🥧", "cheese cake":"🧀", "brownies":"🍫", "sauce":"🥫", "pickles":"🥒", "peas":"🌰", "rice":"🍚", "chinese food":"🇨🇳", "japanese food":"🇯🇵", "beef stew":"🍲", "chicken soup":"🐣", "chicken noodle soup":"🍜", "sweet potatoes":"🍠", "dandelion":"🌼", "grape":"🍇", "brussel sprouts":"🥬", "corn salad":"🥗", "dill":"🥬", "lettuce":"🥬", "sea beet":"🥬", "sea kale":"🥬", "water grass":"🥬", "wheatgrass":"🌾", "bittermelon":"🍈", "eggplant":"🍆", "olive fruit":"🍐", "pumpkin":"🎃", "sweet pepper":"🌶", "winter melon":"🍈", "chickpeas":"🌰", "common peas":"🌰", "indian pea":"🌰", "peanut":"🥜", "soybean":"🌰", "chives":"🥬", "garlic chives":"🥬", "lemon grass":"🥬", "leek":"🥬", "lotus root":"🥥", "pearl onion":"🧅", "spring onion":"🧅", "green onion":"🧅", "mondrian wild rice":"🍚", "bamboo shoot":"🎍", "beetroot":"🥕", "canna":"🌼", "cassava":"🥕", "horseradish":"🥕", "parsnip":"🥕", "tea":"🍵", "tigernut":"🌰", "sea lettuce":"🥬", "biscuit":"🍪", "meat":"🥩", "hot pot":"🍲", "pork chop":"🐖", "panna cotta":"🍮", "pancake mix":"🥞", "wontons":"🥟", "frozen dumplings":"🥟", "sourdough":"🌾", "sourdough bread":"🍞", "graham cracker":"🍪", "macaroni":"🍝", "macaroni and cheese":"🍝", "chicken alfredo":"🍝", "mochi ice cream":"🍦", "pineapple":"🍍", "pineapple cake":"🍰", "banana bread":"🍞", "blueberry muffins":"🧁", "aloe juice":"🥤", "aloe vera drink":"🥤", "smoothie":"🥤", "macaroon":"🍬", "marinara sauce":"🥫", "mini potatoes":"🥔", "honeycrisp apples":"🍎", "japanese pumpkin":"🎃", "basil":"🥬", "frozen mango":"🥭", "dried mango":"🥭", "beef jerky":"🥓", "tangerines":"🍊", "clementines":"🍊", "sugar canes":"🍬", "honeydew":"🍈", "asian pears":"🍐", "congee":"🍚", "yellow onions":"🧅", "baby carrots":"🥕", "grape tomatoes":"🍅", "white mushrooms":"🍄", "sweet onions":"🧅", "romaine lettuce":"🥬", "sweet corn cobs":"🌽", "shallot":"🧅", "broccoli florets":"🥦", "golden potatoes":"🥔", "russet potatoes":"🥔", "chayote squash":"🍈", "peeled garlic":"🧄", "spaghetti squash":"🍝", "boston lettuce":"🥬", "diced yellow onions":"🧅", "butternut squash":"🍟", "curly mustard":"🥬", "lime":"🍋", "lemons":"🍋", "seedless grapes":"🍇", "red mango":"🥭", "seedless watermelon":"🍉", "navel oranges":"🍊", "granny smith apples":"🍏", "gala apples":"🍎", "seeded red watermelon":"🍉", "bartlett pear":"🍐", "bosc pear":"🍐", "sungold kiwi":"🥝", "honeydew melon":"🍈", "lunchables":"🍱", "ground beef":"🍖", "ground pork":"🐖", "smoked bacon":"🥓", "cracker crunchers":"🍪", "nachos":"🇲🇽", "chicken drumsticks":"🍗", "mashed potatoes":"🥔", "ground turkey":"🦃", "italian sausage":"🌭", "chinese sausage":"🌭", "sausage":"🌭", "shrimp":"🦐", "frozen shrimp":"🦐", "frito-lay":"🍟", "tortilla chips":"🍟", "hot dog buns":"🌭", "ramen noodle soup":"🍜", "potato chips":"🍟", "ritz stacks original crackers":"🍪", "barbecue sauce":"🥫", "toasted coconut chips":"🍟", "coconut":"🥥", "white sliced bread":"🍞", "canned green beans":"🥫", "oreo":"🍪", "taco seasoning":"🌮", "flaming hot cheetos":"🍟", "diced tomatoes":"🍅", "chili":"🌶", "beef ravioli":"🥟", "burger buns":"🍔", "honey maid graham crackers":"🍪", "cheez it":"🍟", "cream of chicken soup":"🍲", "pringles":"🍟", "penne pasta":"🍝", "bbq potato chips":"🍟", "ranch":"🥫", "tomato paste":"🍅", "chicken broth":"🍲", "vegetable broth":"🍲", "fat free skim milk":"🥛", "chocolate milk":"🥛", "sharp cheddar cheese":"🧀", "cheddar":"🧀", "yogurt":"🥛", "greek yogurt":"🥛", "pasteurized milk":"🥛", "egg whites":"🥚", "mexican style blend":"🇲🇽", "american cheese":"🧀", "coffee mate":"☕️", "coffee creamer":"☕️", "sour cream":"🥛", "unsalted butter":"🧈", "salted butter":"🧈", "whipped cream":"", "cream cheese":"", "heavy cream":"", "cinnamon rolls":"🍬", "chobani greek yogurt":"🥛", "almond milk":"🥛", "soy milk":"🥛", "oat milk":"🥛", "buttermilk biscuits":"🍪", "macaroni salad":"🥗", "mustard potato salad":"🥗", "chicken tenders":"🍗", "fresh mozzarella":"🧀", "feta cheese":"🧀", "pretzel":"🥨", "dinner rolls":"🍞", "croissants":"🥐", "mini croissants":"🥐", "savory butter rolls":"🧈", "chocolate chip cookies":"🍪", "m&m cookies":"🍬", "flat bread":"🍞", "desert shells":"🐚", "mini donuts":"🍩", "apple pie":"🥧", "garlic naan flatbread":"🍞", "bakery fresh goodness mini cinnamon rolls":"🍬", "sugar cookies":"🍪", "reese's peanut butter cups":"🥜", "kitkat":"🍫", "m&ms":"🍬", "spinach":"🥬", "cappuccino":"☕️", "bacon":"🥓", "sunnyside up":"🍳", "cinnamon":"🍬", "juice":"🧃", "pepsi":"🥤","coke":"🥤","sprite":"🥤","dr peper":"🥤","mountatin dew":"🥤","sparkling water":"🥤","aloe drink":"🥤", "yakult":"🥤", "sunchip":"🍿"
    ]
    
    var newerArrayOfFoods: [[String:Any]] =  [//the official
        ["name": "eggs", "emoji": "🥚", "lastsFor": 28, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "bread", "emoji": "🍞", "lastsFor": 5, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🎂", "lastsFor": 3, "name": "cake", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 3, "name": "watermelon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍉"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "emoji": "🍇", "name": "grapes"],
        ["emoji": "🍗", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "name": "chicken wings"],
        ["emoji": "🧁", "name": "cup cake", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["name": "pizza", "emoji": "🍕", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "hot dog", "emoji": "🌭"],
        ["lastsFor": 12, "emoji": "🐟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "caviar"],
        ["name": "parmesean", "emoji": "🧀", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 42],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 42, "emoji": "🧀", "name": "cheese"],
        ["lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "bbq", "emoji": "🍖"],
        ["lastsFor": 2, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "pork", "emoji": "🐖"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 6, "emoji": "🥛", "name": "milk"],
        ["name": "soy milk", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 6],
        ["name": "creme caremal", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍮", "lastsFor": 2],
        ["emoji": "🥦", "lastsFor": 6, "name": "brocolie", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "onion", "emoji": "🧅", "lastsFor": 8],
        ["lastsFor": 7, "name": "donut", "emoji": "🍩", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "cherries", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "emoji": "🍒"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 6, "name": "green apple", "emoji": "🍏"],
        ["emoji": "🍌", "name": "banana", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 4],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "name": "carrot", "emoji": "🥕"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥧", "lastsFor": 3, "name": "pumpkin pie"],
        ["name": "pastries", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 2, "emoji": "🥐"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "cookies", "emoji": "🍪", "lastsFor": 14],
        ["lastsFor": 10, "emoji": "🍊", "name": "mandarine", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "spinach", "emoji": "🥬", "lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "emoji": "🥬", "name": "bok choy"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍜", "name": "ramen", "lastsFor": 365],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍜", "lastsFor": 180, "name": "noodles"],
        ["emoji": "🥙", "name": "chipotle", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3, "name": "taco", "emoji": "🌮"],
        ["name": "burrito", "emoji": "🌯", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["name": "sugar", "emoji": "🍬", "lastsFor": 730, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["lastsFor": 5, "emoji": "🥭", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "mango"],
        ["name": "asparagus", "lastsFor": 7, "emoji": "🌲", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🌰", "name": "acorn squash", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["name": "almond", "lastsFor": 730, "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🌰"],
        
        ["emoji": "🍎", "name": "apple saurce", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["emoji": "🍜", "name": "asian noodles", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 730],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 8, "name": "cantaloupe", "emoji": "🍈"],
        ["name": "tuna", "lastsFor": 3, "emoji": "🐟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 75, "name": "apple juice", "emoji": "🧃", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "avocado roll", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥑", "lastsFor": 3],
        ["name": "bacon", "lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥓"],
        ["name": "black beans", "emoji": "🌰", "lastsFor": 1105, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "bagels", "emoji": "🥐", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 5],
        ["name": "baked beans", "emoji": "🌰", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "beer", "lastsFor": 210, "emoji": "🍺"],
        ["emoji": "🐠", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "fish", "lastsFor": 3],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "cabbage", "emoji": "🥬", "lastsFor": 40],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "celery", "emoji": "🥬", "lastsFor": 24],
        ["lastsFor": 3, "name": "cat fish", "emoji": "🐟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "chips", "emoji": "🍟", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 75],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍫", "name": "chocolate", "lastsFor": 365],
        ["name": "chowder", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍲"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "clams", "lastsFor": 2, "emoji": "🦪"],
        ["name": "coffee", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "☕️"],
        ["lastsFor": 2, "name": "corn", "emoji": "🌽", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "crab", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 2, "emoji": "🦀"],
        ["lastsFor": 90, "name": "curry", "emoji": "🍛", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 90, "emoji": "🥣", "name": "cereal"],
        ["lastsFor": 135, "name": "kimchi", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🇰🇷"],
        ["name": "dates", "lastsFor": 270, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰"],
        ["emoji": "🥣", "lastsFor": 7, "name": "dips", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "duck", "emoji": "🦆", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 8],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "dumplings", "lastsFor": 90, "emoji": "🥟"],
        ["emoji": "🍩", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "donuts"],
        ["lastsFor": 4, "name": "enchilada", "emoji": "🥘", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🍳", "lastsFor": 3, "name": "eggrolls", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 14, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "english muffins", "emoji": "🧁"],
        ["lastsFor": 7, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "muffins", "emoji": "🧁"],
        ["name": "edamame", "lastsFor": 365, "defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🥬"],
        ["emoji": "🍣", "lastsFor": 3, "name": "sushi", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🧀", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 42, "name": "fondue"],
        ["emoji": "🍞", "name": "french toast", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 90],
        ["name": "garlic", "emoji": "🧄", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 21],
        ["lastsFor": 14, "name": "ginger", "emoji": "🥕", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "gnochhi", "emoji": "🍝", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30],
        ["emoji": "🦆", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "goose", "lastsFor": 8],
        ["lastsFor": 180, "emoji": "🍫", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "granola"],
        ["lastsFor": 7, "name": "green beans", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰", "lastsFor": 4, "name": "beans"],
        ["name": "guacamole", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥑", "lastsFor": 2],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍘", "lastsFor": 210, "name": "grahm crackers"],
        ["emoji": "🐖", "name": "ham", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["name": "hamburger", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍔", "lastsFor": 2],
        ["emoji": "🍯", "name": "honey", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 99999],
        ["lastsFor": 365, "emoji": "🍟", "name": "hashbrowns", "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["emoji": "🥫", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "hummus"],
        ["emoji": "🍲", "name": "irish stew", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["lastsFor": 4, "name": "indian food", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🇮🇳"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🥖", "name": "italian bread", "lastsFor": 3],
        ["emoji": "🥫", "name": "jam", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 365],
        ["emoji": "🥫", "lastsFor": 270, "name": "jelly", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        
        ["lastsFor": 730, "name": "jerky", "emoji": "🥓", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "jalapeno", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌶", "lastsFor": 3],
        ["lastsFor": 6, "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "kale"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "ketchup", "emoji": "🥫", "lastsFor": 180],
        ["name": "kiwi", "emoji": "🥝", "lastsFor": 28, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3, "emoji": "🐠", "name": "kingfish"],
        ["name": "lobster", "emoji": "🦞", "lastsFor": 4, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🐑", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "lamb", "lastsFor": 5],
        ["name": "lasagna", "emoji": "🍝", "lastsFor": 210, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🍖", "name": "meatballs", "lastsFor": 90],
        ["lastsFor": 2, "emoji": "🥤", "name": "milkshake", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 21, "name": "peperoni", "emoji": "🍕"],
        ["name": "panckaes", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3, "emoji": "🥞"],
        ["emoji": "🍝", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "name": "spaghetti"],
        ["name": "tatter tots", "emoji": "🍟", "lastsFor": 270, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["lastsFor": 7, "emoji": "🍞", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "toast"],
        ["emoji": "🍜", "lastsFor": 365, "name": "udon noodles", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["lastsFor": 365, "name": "udon", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍜"],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 270, "name": "venison", "emoji": "🥩"],
        ["lastsFor": 365, "emoji": "🍣", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "wasabi"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 1095, "emoji": "🍷", "name": "wine"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰", "name": "walnuts", "lastsFor": 180],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "name": "yogurt", "emoji": "🥛"],
        ["lastsFor": 60, "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "ziti", "emoji": "🍝"],
        ["emoji": "🥒", "name": "zucchini", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["name": "ugli", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍊", "lastsFor": 4],
        ["lastsFor": 10, "emoji": "🍊", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "tangerine"],
        ["name": "oatmeal", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 550, "emoji": "🥣"],
        ["name": "goat cheese", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 21, "emoji": "🧀"],
        ["name": "mushrooms", "lastsFor": 10, "emoji": "🍄", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "name": "pears", "emoji": "🍐"],
        ["emoji": "🍇", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "name": "raspberry"],
        ["name": "strawberry", "lastsFor": 7, "emoji": "🍓", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥭", "name": "fig", "lastsFor": 3],
        ["emoji": "🍊", "name": "passion fruit", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["emoji": "🌰", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "pineuts", "lastsFor": 60],
        ["emoji": "🍒", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "cherries"],
        ["emoji": "🍐", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 120, "name": "olives"],
        ["lastsFor": 14, "name": "cottage cheese", "emoji": "🧀", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "tuna", "emoji": "🐟"],
        ["emoji": "🌰", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "name": "refried beans"],
        ["name": "bell peppers", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "emoji": "🌶"],
        ["emoji": "🐠", "name": "salmon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 2],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "emoji": "🍍", "name": "pineapple"],
        ["name": "sweet potatoes", "emoji": "🍠", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["emoji": "🍙", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 21, "name": "rice cake"],
        ["name": "mochi", "emoji": "🍡", "lastsFor": 14, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        
        ["name": "pinto beans", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🌰", "lastsFor": 720],
        ["name": "coconut", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "emoji": "🥥"],
        ["emoji": "🍠", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 21, "name": "purple yam"],
        ["name": "urchins", "emoji": "🐡", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 2],
        ["emoji": "🍐", "name": "umbrella fruit", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 7],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "papaya", "emoji": "🥭"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥩", "name": "steak", "lastsFor": 5],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍬", "name": "extreme candy", "lastsFor": 365],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 1095, "name": "hot sauce", "emoji": "🌶"],
        ["emoji": "🥫", "name": "xo sauce", "lastsFor": 30, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "shrimp", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🦐", "lastsFor": 3],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 8, "emoji": "🥬", "name": "parsley"],
        ["lastsFor": 14, "emoji": "🥓", "name": "sausage", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "tomato", "emoji": "🍅", "lastsFor": 10],
        ["name": "tapioca pearls", "lastsFor": 365, "emoji": "⚫️", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌮", "lastsFor": 28, "name": "tortillas"],
        ["lastsFor": 1825, "name": "vanilla", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍨"],
        ["name": "fries", "emoji": "🍟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["emoji": "🍄", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 10, "name": "mushroom"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "radish", "emoji": "🥕", "lastsFor": 14],
        ["emoji": "🍊", "name": "oranges", "lastsFor": 10, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "potato", "lastsFor": 30, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥔"],
        ["emoji": "🍇", "lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "blueberries"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 6, "name": "blackberries", "emoji": "🍇"],
        ["lastsFor": 180, "name": "brandy", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍺"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "butter", "emoji": "🧈", "lastsFor": 120],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 10, "emoji": "🥕", "name": "beets"],
        ["name": "cider", "emoji": "🍺", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 365],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "name": "cauliflower", "emoji": "🥦"],
        ["lastsFor": 2, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🐚", "name": "clam"],
        ["name": "cranberries", "lastsFor": 21, "emoji": "🍇", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "dressing", "lastsFor": 60, "emoji": "🥫", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 90, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "doritos", "emoji": "🍟"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍟", "lastsFor": 90, "name": "cheetos"],
        ["lastsFor": 90, "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍟", "name": "takis"],
        ["lastsFor": 30, "emoji": "🧃", "name": "juice", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "lettuce", "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "mayonnaise", "lastsFor": 90, "emoji": "🥫"],
        ["emoji": "🧀", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "mozzarella", "lastsFor": 35],
        ["name": "macaroon", "emoji": "🍜", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["lastsFor": 60, "name": "mustard", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥫"],
        ["lastsFor": 4, "emoji": "🍖", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "meatloaf"],
        ["emoji": "🍿", "name": "popcorn", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 60],
        
        ["name": "peaches", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 4, "emoji": "🍑"],
        ["emoji": "🥨", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "pretzels", "lastsFor": 14],
        ["name": "popsicle", "emoji": "🧊", "lastsFor": 210, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["emoji": "🍎", "name": "pomegranate", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 60],
        ["name": "quail egg", "emoji": "🥚", "lastsFor": 30, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🍺", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "rum", "lastsFor": 180],
        ["name": "raisins", "emoji": "🍇", "lastsFor": 180, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "ravioli", "emoji": "🥟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3, "name": "salmon", "emoji": "🐟"],
        ["emoji": "🥪", "name": "sandwich", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🦃", "name": "turkey", "lastsFor": 5],
        ["name": "frosting", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧁", "lastsFor": 90],
        ["emoji": "🍫", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "fudge", "lastsFor": 21],
        ["lastsFor": 365, "name": "flour", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🌾"],
        ["name": "gravy", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "emoji": "🍲"],
        ["emoji": "🍊", "name": "grapefruit", "lastsFor": 180, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "ground beef", "defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🥩", "lastsFor": 120],
        ["name": "hazelnut", "lastsFor": 180, "emoji": "🌰", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "burgers", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 150, "emoji": "🍔"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 120, "name": "turnip", "emoji": "🍠"],
        ["name": "pasta", "emoji": "🍝", "lastsFor": 720, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "breadfruit", "emoji": "🍐", "lastsFor": 4],
        ["name": "buckwheat", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 60, "emoji": "🌾"],
        ["lastsFor": 14, "name": "cucumber", "emoji": "🥒", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "lemons", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍋", "lastsFor": 21],
        ["lastsFor": 2, "name": "red velvet cake", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍰"],
        ["lastsFor": 7, "emoji": "🍋", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "star fruit"],
        ["name": "dragon fruit", "emoji": "🍎", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 180, "name": "peanut butter", "emoji": "🥜"],
        ["name": "oreo pie", "lastsFor": 3, "emoji": "🥧", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "cheese cake", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "emoji": "🧀"],
        ["lastsFor": 4, "name": "brownies", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍫"],
        ["emoji": "🥫", "lastsFor": 240, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "sauce"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥒", "lastsFor": 545, "name": "pickles"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "peas", "emoji": "🌰", "lastsFor": 6],
        ["name": "rice", "emoji": "🍚", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 1460],
        ["lastsFor": 90, "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "chinese food", "emoji": "🇨🇳"],
        ["emoji": "🇯🇵", "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "japanese food", "lastsFor": 60],
        ["name": "chicken soup", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "emoji": "🐣"],
        ["emoji": "🍜", "name": "chicken noodle soup", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        ["lastsFor": 14, "name": "sweet potatoes", "emoji": "🍠", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "grape", "emoji": "🍇", "lastsFor": 7],
        ["name": "brussel sprouts", "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        ["emoji": "🥗", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "corn salad", "lastsFor": 5],
        ["name": "dill", "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["name": "sea beet", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥬", "lastsFor": 14],
        ["name": "wheatgrass", "emoji": "🌾", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["emoji": "🍈", "name": "bittermelon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["name": "eggplant", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 9, "emoji": "🍆"],
        ["name": "olive fruit", "emoji": "🍐", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30],
        ["name": "pumpkin", "emoji": "🎃", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 70],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌶", "name": "sweet pepper", "lastsFor": 10],
        ["emoji": "🍈", "lastsFor": 180, "name": "winter melon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "chickpeas", "emoji": "🌰", "lastsFor": 4],
        ["lastsFor": 7, "name": "common peas", "emoji": "🌰", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "name": "indian pea", "emoji": "🌰"],
        ["lastsFor": 28, "name": "peanut", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🥜"],
        ["emoji": "🌰", "name": "soybean", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["emoji": "🥬", "name": "chives", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["name": "garlic chives", "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 10],
        ["name": "lemon grass", "lastsFor": 10, "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "leek", "emoji": "🥬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["lastsFor": 7, "emoji": "🥥", "name": "lotus root", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 30, "name": "pearl onion", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧅"],
        ["lastsFor": 14, "name": "spring onion", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧅"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30, "name": "green onion", "emoji": "🧅"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 1460, "name": "mondrian wild rice", "emoji": "🍚"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🎍", "lastsFor": 14, "name": "bamboo shoot"],
        ["name": "beetroot", "lastsFor": 10, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥕"],
        ["emoji": "🥕", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 7, "name": "cassava"],
        ["name": "horseradish", "emoji": "🥕", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 90],
        
        ["name": "parsnip", "emoji": "🥕", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "tea", "emoji": "🍵", "lastsFor": 720],
        ["emoji": "🍪", "lastsFor": 60, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "biscuit"],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "meat", "emoji": "🥩", "lastsFor": 120],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 210, "emoji": "🐖", "name": "pork chop"],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "wontons", "emoji": "🥟", "lastsFor": 120],
        ["lastsFor": 120, "emoji": "🥟", "name": "frozen dumplings", "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["lastsFor": 4, "name": "sourdough", "emoji": "🌾", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "sourdough bread", "emoji": "🍞", "lastsFor": 4],
        ["name": "graham cracker", "emoji": "🍪", "lastsFor": 70, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "macaroni", "emoji": "🍝", "lastsFor": 545],
        ["lastsFor": 90, "emoji": "🍝", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "macaroni and cheese"],
        ["emoji": "🍝", "name": "chicken alfredo", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        ["name": "mochi ice cream", "emoji": "🍦", "lastsFor": 14, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["name": "pineapple", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4, "emoji": "🍍"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3, "name": "pineapple cake", "emoji": "🍰"],
        ["name": "banana bread", "emoji": "🍞", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 2],
        ["emoji": "🧁", "lastsFor": 2, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "blueberry muffins"],
        ["name": "aloe juice", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥤", "lastsFor": 21],
        ["name": "aloe vera drink", "lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥤"],
        ["emoji": "🥤", "lastsFor": 1, "name": "smoothie", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🍬", "name": "macaroon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["name": "marinara sauce", "emoji": "🥫", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 10],
        ["lastsFor": 14, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "mini potatoes", "emoji": "🥔"],
        ["lastsFor": 210, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍎", "name": "honeycrisp apples"],
        ["name": "japanese pumpkin", "lastsFor": 150, "emoji": "🎃", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 3, "emoji": "🥬", "name": "basil", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 300, "emoji": "🥭", "name": "frozen mango"],
        ["name": "dried mango", "lastsFor": 270, "emoji": "🥭", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "beef jerky", "emoji": "🥓", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 730],
        ["name": "tangerines", "emoji": "🍊", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 14],
        ["lastsFor": 7, "emoji": "🍊", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "clementimes"],
        ["name": "sugar canes", "emoji": "🍬", "lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 9, "name": "honeydew", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍈"],
        ["emoji": "🍐", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 7, "name": "asian pears"],
        ["name": "congee", "lastsFor": 5, "emoji": "🍚", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "yellow onions", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧅", "lastsFor": 42],
        ["emoji": "🍅", "name": "grape tomatoes", "lastsFor": 5, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 10, "name": "white mushrooms", "emoji": "🍄", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧅", "name": "sweet onions", "lastsFor": 12],
        ["lastsFor": 2, "emoji": "🌽", "name": "sweet corn cobs", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🌽", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "corn", "lastsFor": 7],
        ["lastsFor": 14, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "shallot", "emoji": "🧅"],
        ["emoji": "🥦", "name": "broccoli florets", "lastsFor": 7, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🥔", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 21, "name": "golden potatoes"],
        ["emoji": "🥔", "name": "russet potatoes", "lastsFor": 21, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "peeled garlic", "emoji": "🧄", "lastsFor": 21],
        ["lastsFor": 3, "name": "boston lettuce", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥬"],
        ["lastsFor": 7, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧅", "name": "diced yellow onions"],
        
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "curly mustard", "lastsFor": 30, "emoji": "🥬"],
        ["name": "lime", "emoji": "🍋", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 14],
        ["emoji": "🍋", "name": "lemons", "lastsFor": 21, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "seedless grapes", "emoji": "🍇", "lastsFor": 10],
        ["emoji": "🥭", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "name": "red mango"],
        ["name": "seedless watermelon", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "emoji": "🍉"],
        ["lastsFor": 14, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "navel oranges", "emoji": "🍊"],
        ["lastsFor": 14, "emoji": "🍏", "name": "granny smith apples", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🍎", "name": "gala apples", "lastsFor": 14, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🍉", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "name": "seeded red watermelon"],
        ["emoji": "🍐", "name": "barlett pear", "lastsFor": 10, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 10, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍐", "name": "bosc pear"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "sungold kiwi", "lastsFor": 14, "emoji": "🥝"],
        ["name": "honeydew melon", "lastsFor": 10, "emoji": "🍈", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🍱", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30, "name": "lunchables"],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🍖", "name": "ground beef", "lastsFor": 90],
        ["lastsFor": 90, "defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🐖", "name": "ground pork"],
        ["defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 30, "name": "smoked bacon", "emoji": "🥓"],
        ["name": "cracker crunchers", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 180, "emoji": "🍪"],
        ["emoji": "🇲🇽", "lastsFor": 6, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "nachos"],
        ["name": "chicken drumsticks", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 180, "emoji": "🍗"],
        ["name": "mashed potatos", "emoji": "🥔", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        ["emoji": "🦃", "name": "ground turkey", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 180],
        ["emoji": "🌭", "name": "italian sausage", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["emoji": "🌭", "lastsFor": 7, "name": "chinese sausage", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🌭", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "sausage"],
        ["emoji": "🦐", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "shrimp"],
        ["emoji": "🦐", "name": "frozen shrimp", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 365],
        ["name": "frito-lay", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍟", "lastsFor": 90],
        ["emoji": "🍟", "lastsFor": 90, "name": "tortilla chips", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🌭", "lastsFor": 6, "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "hot dog buns"],
        ["name": "potato chips", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍟", "lastsFor": 90],
        ["lastsFor": 210, "emoji": "🥫", "name": "barbecue sauce", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 7, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "white sliced bread", "emoji": "🍞"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "canned green beans", "emoji": "🥫", "lastsFor": 545],
        ["emoji": "🍪", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 45, "name": "oreos"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 90, "emoji": "🍟", "name": "flaming hot cheetos"],
        ["emoji": "🍅", "name": "diced tomatos", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 545],
        ["name": "chili", "emoji": "🌶", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        
        ["emoji": "🍔", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "burger buns", "lastsFor": 7],
        ["name": "honey maid grahm crackers", "lastsFor": 180, "emoji": "🍪", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 90, "name": "cheez it", "emoji": "🍟"],
        ["name": "cream of chicken soup", "emoji": "🍲", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 4],
        ["emoji": "🍟", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "pringles", "lastsFor": 90],
        ["name": "bbq potato chips", "lastsFor": 90, "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🍟"],
        ["lastsFor": 7, "emoji": "🍅", "name": "tomato paste", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "chicken broth", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍲", "lastsFor": 5],
        ["lastsFor": 7, "emoji": "🍲", "name": "vegetable broth", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "fat free skim milk", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["lastsFor": 14, "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "chocolate milk"],
        ["emoji": "🧀", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "sharp cheddar cheese", "lastsFor": 42],
        ["lastsFor": 42, "name": "cheddar", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧀"],
        ["lastsFor": 14, "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "yogurt"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥛", "lastsFor": 14, "name": "greek yogurt"],
        ["name": "pasteurized milk", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["name": "egg whites", "lastsFor": 5, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥚"],
        ["lastsFor": 21, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "american cheese", "emoji": "🧀"],
        ["name": "coffemate", "emoji": "☕️", "defaultSL": DefaultStorageLocation.changeMe.rawValue, "lastsFor": 545],
        ["name": "coffee creamer", "lastsFor": 14, "emoji": "☕️", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🥛", "name": "sour cream", "lastsFor": 21, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "unsalted butter", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧈", "lastsFor": 180],
        ["emoji": "🧈", "name": "salted butter", "lastsFor": 180, "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 10, "name": "cream cheese", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🧀"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "heavy cream", "lastsFor": 30, "emoji": "🥛"],
        ["name": "cinnamon rolls", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 2, "emoji": "🍬"],
        ["lastsFor": 14, "name": "chobani greek yogurt", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["lastsFor": 14, "emoji": "🥛", "name": "almond milk", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🥛", "lastsFor": 14, "name": "soy milk", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "oat milk", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["lastsFor": 7, "emoji": "🍪", "name": "buttermilk biscuits", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "macaroni salad", "lastsFor": 3, "emoji": "🥗"],
        ["name": "mustard potato salad", "emoji": "🥗", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["name": "chicken teneders", "defaultSL": DefaultStorageLocation.freezer.rawValue, "emoji": "🍗", "lastsFor": 180],
        ["name": "fresh mozerella", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 35, "emoji": "🧀"],
        ["name": "feta cheese", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "emoji": "🧀"],
        ["lastsFor": 14, "name": "pretzel", "emoji": "🥨", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🍞", "lastsFor": 7, "name": "dinner rolls", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥐", "lastsFor": 7, "name": "croissants"],
        ["lastsFor": 7, "name": "mini crossants", "emoji": "🥐", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        
        ["lastsFor": 7, "emoji": "🍪", "name": "chocolate chip cookies", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🍬", "lastsFor": 5, "name": "m&m cookies", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "flat bread", "lastsFor": 90, "emoji": "🍞"],
        ["name": "mini donuts", "emoji": "🍩", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["emoji": "🥧", "name": "apple pie", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 90],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "garlic naan flatbread", "lastsFor": 90, "emoji": "🍞"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "name": "bakery fresh goodness mini cinnamon rolls", "emoji": "🍬"],
        ["emoji": "🍪", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "sugar cookies", "lastsFor": 14],
        ["name": "reese's peanut butter cups", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🥜", "lastsFor": 180],
        ["emoji": "🍫", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 180, "name": "kitkat"],
        ["name": "m&ms", "emoji": "🍬", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 180],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥬", "name": "spinach", "lastsFor": 14],
        ["lastsFor": 240, "emoji": "🥓", "name": "bacon", "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["emoji": "🍬", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "cinnamon", "lastsFor": 1095],
        ["lastsFor": 4, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "bbq", "emoji": "🍖"],
        ["lastsFor": 180, "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "pork", "emoji": "🐖"],
        ["lastsFor": 35, "emoji": "🥚", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "eggs"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "emoji": "🥛", "name": "milk"],
        ["name": "soy milk", "emoji": "🥛", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["name": "creme caremal", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍮", "lastsFor": 4],
        ["emoji": "🥦", "lastsFor": 5, "name": "broccoli", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "onion", "emoji": "🧅", "lastsFor": 14],
        ["lastsFor": 7, "name": "donut", "emoji": "🍩", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "cherries", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7, "emoji": "🍒"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 14, "name": "green apple", "emoji": "🍏"],
        ["emoji": "🍌", "name": "banana", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 9],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥧", "lastsFor": 6, "name": "pumpkin pie"],
        ["name": "pastrys", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 7, "emoji": "🥐"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "cookies", "emoji": "🍪", "lastsFor": 21],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 180, "name": "taco shell", "emoji": "🌮"],
        ["name": "burrito", "emoji": "🌯", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5],
        ["name": "sugar", "emoji": "🍬", "lastsFor": 730, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["emoji": "🍎", "name": "apple sauce", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14],
        ["name": "bagels", "emoji": "🥐", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 7],
        ["emoji": "🐠", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "fish", "lastsFor": 3],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "cabbage", "emoji": "🥬", "lastsFor": 30],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "celery", "emoji": "🥬", "lastsFor": 21],
        ["lastsFor": 2, "name": "cat fish", "emoji": "🐟", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "chips", "emoji": "🍟", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 90],
        ["name": "chowder", "lastsFor": 3, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🍲"],
        ["name": "crab", "defaultSL": DefaultStorageLocation.freezer.rawValue, "lastsFor": 75, "emoji": "🦀"],
        ["defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 180, "emoji": "🥣", "name": "cereal"],
        ["lastsFor": 150, "name": "kimchi", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🇰🇷"],
        ["name": "dates", "lastsFor": 180, "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰"],
        ["emoji": "🥣", "lastsFor": 14, "name": "dips", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🍳", "lastsFor": 45, "name": "eggrolls", "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["lastsFor": 30, "name": "ginger", "emoji": "🥕", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "gnochhi", "emoji": "🍝", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 3],
        ["emoji": "🦆", "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "goose", "lastsFor": 120],
        ["lastsFor": 120, "emoji": "🍫", "defaultSL": DefaultStorageLocation.pantry.rawValue, "name": "granola"],
        ["lastsFor": 7, "name": "green beans", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰", "lastsFor": 5, "name": "beans"],
        ["name": "guacamole", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥑", "lastsFor": 12],
        ["emoji": "🐖", "name": "ham", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 7],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥖", "name": "italian bread", "lastsFor": 90],
        ["emoji": "🥫", "name": "jam", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30],
        ["emoji": "🥫", "lastsFor": 30, "name": "jelly", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["name": "jalapeno", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌶", "lastsFor": 14],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "ketchup", "emoji": "🥫", "lastsFor": 180],
        ["name": "kiwi", "emoji": "🥝", "lastsFor": 6, "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "lobster", "emoji": "🦞", "lastsFor": 180, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["emoji": "🐑", "defaultSL": DefaultStorageLocation.freezer.rawValue, "name": "lamb", "lastsFor": 180],
        ["name": "lasagna", "emoji": "🍝", "lastsFor": 90, "defaultSL": DefaultStorageLocation.freezer.rawValue],
        ["lastsFor": 1, "emoji": "🥤", "name": "milkshake", "defaultSL": DefaultStorageLocation.pantry.rawValue],
        ["name": "pancake mix", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 365, "emoji": "🥞"],
        ["name": "quesadila", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌮", "lastsFor": 4],
        ["lastsFor": 270, "name": "waffles", "defaultSL": DefaultStorageLocation.pantry.rawValue, "emoji": "🧇"],
        ["lastsFor": 270, "emoji": "🍣", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "name": "wasabi paste"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🌰", "name": "walnuts", "lastsFor": 180],
        ["name": "goat cheese", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 21, "emoji": "🧀"],
        ["defaultSL": DefaultStorageLocation.refrigerator.rawValue, "emoji": "🥭", "name": "fig", "lastsFor": 3],
        ["lastsFor": 10, "name": "cottage cheese", "emoji": "🧀", "defaultSL": DefaultStorageLocation.refrigerator.rawValue],
        ["emoji": "🌰", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 5, "name": "refried beans"],
        ["name": "bell peppers", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 14, "emoji": "🌶"],
        ["name": "sweet potatoes", "emoji": "🍠", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 14],
        ["emoji": "🍙", "defaultSL": DefaultStorageLocation.refrigerator.rawValue, "lastsFor": 30, "name": "rice cake"],
        ["emoji": "🍠", "defaultSL": DefaultStorageLocation.pantry.rawValue, "lastsFor": 30, "name": "purple yam"]]
    
    @Binding var image: [CGImage]?
    @Binding var showingView: String?
    @State var ref: DocumentReference!
    @State var foodsToDisplay = [refrigeItem]()
    @State private var animateActivityIndicator = true
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocations: FetchedResults<StorageLocation>
    
    func getRandomEmoji () -> String{
        let listOfEmojis = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚"),emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢"),emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
        return listOfEmojis.randomElement()!.emoji
        
    }
func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
    func contains(x: Int, numerator: Int)-> Bool{
        var returnObj = false
        for index in 1...numerator{
            if index == x{
                returnObj = true
            }
        }
        return returnObj
    }
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
    if contains(x: Int.random(in: 1...denomenator.newBottom), numerator: denomenator.newTop) {
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
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color("whiteAndBlack")
                ScrollView(.vertical, showsIndicators: false, content: {
                    ZStack{
                        VStack {
                            
                            Image(uiImage: UIImage(cgImage: self.image![0]))
                                .resizable()
                                .padding()
                                .aspectRatio(contentMode: .fit)
                                .scaledToFit()
                                .frame(width: geo.size.width, height: geo.size.width, alignment: .top)
                            
                            ForEach(self.foodsToDisplay) { food in
                                DetectItemCell(foodsToDisplay: self.$foodsToDisplay, index: self.foodsToDisplay.firstIndex(of: food)!, icon: food.icon, title: food.title, lastsFor: food.daysLeft)
                            }
                            Spacer()
                            
                            Button(action: {
                                if let strg = self.storageLocations.first{
                                    self.foodsToDisplay.append(refrigeItem(icon: "⍰", title: "to be named", daysLeft: 7, addToStorage: strg))
                                }else {
                                    //TODO: add error message asking to add storage location
                                }
                            }, label: {
                                Image("plus")
                                    .renderingMode(.original)
                            }).onDisappear{
                                print("DISSAPEARED")
                                self.showingView = "fridge"
                            }
                            
                            Button(action: {
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                                self.showingView = "fridge"
                                for i in self.foodsToDisplay{
                                    let id = UUID()
                                    let newFoodItem = FoodItem(context: self.managedObjectContext)
                                    newFoodItem.staysFreshFor = Int16(i.daysLeft)
                                    newFoodItem.symbol = i.icon
                                    newFoodItem.name = i.title
                                    newFoodItem.inStorageSince = Date()
                                    newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                    newFoodItem.origion?.storageName = i.addToStorage.wrappedStorageName
                                    newFoodItem.origion?.symbolName = i.addToStorage.wrappedSymbolName
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
                            }, label: {
                                Image("addOrange")
                                    .renderingMode(.original)
                            })
                                .padding(.top, 200)
                            
                            NavigationLink(destination: RefrigeratorView(showingView: self.$showingView, scan: self.$scan, image: self.$image), label: {
                                Text("Cancel")
                                
                            }).padding()
                                .simultaneousGesture(TapGesture().onEnded{
                                    self.showingView = "fridge"
                                    
                                })
                            
                        }
                            
                            .onAppear(perform: {//TODO: FIX THE DEFAULT STORAGE LOCATIONS
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
                                    
                                    DispatchQueue.main.async {
                                        let images = (0..<self.scan!.pageCount).compactMap({ self.scan!.imageOfPage(at: $0).cgImage })
                                        
                                        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                                            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                                                print("The observations are of an unexpected type.")
                                                return
                                            }
                                            for observation in observations {
                                                var checkSecondArray = true
                                                guard let bestCandidate = observation.topCandidates(1).first else { continue }
                                                //                            for (word,emoji) in self.newArrayOfFoods {
                                                //                                if bestCandidate.string.lowercased().contains(word) {
                                                //                                    self.foodsToDisplay.append(refrigeItem(icon: emoji, title: bestCandidate.string, daysLeft: 7))
                                                //                                    print("found and appended: \(bestCandidate.string)")
                                                //                                    break
                                                //                                }else {
                                                //                                    print("found but not appended: \(bestCandidate.string)")
                                                //                                }
                                                //                            }
                                                for line in self.newerArrayOfFoods{
                                                    //TODO: HERE RUN ML MODEL TO TRY TO FIND SHORTENED WORDS
                                                    
                                                    if bestCandidate.string.lowercased().contains(line["name"] as? String ?? "") {
                                                        if let stg = self.storageLocations.first{
                                                            if line["defaultSL"] as? String ?? "refrigerator" == "refrigerator" {
                                                                self.foodsToDisplay.append(refrigeItem(icon: line["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: line["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultFridge ?? stg)))
                                                            } else if line["defaultSL"] as? String ?? "refrigerator" == "freezer"{
                                                                self.foodsToDisplay.append(refrigeItem(icon: line["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: line["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultFreezer ?? stg)))
                                                            } else {
                                                                self.foodsToDisplay.append(refrigeItem(icon: line["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: line["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultPantry ?? stg)))
                                                            }
                                                        }
                                                        print("found and appended: \(bestCandidate.string)")
                                                        checkSecondArray = false
                                                        break
                                                    }else {
                                                        print("found but not appended: \(bestCandidate.string)")
                                                    }
                                                }
                                                if checkSecondArray{
                                                    if let secArray = secondArray{
                                                    print("countssss: \(secArray.count)")
                                                    for index in 0...secArray.count - 1{
                                                        print("nametest: \(((secArray[index])["name"] as? String) ?? "")")
                                                        if bestCandidate.string.lowercased().contains(((secArray[index])["name"] as? String) ?? "") {
                                                            
                                                            if let stg = self.storageLocations.first{
                                                                if (secArray[index])["defaultSL"] as? String ?? "refrigerator" == "refrigerator" {
                                                                    self.foodsToDisplay.append(refrigeItem(icon: (secArray[index])["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: (secArray[index])["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultFridge ?? stg)))
                                                                } else if (secArray[index])["defaultSL"] as? String ?? "refrigerator" == "freezer"{
                                                                    self.foodsToDisplay.append(refrigeItem(icon: (secArray[index])["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: (secArray[index])["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultFreezer ?? stg)))
                                                                } else {
                                                                    self.foodsToDisplay.append(refrigeItem(icon: (secArray[index])["emoji"] as? String ?? "", title: bestCandidate.string.lowercased(), daysLeft: (secArray[index])["lastsFor"] as? Int ?? 7, addToStorage: (self.user.first?.defaultPantry ?? stg)))
                                                                }
                                                            }
                                                            //                                                self.foodsToDisplay.append(refrigeItem(icon: (((secArray[index])["emoji"] as? String) ?? ""), title: bestCandidate.string, daysLeft: (secArray[index])["lastsFor"] as? Int ?? 7, addToStorage: self.storageIndex))
                                                            print("found and appended: \(bestCandidate.string)")
                                                            break
                                                        }else {
                                                            print("found but not appended: \(bestCandidate.string)")
                                                        }
                                                    }
                                                    
                                                }
                                                }
                                                
                                            }
                                            self.animateActivityIndicator = false
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
                                }
                                
                                
                                if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 3 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "ExamineRecieptViewLoadedAd") == false{
                                    self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
                                    self.interstitial.delegate = self.adDelegate
                                    
                                    let req = GADRequest()
                                    self.interstitial.load(req)
                                    
                                    UserDefaults.standard.set(true, forKey: "ExamineRecieptViewLoadedAd")
                                    
                                }else {
                                    
                                }
                                
                                
                                
                                
                            })
                        
                    }.navigationBarTitle(Text("Analyze Reciepts"))
                }
                )
                
            }
            .overlay(ActivityIndicator(shouldAnimate: self.$animateActivityIndicator))
        }
        
    }
}


struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        // Create UIActivityIndicatorView
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
