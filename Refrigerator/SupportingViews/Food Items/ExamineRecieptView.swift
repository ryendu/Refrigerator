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
    
    var newerArrayOfFoods: [[String:Any]] = [
        ["emoji": "🥚", "lastsFor": 28, "name": "eggs", "defaultSL": "refrigerator"], ["emoji": "🍞", "defaultSL": "refrigerator", "lastsFor": 5, "name": "bread"], ["defaultSL": "refrigerator", "name": "cake", "lastsFor": 3, "emoji": "🎂"], ["emoji": "🍉", "defaultSL": "refrigerator", "name": "watermelon", "lastsFor": 3], ["defaultSL": "refrigerator", "lastsFor": 7, "name": "grapes", "emoji": "🍇"], ["name": "chicken wings", "emoji": "🍗", "defaultSL": "refrigerator", "lastsFor": 4], ["name": "cup cake", "lastsFor": 7, "emoji": "🧁", "defaultSL": "refrigerator"], ["name": "pizza", "emoji": "🍕", "lastsFor": 3, "defaultSL": "refrigerator"], ["name": "hot dog", "emoji": "🌭", "defaultSL": "refrigerator", "lastsFor": 7], ["emoji": "🐟", "lastsFor": 12, "defaultSL": "refrigerator", "name": "caviar"], ["lastsFor": 42, "defaultSL": "refrigerator", "emoji": "🧀", "name": "parmesean"], ["emoji": "🧀", "lastsFor": 42, "name": "cheese", "defaultSL": "refrigerator"], ["name": "bbq", "emoji": "🍖", "defaultSL": "refrigerator", "lastsFor": 3], ["defaultSL": "refrigerator", "lastsFor": 2, "emoji": "🐖", "name": "pork"], ["name": "milk", "defaultSL": "refrigerator", "emoji": "🥛", "lastsFor": 6], ["emoji": "🥛", "defaultSL": "refrigerator", "lastsFor": 6, "name": "soy milk"], ["defaultSL": "refrigerator", "name": "creme caremal", "lastsFor": 2, "emoji": "🍮"], ["emoji": "🥦", "lastsFor": 6, "defaultSL": "refrigerator", "name": "brocolie"], ["name": "onion", "lastsFor": 8, "defaultSL": "refrigerator", "emoji": "🧅"], ["defaultSL": "refrigerator", "lastsFor": 7, "name": "donut", "emoji": "🍩"], ["emoji": "🍒", "lastsFor": 7, "defaultSL": "refrigerator", "name": "cherries"], ["defaultSL": "pantry", "lastsFor": 6, "emoji": "🍏", "name": "green apple"], ["defaultSL": "pantry", "name": "banana", "lastsFor": 4, "emoji": "🍌"], ["defaultSL": "refrigerator", "emoji": "🥕", "name": "carrot", "lastsFor": 14], ["defaultSL": "refrigerator", "emoji": "🥧", "lastsFor": 3, "name": "pumpkin pie"], ["defaultSL": "pantry", "name": "pastries", "lastsFor": 2, "emoji": "🥐"], ["emoji": "🍪", "lastsFor": 14, "defaultSL": "pantry", "name": "cookies"], ["defaultSL": "pantry", "lastsFor": 10, "emoji": "🍊", "name": "mandarine"], ["lastsFor": 14, "emoji": "🥬", "name": "spinach", "defaultSL": "refrigerator"], ["lastsFor": 4, "emoji": "🥬", "name": "bok choy", "defaultSL": "refrigerator"], ["defaultSL": "pantry", "emoji": "🍜", "name": "ramen", "lastsFor": 365], ["defaultSL": "pantry", "emoji": "🍜", "lastsFor": 180, "name": "noodles"], ["emoji": "🥙", "name": "chipotle", "defaultSL": "refrigerator", "lastsFor": 3], ["defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🌮", "name": "taco"], ["defaultSL": "refrigerator", "lastsFor": 3, "name": "burrito", "emoji": "🌯"], ["name": "sugar", "defaultSL": "pantry", "emoji": "🍬", "lastsFor": 730], ["lastsFor": 5, "emoji": "🥭", "defaultSL": "refrigerator", "name": "mango"], ["lastsFor": 7, "defaultSL": "refrigerator", "emoji": "🌲", "name": "asparagus"], ["name": "acorn squash", "defaultSL": "refrigerator", "emoji": "🌰", "lastsFor": 14], ["emoji": "🌰", "name": "almond", "lastsFor": 730, "defaultSL": "pantry"], ["emoji": "🍎", "defaultSL": "refrigerator", "name": "apple saurce", "lastsFor": 14], ["defaultSL": "pantry", "name": "asian noodles", "emoji": "🍜", "lastsFor": 730], ["name": "cantaloupe", "lastsFor": 8, "emoji": "🍈", "defaultSL": "refrigerator"], ["name": "tuna", "lastsFor": 3, "defaultSL": "refrigerator", "emoji": "🐟"], ["lastsFor": 75, "emoji": "🧃", "defaultSL": "refrigerator", "name": "apple juice"], ["defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🥑", "name": "avocado roll"], ["lastsFor": 14, "defaultSL": "refrigerator", "emoji": "🥓", "name": "bacon"], ["lastsFor": 1105, "name": "black beans", "defaultSL": "pantry", "emoji": "🌰"], ["name": "bagels", "emoji": "🥐", "defaultSL": "pantry", "lastsFor": 5], ["defaultSL": "refrigerator", "name": "baked beans", "emoji": "🌰", "lastsFor": 3], ["name": "beer", "emoji": "🍺", "lastsFor": 210, "defaultSL": "pantry"], ["defaultSL": "refrigerator", "emoji": "🐠", "name": "fish", "lastsFor": 3], ["name": "cabbage", "emoji": "🥬", "lastsFor": 40, "defaultSL": "refrigerator"], ["emoji": "🥬", "name": "celery", "defaultSL": "refrigerator", "lastsFor": 24], ["name": "cat fish", "defaultSL": "refrigerator", "emoji": "🐟", "lastsFor": 3], ["emoji": "🍟", "defaultSL": "pantry", "lastsFor": 75, "name": "chips"], ["name": "chocolate", "lastsFor": 365, "emoji": "🍫", "defaultSL": "pantry"], ["name": "chowder", "defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🍲"], ["lastsFor": 2, "emoji": "🦪", "defaultSL": "refrigerator", "name": "clams"], ["name": "coffee", "lastsFor": 3, "emoji": "☕️", "defaultSL": "refrigerator"], ["lastsFor": 2, "defaultSL": "refrigerator", "name": "corn", "emoji": "🌽"], ["defaultSL": "refrigerator", "lastsFor": 2, "emoji": "🦀", "name": "crab"], ["emoji": "🍛", "defaultSL": "pantry", "lastsFor": 90, "name": "curry"], ["emoji": "🥣", "name": "cereal", "lastsFor": 90, "defaultSL": "pantry"], ["name": "kimchi", "lastsFor": 135, "emoji": "🇰🇷", "defaultSL": "refrigerator"], ["emoji": "🌰", "lastsFor": 270, "name": "dates", "defaultSL": "refrigerator"], ["name": "dips", "defaultSL": "refrigerator", "lastsFor": 7, "emoji": "🥣"], ["name": "duck", "emoji": "🦆", "defaultSL": "refrigerator", "lastsFor": 8], ["name": "dumplings", "defaultSL": "freezer", "emoji": "🥟", "lastsFor": 90], ["defaultSL": "refrigerator", "emoji": "🍩", "lastsFor": 7, "name": "donuts"], ["emoji": "🥘", "name": "enchilada", "lastsFor": 4, "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "lastsFor": 3, "name": "eggrolls", "emoji": "🍳"], ["name": "english muffins", "defaultSL": "pantry", "lastsFor": 14, "emoji": "🧁"], ["name": "muffins", "emoji": "🧁", "lastsFor": 7, "defaultSL": "refrigerator"], ["emoji": "🥬", "name": "edamame", "lastsFor": 365, "defaultSL": "freezer"], ["emoji": "🍣", "name": "sushi", "defaultSL": "refrigerator", "lastsFor": 3], ["lastsFor": 42, "name": "fondue", "emoji": "🧀", "defaultSL": "pantry"], ["emoji": "🍞", "defaultSL": "freezer", "lastsFor": 90, "name": "french toast"], ["lastsFor": 21, "emoji": "🧄", "name": "garlic", "defaultSL": "refrigerator"], ["emoji": "🥕", "defaultSL": "refrigerator", "name": "ginger", "lastsFor": 14], ["emoji": "🍝", "name": "gnochhi", "lastsFor": 30, "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "lastsFor": 8, "emoji": "🦆", "name": "goose"], ["name": "granola", "lastsFor": 180, "defaultSL": "pantry", "emoji": "🍫"], ["defaultSL": "refrigerator", "emoji": "🌰", "lastsFor": 7, "name": "green beans"], ["defaultSL": "refrigerator", "name": "beans", "lastsFor": 4, "emoji": "🌰"], ["emoji": "🥑", "lastsFor": 2, "defaultSL": "refrigerator", "name": "guacamole"], ["lastsFor": 210, "emoji": "🍘", "name": "grahm crackers", "defaultSL": "pantry"], ["lastsFor": 5, "name": "ham", "defaultSL": "refrigerator", "emoji": "🐖"], ["lastsFor": 2, "emoji": "🍔", "defaultSL": "refrigerator", "name": "hamburger"], ["emoji": "🍯", "lastsFor": 99999, "defaultSL": "pantry", "name": "honey"], ["name": "hashbrowns", "lastsFor": 365, "defaultSL": "freezer", "emoji": "🍟"], ["emoji": "🥫", "name": "hummus", "defaultSL": "refrigerator", "lastsFor": 7], ["emoji": "🍲", "defaultSL": "refrigerator", "name": "irish stew", "lastsFor": 3], ["lastsFor": 4, "name": "indian food", "defaultSL": "refrigerator", "emoji": "🇮🇳"], ["defaultSL": "pantry", "name": "italian bread", "emoji": "🥖", "lastsFor": 3], ["defaultSL": "pantry", "name": "jam", "emoji": "🥫", "lastsFor": 365], ["name": "jelly", "emoji": "🥫", "defaultSL": "refrigerator", "lastsFor": 270], ["emoji": "🥓", "lastsFor": 730, "name": "jerky", "defaultSL": "pantry"], ["lastsFor": 3, "name": "jalapeno", "defaultSL": "refrigerator", "emoji": "🌶"], ["defaultSL": "refrigerator", "lastsFor": 6, "emoji": "🥬", "name": "kale"], ["defaultSL": "refrigerator", "name": "ketchup", "emoji": "🥫", "lastsFor": 180], ["name": "kiwi", "emoji": "🥝", "lastsFor": 28, "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🐠", "name": "kingfish"], ["defaultSL": "refrigerator", "emoji": "🦞", "lastsFor": 4, "name": "lobster"], ["name": "lamb", "defaultSL": "refrigerator", "emoji": "🐑", "lastsFor": 5], ["emoji": "🍝", "lastsFor": 210, "defaultSL": "freezer", "name": "lasagna"], ["emoji": "🍖", "name": "meatballs", "lastsFor": 90, "defaultSL": "freezer"], ["lastsFor": 2, "emoji": "🥤", "name": "milkshake", "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "emoji": "🍕", "name": "peperoni", "lastsFor": 21], ["lastsFor": 3, "name": "panckaes", "emoji": "🥞", "defaultSL": "refrigerator"], ["emoji": "🍝", "defaultSL": "refrigerator", "lastsFor": 4, "name": "spaghetti"], ["emoji": "🍟", "name": "tatter tots", "lastsFor": 270, "defaultSL": "freezer"], ["name": "toast", "lastsFor": 7, "emoji": "🍞", "defaultSL": "refrigerator"], ["lastsFor": 365, "name": "udon noodles", "defaultSL": "pantry", "emoji": "🍜"], ["lastsFor": 365, "emoji": "🍜", "defaultSL": "pantry", "name": "udon"], ["defaultSL": "freezer", "lastsFor": 270, "emoji": "🥩", "name": "venison"], ["name": "wasabi", "emoji": "🍣", "defaultSL": "refrigerator", "lastsFor": 365], ["name": "wine", "defaultSL": "pantry", "emoji": "🍷", "lastsFor": 1095], ["defaultSL": "refrigerator", "name": "walnuts", "lastsFor": 180, "emoji": "🌰"], ["lastsFor": 14, "name": "yogurt", "defaultSL": "refrigerator", "emoji": "🥛"], ["emoji": "🍝", "lastsFor": 60, "name": "ziti", "defaultSL": "freezer"], ["name": "zucchini", "defaultSL": "refrigerator", "lastsFor": 5, "emoji": "🥒"], ["lastsFor": 4, "emoji": "🍊", "name": "ugli", "defaultSL": "refrigerator"], ["name": "tangerine", "lastsFor": 10, "emoji": "🍊", "defaultSL": "pantry"], ["defaultSL": "pantry", "name": "oatmeal", "lastsFor": 550, "emoji": "🥣"], ["name": "goat cheese", "defaultSL": "refrigerator", "emoji": "🧀", "lastsFor": 21], ["emoji": "🍄", "defaultSL": "refrigerator", "lastsFor": 10, "name": "mushrooms"], ["defaultSL": "refrigerator", "lastsFor": 5, "name": "pears", "emoji": "🍐"], ["name": "raspberry", "emoji": "🍇", "defaultSL": "refrigerator", "lastsFor": 5], ["defaultSL": "refrigerator", "name": "strawberry", "lastsFor": 7, "emoji": "🍓"], ["emoji": "🥭", "defaultSL": "refrigerator", "name": "fig", "lastsFor": 3], ["name": "passion fruit", "lastsFor": 14, "defaultSL": "refrigerator", "emoji": "🍊"], ["emoji": "🌰", "name": "pineuts", "lastsFor": 60, "defaultSL": "pantry"], ["emoji": "🍐", "defaultSL": "pantry", "lastsFor": 120, "name": "olives"], ["emoji": "🧀", "name": "cottage cheese", "defaultSL": "refrigerator", "lastsFor": 14], ["emoji": "🌰", "defaultSL": "refrigerator", "name": "refried beans", "lastsFor": 4], ["defaultSL": "refrigerator", "lastsFor": 14, "name": "bell peppers", "emoji": "🌶"], ["emoji": "🐠", "lastsFor": 2, "name": "salmon", "defaultSL": "refrigerator"], ["lastsFor": 5, "defaultSL": "refrigerator", "emoji": "🍍", "name": "pineapple"], ["defaultSL": "refrigerator", "emoji": "🍠", "name": "sweet potatoes", "lastsFor": 14], ["lastsFor": 21, "emoji": "🍙", "defaultSL": "pantry", "name": "rice cake"], ["emoji": "🍡", "defaultSL": "freezer", "name": "mochi", "lastsFor": 14], ["name": "pinto beans", "defaultSL": "pantry", "lastsFor": 720, "emoji": "🌰"], ["lastsFor": 14, "name": "coconut", "defaultSL": "refrigerator", "emoji": "🥥"], ["defaultSL": "refrigerator", "emoji": "🍠", "lastsFor": 21, "name": "purple yam"], ["emoji": "🐡", "lastsFor": 2, "name": "urchins", "defaultSL": "refrigerator"], ["defaultSL": "pantry", "emoji": "🍐", "lastsFor": 7, "name": "umbrella fruit"], ["defaultSL": "refrigerator", "name": "papaya", "emoji": "🥭", "lastsFor": 7], ["lastsFor": 5, "emoji": "🥩", "defaultSL": "refrigerator", "name": "steak"], ["defaultSL": "pantry", "emoji": "🍬", "lastsFor": 365, "name": "extreme candy"], ["defaultSL": "refrigerator", "emoji": "🌶", "lastsFor": 1095, "name": "hot sauce"], ["emoji": "🥫", "lastsFor": 30, "defaultSL": "refrigerator", "name": "xo sauce"], ["lastsFor": 3, "emoji": "🦐", "name": "shrimp", "defaultSL": "refrigerator"], ["emoji": "🥬", "defaultSL": "refrigerator", "lastsFor": 8, "name": "parsley"], ["defaultSL": "refrigerator", "emoji": "🥓", "lastsFor": 14, "name": "sausage"], ["defaultSL": "refrigerator", "emoji": "🍅", "lastsFor": 10, "name": "tomato"], ["name": "tapioca pearls", "lastsFor": 365, "emoji": "⚫️", "defaultSL": "refrigerator"], ["lastsFor": 28, "defaultSL": "refrigerator", "emoji": "🌮", "name": "tortillas"], ["name": "vanilla", "defaultSL": "pantry", "lastsFor": 1825, "emoji": "🍨"], ["emoji": "🍟", "lastsFor": 3, "name": "fries", "defaultSL": "refrigerator"], ["emoji": "🍄", "lastsFor": 10, "name": "mushroom", "defaultSL": "refrigerator"], ["name": "radish", "lastsFor": 14, "emoji": "🥕", "defaultSL": "refrigerator"], ["name": "oranges", "lastsFor": 10, "emoji": "🍊", "defaultSL": "pantry"], ["lastsFor": 30, "name": "potato", "defaultSL": "refrigerator", "emoji": "🥔"], ["lastsFor": 14, "emoji": "🍇", "name": "blueberries", "defaultSL": "refrigerator"], ["name": "blackberries", "emoji": "🍇", "defaultSL": "refrigerator", "lastsFor": 6], ["name": "brandy", "defaultSL": "refrigerator", "emoji": "🍺", "lastsFor": 180], ["lastsFor": 120, "name": "butter", "defaultSL": "refrigerator", "emoji": "🧈"], ["lastsFor": 10, "emoji": "🥕", "name": "beets", "defaultSL": "refrigerator"], ["name": "cider", "defaultSL": "pantry", "emoji": "🍺", "lastsFor": 365], ["name": "cauliflower", "lastsFor": 14, "emoji": "🥦", "defaultSL": "refrigerator"], ["lastsFor": 2, "name": "clam", "defaultSL": "refrigerator", "emoji": "🐚"], ["name": "cranberries", "lastsFor": 21, "defaultSL": "refrigerator", "emoji": "🍇"], ["lastsFor": 60, "emoji": "🥫", "name": "dressing", "defaultSL": "refrigerator"], ["name": "doritos", "defaultSL": "pantry", "lastsFor": 90, "emoji": "🍟"], ["defaultSL": "pantry", "lastsFor": 90, "emoji": "🍟", "name": "cheetos"], ["defaultSL": "pantry", "emoji": "🍟", "name": "takis", "lastsFor": 90], ["name": "juice", "emoji": "🧃", "defaultSL": "refrigerator", "lastsFor": 30], ["name": "lettuce", "defaultSL": "refrigerator", "emoji": "🥬", "lastsFor": 14], ["name": "mayonnaise", "lastsFor": 90, "emoji": "🥫", "defaultSL": "refrigerator"], ["lastsFor": 35, "defaultSL": "refrigerator", "emoji": "🧀", "name": "mozzarella"], ["defaultSL": "refrigerator", "emoji": "🍜", "lastsFor": 3, "name": "macaroon"], ["lastsFor": 60, "name": "mustard", "emoji": "🥫", "defaultSL": "refrigerator"], ["name": "meatloaf", "lastsFor": 4, "defaultSL": "refrigerator", "emoji": "🍖"], ["name": "popcorn", "emoji": "🍿", "defaultSL": "pantry", "lastsFor": 60], ["defaultSL": "pantry", "lastsFor": 4, "name": "peaches", "emoji": "🍑"], ["name": "pretzels", "defaultSL": "pantry", "lastsFor": 14, "emoji": "🥨"], ["lastsFor": 210, "emoji": "🧊", "defaultSL": "freezer", "name": "popsicle"], ["defaultSL": "refrigerator", "emoji": "🍎", "lastsFor": 60, "name": "pomegranate"], ["emoji": "🥚", "defaultSL": "refrigerator", "lastsFor": 30, "name": "quail egg"], ["emoji": "🍺", "name": "rum", "defaultSL": "pantry", "lastsFor": 180], ["emoji": "🍇", "defaultSL": "refrigerator", "lastsFor": 180, "name": "raisins"], ["defaultSL": "refrigerator", "lastsFor": 5, "emoji": "🥟", "name": "ravioli"], ["defaultSL": "refrigerator", "emoji": "🥪", "lastsFor": 3, "name": "sandwich"], ["name": "turkey", "emoji": "🦃", "defaultSL": "refrigerator", "lastsFor": 5], ["name": "frosting", "emoji": "🧁", "defaultSL": "refrigerator", "lastsFor": 90], ["defaultSL": "refrigerator", "name": "fudge", "emoji": "🍫", "lastsFor": 21], ["defaultSL": "pantry", "emoji": "🌾", "lastsFor": 365, "name": "flour"], ["emoji": "🍲", "defaultSL": "refrigerator", "name": "gravy", "lastsFor": 4], ["lastsFor": 180, "name": "grapefruit", "emoji": "🍊", "defaultSL": "refrigerator"], ["emoji": "🥩", "defaultSL": "freezer", "name": "ground beef", "lastsFor": 120], ["defaultSL": "pantry", "lastsFor": 180, "emoji": "🌰", "name": "hazelnut"], ["defaultSL": "freezer", "name": "burgers", "lastsFor": 150, "emoji": "🍔"], ["emoji": "🍠", "defaultSL": "refrigerator", "lastsFor": 120, "name": "turnip"], ["defaultSL": "pantry", "emoji": "🍝", "lastsFor": 720, "name": "pasta"], ["name": "breadfruit", "emoji": "🍐", "lastsFor": 4, "defaultSL": "refrigerator"], ["emoji": "🌾", "defaultSL": "pantry", "name": "buckwheat", "lastsFor": 60], ["name": "cucumber", "lastsFor": 14, "emoji": "🥒", "defaultSL": "refrigerator"], ["lastsFor": 21, "name": "lemons", "emoji": "🍋", "defaultSL": "refrigerator"], ["lastsFor": 2, "emoji": "🍰", "defaultSL": "refrigerator", "name": "red velvet cake"], ["lastsFor": 7, "defaultSL": "refrigerator", "emoji": "🍋", "name": "star fruit"], ["emoji": "🍎", "name": "dragon fruit", "defaultSL": "refrigerator", "lastsFor": 14], ["name": "peanut butter", "lastsFor": 180, "emoji": "🥜", "defaultSL": "refrigerator"], ["emoji": "🥧", "name": "oreo pie", "lastsFor": 3, "defaultSL": "refrigerator"], ["lastsFor": 5, "defaultSL": "refrigerator", "emoji": "🧀", "name": "cheese cake"], ["name": "brownies", "emoji": "🍫", "lastsFor": 4, "defaultSL": "pantry"], ["emoji": "🥫", "name": "sauce", "lastsFor": 240, "defaultSL": "refrigerator"], ["lastsFor": 545, "emoji": "🥒", "defaultSL": "refrigerator", "name": "pickles"], ["lastsFor": 6, "defaultSL": "refrigerator", "name": "peas", "emoji": "🌰"], ["lastsFor": 1460, "name": "rice", "emoji": "🍚", "defaultSL": "pantry"], ["lastsFor": 90, "emoji": "🇨🇳", "defaultSL": "freezer", "name": "chinese food"], ["defaultSL": "freezer", "emoji": "🇯🇵", "name": "japanese food", "lastsFor": 60], ["lastsFor": 4, "emoji": "🐣", "name": "chicken soup", "defaultSL": "refrigerator"], ["emoji": "🍜", "name": "chicken noodle soup", "defaultSL": "refrigerator", "lastsFor": 4], ["emoji": "🍇", "lastsFor": 7, "defaultSL": "refrigerator", "name": "grape"], ["defaultSL": "refrigerator", "name": "brussel sprouts", "lastsFor": 4, "emoji": "🥬"], ["defaultSL": "refrigerator", "emoji": "🥗", "name": "corn salad", "lastsFor": 5], ["defaultSL": "refrigerator", "name": "dill", "emoji": "🥬", "lastsFor": 7], ["emoji": "🥬", "defaultSL": "refrigerator", "name": "sea beet", "lastsFor": 14], ["lastsFor": 7, "emoji": "🌾", "name": "wheatgrass", "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "emoji": "🍈", "name": "bittermelon", "lastsFor": 5], ["emoji": "🍆", "defaultSL": "refrigerator", "name": "eggplant", "lastsFor": 9], ["defaultSL": "refrigerator", "name": "olive fruit", "emoji": "🍐", "lastsFor": 30], ["name": "pumpkin", "emoji": "🎃", "lastsFor": 70, "defaultSL": "pantry"], ["lastsFor": 10, "emoji": "🌶", "defaultSL": "refrigerator", "name": "sweet pepper"], ["lastsFor": 180, "emoji": "🍈", "name": "winter melon", "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "lastsFor": 4, "name": "chickpeas", "emoji": "🌰"], ["lastsFor": 7, "emoji": "🌰", "defaultSL": "refrigerator", "name": "common peas"], ["emoji": "🌰", "lastsFor": 5, "name": "indian pea", "defaultSL": "refrigerator"], ["name": "peanut", "emoji": "🥜", "lastsFor": 28, "defaultSL": "pantry"], ["defaultSL": "refrigerator", "name": "soybean", "emoji": "🌰", "lastsFor": 7], ["lastsFor": 14, "name": "chives", "defaultSL": "refrigerator", "emoji": "🥬"], ["defaultSL": "refrigerator", "name": "garlic chives", "emoji": "🥬", "lastsFor": 10], ["lastsFor": 10, "name": "lemon grass", "emoji": "🥬", "defaultSL": "refrigerator"], ["emoji": "🥬", "name": "leek", "lastsFor": 14, "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "emoji": "🥥", "name": "lotus root", "lastsFor": 7], ["defaultSL": "refrigerator", "emoji": "🧅", "name": "pearl onion", "lastsFor": 30], ["lastsFor": 14, "defaultSL": "refrigerator", "name": "spring onion", "emoji": "🧅"], ["defaultSL": "refrigerator", "lastsFor": 30, "name": "green onion", "emoji": "🧅"], ["lastsFor": 1460, "defaultSL": "pantry", "name": "mondrian wild rice", "emoji": "🍚"], ["defaultSL": "refrigerator", "emoji": "🎍", "lastsFor": 14, "name": "bamboo shoot"], ["name": "beetroot", "lastsFor": 10, "defaultSL": "refrigerator", "emoji": "🥕"], ["name": "cassava", "defaultSL": "pantry", "emoji": "🥕", "lastsFor": 7], ["lastsFor": 90, "name": "horseradish", "emoji": "🥕", "defaultSL": "refrigerator"], ["lastsFor": 14, "name": "parsnip", "emoji": "🥕", "defaultSL": "refrigerator"], ["defaultSL": "pantry", "emoji": "🍵", "name": "tea", "lastsFor": 720], ["lastsFor": 60, "name": "biscuit", "emoji": "🍪", "defaultSL": "pantry"], ["lastsFor": 120, "emoji": "🥩", "name": "meat", "defaultSL": "freezer"], ["emoji": "🐖", "name": "pork chop", "lastsFor": 210, "defaultSL": "freezer"], ["name": "wontons", "defaultSL": "freezer", "lastsFor": 120, "emoji": "🥟"], ["lastsFor": 120, "emoji": "🥟", "defaultSL": "freezer", "name": "frozen dumplings"], ["emoji": "🌾", "lastsFor": 4, "name": "sourdough", "defaultSL": "pantry"], ["name": "sourdough bread", "emoji": "🍞", "defaultSL": "pantry", "lastsFor": 4], ["defaultSL": "pantry", "emoji": "🍪", "lastsFor": 70, "name": "graham cracker"], ["lastsFor": 545, "name": "macaroni", "defaultSL": "pantry", "emoji": "🍝"], ["emoji": "🍝", "lastsFor": 90, "name": "macaroni and cheese", "defaultSL": "pantry"], ["defaultSL": "refrigerator", "lastsFor": 4, "emoji": "🍝", "name": "chicken alfredo"], ["lastsFor": 14, "defaultSL": "freezer", "emoji": "🍦", "name": "mochi ice cream"], ["emoji": "🍰", "lastsFor": 3, "defaultSL": "refrigerator", "name": "pineapple cake"], ["lastsFor": 2, "name": "banana bread", "defaultSL": "pantry", "emoji": "🍞"], ["emoji": "🧁", "defaultSL": "pantry", "name": "blueberry muffins", "lastsFor": 2], ["defaultSL": "refrigerator", "emoji": "🥤", "name": "aloe juice", "lastsFor": 21], ["name": "aloe vera drink", "defaultSL": "refrigerator", "emoji": "🥤", "lastsFor": 14], ["lastsFor": 1, "defaultSL": "refrigerator", "name": "smoothie", "emoji": "🥤"], ["emoji": "🥫", "name": "marinara sauce", "lastsFor": 10, "defaultSL": "refrigerator"], ["defaultSL": "pantry", "emoji": "🥔", "lastsFor": 14, "name": "mini potatoes"], ["emoji": "🍎", "lastsFor": 210, "defaultSL": "refrigerator", "name": "honeycrisp apples"], ["lastsFor": 150, "name": "japanese pumpkin", "emoji": "🎃", "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🥬", "name": "basil"], ["lastsFor": 300, "emoji": "🥭", "name": "frozen mango", "defaultSL": "freezer"], ["defaultSL": "pantry", "lastsFor": 270, "emoji": "🥭", "name": "dried mango"], ["lastsFor": 730, "defaultSL": "pantry", "name": "beef jerky", "emoji": "🥓"], ["name": "tangerines", "defaultSL": "pantry", "emoji": "🍊", "lastsFor": 14], ["name": "clementimes", "defaultSL": "pantry", "lastsFor": 7, "emoji": "🍊"], ["emoji": "🍬", "name": "sugar canes", "lastsFor": 14, "defaultSL": "refrigerator"], ["emoji": "🍈", "lastsFor": 9, "defaultSL": "refrigerator", "name": "honeydew"], ["emoji": "🍐", "lastsFor": 7, "defaultSL": "pantry", "name": "asian pears"], ["name": "congee", "lastsFor": 5, "defaultSL": "refrigerator", "emoji": "🍚"], ["defaultSL": "refrigerator", "emoji": "🧅", "name": "yellow onions", "lastsFor": 42], ["name": "grape tomatoes", "lastsFor": 5, "defaultSL": "refrigerator", "emoji": "🍅"], ["lastsFor": 10, "emoji": "🍄", "defaultSL": "refrigerator", "name": "white mushrooms"], ["emoji": "🧅", "lastsFor": 12, "defaultSL": "refrigerator", "name": "sweet onions"], ["defaultSL": "refrigerator", "lastsFor": 2, "emoji": "🌽", "name": "sweet corn cobs"], ["emoji": "🧅", "lastsFor": 14, "name": "shallot", "defaultSL": "pantry"], ["defaultSL": "refrigerator", "name": "broccoli florets", "emoji": "🥦", "lastsFor": 7], ["defaultSL": "pantry", "name": "golden potatoes", "lastsFor": 21, "emoji": "🥔"], ["lastsFor": 21, "emoji": "🥔", "name": "russet potatoes", "defaultSL": "pantry"], ["name": "peeled garlic", "emoji": "🧄", "defaultSL": "refrigerator", "lastsFor": 21], ["defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🥬", "name": "boston lettuce"], ["lastsFor": 7, "emoji": "🧅", "name": "diced yellow onions", "defaultSL": "refrigerator"], ["defaultSL": "pantry", "emoji": "🥬", "name": "curly mustard", "lastsFor": 30], ["defaultSL": "pantry", "name": "lime", "lastsFor": 14, "emoji": "🍋"], ["defaultSL": "refrigerator", "emoji": "🍇", "name": "seedless grapes", "lastsFor": 10], ["emoji": "🥭", "name": "red mango", "defaultSL": "refrigerator", "lastsFor": 5], ["defaultSL": "refrigerator", "emoji": "🍉", "lastsFor": 14, "name": "seedless watermelon"], ["lastsFor": 14, "name": "navel oranges", "defaultSL": "refrigerator", "emoji": "🍊"], ["name": "granny smith apples", "emoji": "🍏", "defaultSL": "pantry", "lastsFor": 14], ["emoji": "🍎", "defaultSL": "pantry", "lastsFor": 14, "name": "gala apples"], ["lastsFor": 14, "defaultSL": "refrigerator", "name": "seeded red watermelon", "emoji": "🍉"], ["name": "barlett pear", "lastsFor": 10, "emoji": "🍐", "defaultSL": "refrigerator"], ["defaultSL": "refrigerator", "emoji": "🍐", "lastsFor": 10, "name": "bosc pear"], ["name": "sungold kiwi", "defaultSL": "refrigerator", "lastsFor": 14, "emoji": "🥝"], ["emoji": "🍈", "name": "honeydew melon", "defaultSL": "refrigerator", "lastsFor": 10], ["name": "lunchables", "lastsFor": 30, "emoji": "🍱", "defaultSL": "refrigerator"], ["lastsFor": 90, "defaultSL": "freezer", "emoji": "🐖", "name": "ground pork"], ["defaultSL": "freezer", "emoji": "🥓", "lastsFor": 30, "name": "smoked bacon"], ["emoji": "🍪", "name": "cracker crunchers", "defaultSL": "pantry", "lastsFor": 180], ["emoji": "🇲🇽", "defaultSL": "refrigerator", "name": "nachos", "lastsFor": 6], ["name": "chicken drumsticks", "defaultSL": "freezer", "lastsFor": 180, "emoji": "🍗"], ["defaultSL": "refrigerator", "name": "mashed potatos", "lastsFor": 4, "emoji": "🥔"], ["lastsFor": 180, "defaultSL": "freezer", "name": "ground turkey", "emoji": "🦃"], ["defaultSL": "refrigerator", "emoji": "🌭", "name": "italian sausage", "lastsFor": 7], ["emoji": "🌭", "lastsFor": 7, "name": "chinese sausage", "defaultSL": "refrigerator"], ["name": "frozen shrimp", "defaultSL": "freezer", "lastsFor": 365, "emoji": "🦐"], ["lastsFor": 90, "defaultSL": "pantry", "name": "frito-lay", "emoji": "🍟"], ["emoji": "🍟", "lastsFor": 90, "name": "tortilla chips", "defaultSL": "pantry"], ["emoji": "🌭", "lastsFor": 6, "defaultSL": "pantry", "name": "hot dog buns"], ["name": "potato chips", "defaultSL": "pantry", "emoji": "🍟", "lastsFor": 90], ["name": "barbecue sauce", "lastsFor": 210, "emoji": "🥫", "defaultSL": "refrigerator"], ["lastsFor": 7, "defaultSL": "refrigerator", "name": "white sliced bread", "emoji": "🍞"], ["defaultSL": "refrigerator", "emoji": "🥫", "name": "canned green beans", "lastsFor": 545], ["name": "oreos", "defaultSL": "pantry", "emoji": "🍪", "lastsFor": 45], ["defaultSL": "pantry", "name": "flaming hot cheetos", "lastsFor": 90, "emoji": "🍟"], ["lastsFor": 545, "defaultSL": "refrigerator", "emoji": "🍅", "name": "diced tomatos"], ["defaultSL": "refrigerator", "emoji": "🌶", "name": "chili", "lastsFor": 4], ["name": "burger buns", "lastsFor": 7, "emoji": "🍔", "defaultSL": "refrigerator"], ["emoji": "🍪", "defaultSL": "pantry", "lastsFor": 180, "name": "honey maid grahm crackers"], ["lastsFor": 90, "name": "cheez it", "defaultSL": "refrigerator", "emoji": "🍟"], ["defaultSL": "refrigerator", "name": "cream of chicken soup", "emoji": "🍲", "lastsFor": 4], ["lastsFor": 90, "defaultSL": "pantry", "emoji": "🍟", "name": "pringles"], ["emoji": "🍟", "name": "bbq potato chips", "lastsFor": 90, "defaultSL": "pantry"], ["lastsFor": 7, "emoji": "🍅", "name": "tomato paste", "defaultSL": "refrigerator"], ["lastsFor": 5, "defaultSL": "refrigerator", "name": "chicken broth", "emoji": "🍲"], ["name": "vegetable broth", "emoji": "🍲", "defaultSL": "refrigerator", "lastsFor": 7], ["lastsFor": 14, "emoji": "🥛", "name": "fat free skim milk", "defaultSL": "refrigerator"], ["emoji": "🥛", "defaultSL": "refrigerator", "name": "chocolate milk", "lastsFor": 14], ["defaultSL": "refrigerator", "emoji": "🧀", "name": "sharp cheddar cheese", "lastsFor": 42], ["lastsFor": 42, "emoji": "🧀", "name": "cheddar", "defaultSL": "refrigerator"], ["emoji": "🥛", "lastsFor": 14, "defaultSL": "refrigerator", "name": "greek yogurt"], ["emoji": "🥛", "defaultSL": "refrigerator", "lastsFor": 14, "name": "pasteurized milk"], ["name": "egg whites", "defaultSL": "refrigerator", "lastsFor": 5, "emoji": "🥚"], ["defaultSL": "refrigerator", "emoji": "🧀", "name": "american cheese", "lastsFor": 21], ["emoji": "☕️", "lastsFor": 545, "defaultSL": "pantry", "name": "coffemate"], ["lastsFor": 14, "emoji": "☕️", "name": "coffee creamer", "defaultSL": "pantry"], ["emoji": "🥛", "lastsFor": 21, "defaultSL": "refrigerator", "name": "sour cream"], ["lastsFor": 180, "emoji": "🧈", "defaultSL": "refrigerator", "name": "unsalted butter"], ["lastsFor": 180, "name": "salted butter", "emoji": "🧈", "defaultSL": "refrigerator"], ["emoji": "🧀", "lastsFor": 10, "name": "cream cheese", "defaultSL": "refrigerator"], ["lastsFor": 30, "name": "heavy cream", "emoji": "🥛", "defaultSL": "refrigerator"], ["lastsFor": 2, "emoji": "🍬", "defaultSL": "pantry", "name": "cinnamon rolls"], ["name": "chobani greek yogurt", "defaultSL": "refrigerator", "emoji": "🥛", "lastsFor": 14], ["defaultSL": "refrigerator", "emoji": "🥛", "name": "almond milk", "lastsFor": 14], ["lastsFor": 5, "emoji": "🥛", "defaultSL": "refrigerator", "name": "oat milk"], ["emoji": "🍪", "name": "buttermilk biscuits", "lastsFor": 7, "defaultSL": "pantry"], ["name": "macaroni salad", "lastsFor": 3, "emoji": "🥗", "defaultSL": "refrigerator"], ["lastsFor": 5, "name": "mustard potato salad", "emoji": "🥗", "defaultSL": "refrigerator"], ["lastsFor": 180, "emoji": "🍗", "name": "chicken teneders", "defaultSL": "freezer"], ["emoji": "🧀", "defaultSL": "refrigerator", "name": "fresh mozerella", "lastsFor": 35], ["defaultSL": "refrigerator", "lastsFor": 5, "emoji": "🧀", "name": "feta cheese"], ["name": "pretzel", "defaultSL": "pantry", "lastsFor": 14, "emoji": "🥨"], ["lastsFor": 7, "emoji": "🍞", "name": "dinner rolls", "defaultSL": "refrigerator"], ["lastsFor": 7, "defaultSL": "refrigerator", "emoji": "🥐", "name": "croissants"], ["defaultSL": "refrigerator", "emoji": "🥐", "lastsFor": 7, "name": "mini crossants"], ["name": "chocolate chip cookies", "defaultSL": "pantry", "lastsFor": 7, "emoji": "🍪"], ["name": "m&m cookies", "emoji": "🍬", "lastsFor": 5, "defaultSL": "pantry"], ["lastsFor": 90, "defaultSL": "refrigerator", "name": "flat bread", "emoji": "🍞"], ["emoji": "🍩", "defaultSL": "refrigerator", "lastsFor": 7, "name": "mini donuts"], ["emoji": "🥧", "name": "apple pie", "defaultSL": "freezer", "lastsFor": 90], ["lastsFor": 90, "emoji": "🍞", "defaultSL": "refrigerator", "name": "garlic naan flatbread"], ["defaultSL": "refrigerator", "lastsFor": 7, "name": "bakery fresh goodness mini cinnamon rolls", "emoji": "🍬"], ["name": "sugar cookies", "emoji": "🍪", "defaultSL": "refrigerator", "lastsFor": 14], ["defaultSL": "pantry", "emoji": "🥜", "name": "reese\'s peanut butter cups", "lastsFor": 180], ["defaultSL": "pantry", "emoji": "🍫", "name": "kitkat", "lastsFor": 180], ["name": "m&ms", "emoji": "🍬", "defaultSL": "refrigerator", "lastsFor": 180], ["emoji": "🍬", "lastsFor": 1095, "defaultSL": "pantry", "name": "cinnamon"], ["lastsFor": 5, "emoji": "🥦", "name": "broccoli", "defaultSL": "refrigerator"], ["defaultSL": "pantry", "lastsFor": 7, "name": "pastrys", "emoji": "🥐"], ["emoji": "🌮", "defaultSL": "refrigerator", "name": "taco shell", "lastsFor": 180], ["name": "apple sauce", "emoji": "🍎", "defaultSL": "refrigerator", "lastsFor": 14], ["emoji": "🥞", "name": "pancake mix", "lastsFor": 365, "defaultSL": "pantry"], ["defaultSL": "refrigerator", "lastsFor": 4, "emoji": "🌮", "name": "quesadila"], ["name": "waffles", "lastsFor": 270, "defaultSL": "pantry", "emoji": "🧇"], ["lastsFor": 270, "defaultSL": "refrigerator", "name": "wasabi paste", "emoji": "🍣"],
        ["emoji": "🧀", "lastsFor": 42, "name": "parmesan", "defaultSL": "refrigerator"],
        ["name": "creme caramel", "defaultSL": "refrigerator", "lastsFor": 3, "emoji": "🍮"],
        ["emoji": "🥬", "lastsFor": 6, "defaultSL": "refrigerator", "name": "bok choi"],
        ["emoji": "🍳", "lastsFor": 4, "defaultSL": "refrigerator", "name": "egg rolls"],
        ["emoji": "🍝", "lastsFor": 30, "defaultSL": "refrigerator", "name": "gnocchi"],
        ["defaultSL": "pantry", "lastsFor": 210, "name": "graham crackers", "emoji": "🍘"],
        ["defaultSL": "refrigerator", "emoji": "🍟", "lastsFor": 4, "name": "hash browns"],
        ["lastsFor": 365, "defaultSL": "freezer", "emoji": "🦌", "name": "moose"],
        ["emoji": "🥞", "name": "pancakes", "defaultSL": "refrigerator", "lastsFor": 3],
        ["lastsFor": 3, "defaultSL": "refrigerator", "name": "quesadilla", "emoji": "🌮"],
        ["defaultSL": "refrigerator", "name": "tater tots", "emoji": "🍟", "lastsFor": 4],
        ["lastsFor": 21, "defaultSL": "pantry", "emoji": "🍠", "name": "yam"],
        ["defaultSL": "pantry", "emoji": "🍊", "name": "orange", "lastsFor": 14],
        ["name": "beef stew", "defaultSL": "refrigerator", "emoji": "🍲", "lastsFor": 3],
        ["emoji": "🌼", "lastsFor": 3, "name": "dandelion", "defaultSL": "refrigerator"],
        ["emoji": "🥬", "lastsFor": 5, "defaultSL": "refrierator", "name": "sea kale"],
        ["emoji": "🥬", "lastsFor": 5, "defaultSL": "refrigerator", "name": "water grass"],
        ["emoji": "🌼", "name": "canna", "lastsFor": 21, "defaultSL": "refrigerator"],
        ["name": "sea lettuce", "emoji": "🥬", "lastsFor": 4, "defaultSL": "refrigerator"],
        ["emoji": "🍲", "name": "hot pot soup base", "defaultSL": "refrigerator", "lastsFor": 730],
        ["defaultSL": "refrigerator", "lastsFor": 3, "name": "panna cotta", "emoji": "🍮"],
        ["emoji": "🍊", "defaultSL": "pantry", "lastsFor": 7, "name": "clementines"],
        ["emoji": "🥕", "name": "baby carrots", "lastsFor": 21, "defaultSL": "refrigerator"],
        ["lastsFor": 10, "emoji": "🥬", "name": "romaine lettuce", "defaultSL": "refrigerator"],
        ["emoji": "🍈", "name": "chayote", "lastsFor": 28, "defaultSL": "refrigerator"],
        ["emoji": "🍝", "lastsFor": 60, "name": "spaghetti squash", "defaultSL": "pantry"],
        ["name": "butternut squash", "lastsFor": 60, "emoji": "🍈", "defaultSL": "pantry"],
        ["emoji": "🍐", "lastsFor": 10, "name": "bartlett pear", "defaultSL": "refrigerator"],
        ["lastsFor": 5, "emoji": "🥔", "name": "mashed potatoes", "defaultSL": "refrigerator"],
        ["lastsFor": 240, "defaultSL": "pantry", "emoji": "🍪", "name": "ritz stacks original crackers"],
        ["lastsFor": 21, "emoji": "🍟", "name": "toasted coconut chips", "defaultSL": "pantry"],
        ["name": "oreo", "defaultSL": "pantry", "emoji": "🍪", "lastsFor": 30],
        ["defaultSL": "pantry", "name": "taco seasoning", "emoji": "🌮", "lastsFor": 1095],
        ["defaultSL": "refrigerator", "name": "diced tomatoes", "emoji": "🍅", "lastsFor": 545],
        ["name": "honey maid graham crackers", "defaultSL": "pantry", "lastsFor": 240, "emoji": "🍪"],
        ["defaultSL": "pantry", "emoji": "🍝", "lastsFor": 730, "name": "penne pasta"],
        ["lastsFor": 365, "defaultSL": "refrigerator", "name": "ranch", "emoji": "🥫"],
        ["lastsFor": 90, "defaultSL": "pantry", "name": "coffee mate", "emoji": "☕️"],
        ["defaultSL": "refrigerator", "name": "whipped cream", "emoji": "🍦", "lastsFor": 60],
        ["defaultSL": "freezer", "emoji": "🍗", "name": "chicken tenders", "lastsFor": 120],
        ["lastsFor": 35, "name": "fresh mozzarella", "defaultSL": "refrigerator", "emoji": "🧀"],
        ["emoji": "🥐", "name": "mini croissants", "lastsFor": 7, "defaultSL": "refrigerator"],
        ["lastsFor": 14, "emoji": "🧈", "name": "savory butter rolls", "defaultSL": "refrigerator"],
        ["defaultSL": "pantry", "name": "cappuccino", "lastsFor": 60, "emoji": "☕️"],
        ["lastsFor": 5, "name": "sunnyside up", "defaultSL": "refrigerator", "emoji": "🍳"],
        ["defaultSL": "pantry", "lastsFor": 180, "name": "pepsi", "emoji": "🥤"],
        ["name": "coke", "emoji": "🥤", "defaultSL": "pantry", "lastsFor": 180],
        ["lastsFor": 180, "name": "sprite", "emoji": "🥤", "defaultSL": "pantry"],
        ["emoji": "🥤", "defaultSL": "pantry", "name": "dr peper", "lastsFor": 180],
        ["emoji": "🥤", "name": "mountatin dew", "defaultSL": "pantry", "lastsFor": 180],
        ["emoji": "🥤", "name": "sparkling water", "defaultSL": "pantry", "lastsFor": 180],
        ["defaultSL": "refrigerator", "lastsFor": 21, "name": "aloe drink", "emoji": "🥤"],
        ["emoji": "🍿", "defaultSL": "pantry", "lastsFor": 90, "name": "sunchip"]
        
    ]
    
    @Binding var image: [CGImage]?
    @Binding var showingView: String?
    @State var ref: DocumentReference!
    @State var foodsToDisplay = [refrigeItem]()
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
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
                                    newFoodItem.id = id
                                    i.addToStorage.addToFoodItem(newFoodItem)
                                    
                                    
                                    let center = UNUserNotificationCenter.current()
                                    let content = UNMutableNotificationContent()
                                    content.title = "Eat This Food Soon"
                                    let date = Date()
                                    let twoDaysBefore = addDays(days: 7 - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
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
