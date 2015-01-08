Swift has encouraged many developers to consider Cocoa and Cocoa Touch development, but the vast majority of resources are still written in Objective-C. This post summarises many common patterns in both languages to make it easier for developers reading Objective-C code to write Swift code (or vice versa!).

##Basics

###Hello, world!

**Swift**

```swift
println("Hello, world!")
```

**Objective-C**

```objc
NSLog(@"Hello, world");
```

* `NSLog` is also available in Swift
* Objective-C lines must end in a semi-colon
* In Objective-C you have to prefix strings (`NSString`s, the Cocoa string class) with an `@`

###Declarations

**Swift**

```swift
var x = 5
let constantString = "This string is immutable"
var mutableString = "This string is mutable"
```

**Objective-C**

```objc
int x = 5;
NSString * constantString = @"This string is immutable";
NSMutableString * mutableString = [NSMutableString stringWithString:@"This string is mutable"];
```

* You have to declare variables with their type in Objective-C, but in Swift it is usually optional
* Constant variables are declared with `let` in Swift and mutable variables are declared with `var`
* All classes are declared as C pointers in Objective-C (in simple terms, just put an asterisk after the class name, but you don't need to do this for standard C types like `int` or `double`)
* Mutable and immutable strings are separate classes in Objective-C

###Format strings

**Swift**

```swift
let str = "Hello \(name)"
```

**Objective-C**

```objc
NSString * str = [NSString stringWithFormat:@"Hello %@", name];
```

* The `\()` allows you to place arbitrary values in Swift strings
* You have to use C style format strings in Objective-C. Apple has a list of all the [`NSString` format specifies](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html#//apple_ref/doc/uid/TP40004265-SW1)

###Arrays

**Swift**

```swift
let immutableArray: [Int] = [0, 1, 2, 3]
var mutableArray = ["first", "second", "third"]
mutableArray.append("fourth")
```

**Objective-C**

```objc
NSArray * immutableArray = @[@0, @1, @2, @3];
NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:[@"first", @"second", @"third"]];
[mutableArray addObject:@"fourth"];
```

* Array types are inferred in Swift - you don't need them
* Immutable arrays are declared with `let` and mutable arrays with `var` in Swift
* You have to prefix the array declaration with @ in Objective-C
* Objective-C uses subclasses of `NSArray`, which supports storing anything that is a subclass of `NSObject`. Raw numbers (`int`, `double`, etc) are not subclasses of `NSObject`, so we have to use the `@` shortcut. Writing `@123` is the same as `[NSNumber numberWithInt:123]`

###Dictionaries

**Swift**

```swift
let immutableDictionary = ["key":"value", "key2":"value2"]
var mutableDictionary = ["key":"value", "key2":"value2"]
mutableDictionary["key"] = "I can change this"
```

**Objective-C**

```objc
NSDictionary * immutableDictionary = @{@"key":@"value", @"key2", @"value2"};
NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"key":@"value", @"key2", @"value2"}];
mutableDictionary[@"key"] = @"I can change this";
```

* Again, you have to use the @ prefix in Objective-C for the declaration
* `NSDictionary` and `NSMutableDictionary` support using any `NSObject` type as the key or value, but Swift dictionaries require that all the keys have the same type and all the values have the same type (these two types can be different)

###Numeric types

Objective-C | Swift | Size    | Notes
----------- | ----- | ------- | ----
int         | Int32 | 32 bits | Signed
int64_t     | Int64 | 64 bits | Signed
uint        | UInt32 | 32 bits | Unsigned
uint64_t    | UInt64 | 64 bits | Unsigned
NSInteger   | Int   | Platform word size | Signed
NSUInteger  | UInt  | Platform word size | Unsigned
float       | Float | 32 bits | At least 6 decimal digits
double      | Double | 64 bits | At least 15 decimal digits
CGFloat     | CGFloat | Platform word size
BOOL        | Bool  | -       | `TRUE` and `FALSE` in Objective-C, `True` and `False in Swift`

* If you are interacting with Cocoa APIs, you should generally use `NSInteger`/`Int` and `NSUInteger`/`UInt` instead of the sized integer types
* When using Cocoa APIs that deal with graphics (e.g. Quartz, UIKit) you should generally use `CGFloat`

###If statements

**Swift**

```swift
if somethingIsTrue {
    ...
}
```

**Objective-C**

```objc
if (somethingIsTrue) {
    ...
}
```

* Round brackets are optional in Swift if statements

###Loops

**Swift**

```swift
for i in 1...5 {
    //This will execute for 1, 2, 3, 4, 5
}

for i in 0..<5 {
    //This will execute for 0, 1, 2, 3, 4
}

for str in array {
    //This will execute for each item in the array
}
```

**Objective-C**

```objc
for (int i = 1; i <= 5; i++) {
    //This will execute for 1, 2, 3, 4, 5
}

for (int i = 0; i < 5; i++) {
    //This will execute for 0, 1, 2, 3, 4
}

for (NSString * str in array) {
    //This will execute for each item in the array
    //We have to assume that all of the items are strings
    //If you have multiple types in one array you can use id as the type
}
```

* Swift loops are generally simpler than their Objective-C equivalents
* Types are optional in Swift loop declarations

###Dictionary iteration

**Swift**

```swift
for (key, value) in dict {
    ...
}
```

**Objective-C**

```objc
for (id key in dict.allKeys) {
    id value = dict[key];
    ...
}
```

###Enumerations

**Swift**

```swift
enum Planet {
    case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

let myPlanet = Planet.Earth
```

**Objective-C**

```objc
typedef NS_ENUM(NSUInteger, Planet) {
    PlanetMercury,
    PlanetVenus,
    PlanetEarth,
    PlanetMars,
    PlanetJupiter,
    PlanetSaturn,
    PlanetUranus,
    PlanetNepture
};

Planet myPlanet = PlanetEarth;
```

* You use dot-syntax to access enum values in Swift
* You can add methods to enums in Swift
* You use the `NS_ENUM` macro to declare enums in Objective-C. Declaring them in this style means that you can use them like `Planet.Earth` in Swift (regular C enums don't support this)

##Functions, methods and classes

###Class declaration

**Swift**

```swift
//ABaseClass.swift
class ABaseClass {
    //Declaration of properties
    //Declaration and implementation of methods
}

//ASubClass.swift
class ASubClass : ABaseClass {
}
```

**Objective-C**

```objc
//ABaseClass.h
@interface ABaseClass : NSObject
//Declaration of properties
//Declaration of methods
@end

//ABaseClass.m
#import "ABaseClass.h"

@implementation ABaseClass
//Implementation of methods
@end

//ASubClass.h
#import "ABaseClass.h"

@interface ASubClass : ABaseClass
...
@end
```

* Each class in Swift only needs to be written in one file (although you can have multiple classes per file). All Swift classes in a module can 'see' each other automatically
* Each class in Objective-C must be *declared* in a header file and *implemented* in a .m file
* Each source file that needs to use another class must import the class' header file
* In many cases you might want to use a `struct` in Swift instead of a class if you are just representing a value. As value types are copied when you pass them to a function or method, they are great in concurrent scenarios. In Objective-C only C structs are available, however these cannot be stored in structures like `NSDictionary` or `NSArray`

###Properties

**Swift**

```swift
class MyClass {
    var someProperty: Int = 0
    //This must be initialized in init()
    var someArray: [String]
}
```

**Objective-C**

```objc
@interface MyClass : NSObject

@property int someProperty; //Value must be set in init method
@property NSArray * someArray;

@end
```


* All [non-optional properties][] in Swift must be initialized in the `init()` method in Swift
* Properties are declared in the .h in `@interface` in Objective-C
* To access properties inside a class in Swift you can use `someProperty` or `self.someProperty`. In Objective-C you must use `self.someProperty`
* To access properties of an instance outside the class, you can use `instance.someProperty` in both languages

[non-optional properties]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-XID_496

###Instance methods

####Declaration and implementation

**Swift**

```swift
var MyClass {
    func noArguments() {
        ...
    }
    
    func lengthOf(string: String) -> Int {
        return string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
    
    func multipleParamters(first: String, second: CGFloat) {
        ...
    }
}
```

**Objective-C**

```objc
//MyClass.h
@interface MyClass : NSObject

- (void)noArguments;
- (NSInteger)lengthOfString:(NSString*)string;
- (void)multipleParameters:(NSString*)first second:(CGFloat)second;

@end

//MyClass.m
#import "MyClass.h"

@implementation MyClass

- (void)noArguments {
    ...
}

- (NSInteger)lengthOfString:(NSString*)string {
    return string.length;
}

- (void)multipleParameters:(NSString*)first second:(CGFloat)second {
    ...
}

@end
```

* The return type of a method that doesn't return anything in Objective-C is `void`
* All (public) methods of a class must be declared in the class' header file in Objective-C and implemented in the .m file
* All methods begin with `func` in Swift
* Instance methods are all prefixed with `-` in Objective-C

####Calling methods

**Swift**

```swift
class MyClass {
    func stringEqual(string: String, toString: String) -> Bool {
        return string == toString
    }
    
    func stringEqualsItself(string: String) {
        //These are both the same
        stringEqual(string, string)
        self.stringEqual(string, string)
    }
}
```

**Objective-C**

```objc
@interface MyClass : NSObject

- (BOOL)stringEqual:(NSString*)string toString:(NSString*)toString;
- (void)stringEqualsItself:(NSString*)string;

@end

@implementation MyClass

- (BOOL)stringEqual:(NSString*)string toString:(NSString*)toString {
    return [string isEqualToString:toString];
}

- (void)stringEqualsItself:(NSString*)string {
    [self stringEqual:string toString:string]
}

@end
```

* Methods can be called with `instance.methodName(...)` in Swift
* `self` can be omitted in Swift
* Methods are called as `[self methodName:firstParameter second:secondParameter]` in Objective-C
* You can't use dot syntax to call methods with parameters in Objective-C (if, however you have a method like `- (NSInteger)doSomeCalculationWithoutParameters` you can do `instance.doSomeCalculationWithoutParameters` however it is generally considered bad practice)

###Class methods

**Swift**

```swift
class MyClass {
    class func classFunction() {
    }
}

//Call as:
MyClass.classFunction()
```

**Objective-C**

```objc
@interface MyClass : NSObject

+ (void)classFunction;

@end

//Call as
[MyClass classFunction];
```

* Class functions are declared as `class func` in Swift and use `+` instead of a `-` in Objective-C
* You can call class functions without parameters using dot-syntax in Objective-C (e.g. `MyClass.classFuncion`) however this is considered bad practice

###Initializers

**Swift**

```swift
class Person {
    var someProperty: Int = 5
    
    override init() {
        //This must be called before you initialize the class
        super.init()
        //All non-optional properties must be initialized here
        ...
    }
    
    //A secondary init method
    init(withName name: String) {
        ...
    }
}
```

**Objective-C**

```objc
@implementation Person

//These methods will need to be declared in the header file
- (instancetype)init {
    self = [super init];
    if (self) {
        //Properties must be initialized in init
        self.someProperty = 5;
        ...
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        //Do initialization of properties
    }
    return self;
}

@end
```

* To override a superclass initializer in Swift you must use the `override` keyword
* You can set the default values of properties when they are declared in Swift, but you must initialize them in Objective-C
* You can name parameters in both languages. These statements are equivalent:
* Swift: `someFunction(withParameter param: String)` is called as `instance.someFunction(withParameter: value)`
* Objective-C: `- (void)someFunctionWithParameter:(NSString*)param` is called as `[instance someFunctionWithParameter:value]`
* The return type of initializers in Objective-C is `instancetype`. You cannot have a return type in Swift
* In Objective-C:
* You have to initialize `self` from the superclass in Objective-C
* Check that it isn't nil (`if (self)` is the same as `if (self != nil)` in Objective-C)
* Initialize the properties
* Return `self`

###Deinitializers

**Swift**

```swift
class MyClass {
    deinit() {
        //Cleanup resources if necessary
    }
}
```

**Objective-C**

```objc
@implementation MyClass

- (void)dealloc {
    //Cleanup resources if necessary
}

@end
```

* You can only have one `deinit` or `dealloc` method
* You do not need to call the superclass' deinitializer (Automatic Reference Counting does this for you)
* You do not need to call `dealloc` or `deinit` on any properties that your class owns (Automatic Reference Counting does this for you)

###Instance declarations

**Swift**

```swift
var object = MyClass()
var person = Person(withName: "Thomas")
```

**Objective-C**

```objc
MyClass * object = [[MyClass alloc] init];
Person * person = [[Person alloc] initWithName:@"Thomas"];
```

* You can use `var` or `let` in Swift, but if you use `let` then you won't be able to reassign the variable later
* In Swift you use `ClassName(parameters of initializer)` to initialize an instance
* Types are inferred in Swift, but must be defined explicitly in Objective-C
* You have to call the class method `alloc` before calling the `init` method in Objective-C. You do not need to define `alloc` for your class

###Protocols

**Swift**

```swift
protocol MyProtocol {
    func classMustDoThis()
}

class MyClass: Superclass, MyProtocol {
    func classMustDoThis() {
        ...
    }
}
```

**Objective-C**

```objc
@protocol MyProtocol<NSObject>

- (void)classMustDoThis;

@end

@interface MyClass: Superclass<MyProtocol>
@end

@implementation MyClass

- (void)classMustDoThis {
    ...
}

@end
```

* If a class conforms to a protocol then you must list it after the superclass in Swift
* The Swift compiler will fail if you don't implement all of the protocol's methods in your class, however it will only produce a warning in Objective-C
* Protocols are listed in angle brackets after the superclass in Objective-C
* If you have a class that needs to have a property that conforms to a protocol:
* Swift: `var property: MyProtocol`
* Objective-C: `@property id<MyProtocol> property;` - you don't need the `*` because `id` is not a pointer type

###Extensions

**Swift**

```swift
extension UIImage {
    func newMethod() {
    }
}
```

**Objective-C**

```objc
@interface UIImage (XYZ)

- (void)xyz_newMethod;

@end

@implementation UIImage (XYZ)

- (void)xyz_newMethod {
    ...
}

@end
```

* Extension methods are available to all other Swift classes when defined in Swift
* Extension methods defined in Objective-C are accessible if you import the extension header file (typically named `Class+XYZ.h`)
* It is encourage to use three letter acronyms for extensions and method names in Objective-C
* You cannot (easily) add properties in extensions

###Private methods and properties

**Swift**

```swift
class MyClass {
    private var privateProperty: String
    
    private func privateMethod() {
        ...
    }
}
```

**Objective-C**

```objc
//MyClass.h
@interface MyClass : NSObject
//Do not declare private methods and properties in the header file!
@end

//MyClass.m
#import "MyClass.h"

@interface MyClass ()

@property NSString * privateProperty;
- (void)privateMethod;

@end

@implementation MyClass

- (void)privateMethod {
    ...
}

@end
```

* Private methods and properties are not accessible outside of the class
* There is also the `internal` keyword in Swift. These are only available in the current module (framework or app). This feature is not available in Objective-C
* Private methods and properties are declared in a private class extension in the implementation file of a class

###Interface Builder

**Swift**

```swift
class MyViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(sender: AnyObject) {
        ...
    }
}
```

**Objective-C**

```objc
//MyViewController.h
@interface MyViewController: UIViewController

@property (weak, nonatomic) IBOutlet UIButton * button;
- (IBAction)buttonTapped:(id)sender;

@end

//MyViewController.m
#import "MyViewController.h"

@implementation MyViewController

- (IBAction)buttonTapped:(id)sender {
    ...
}

@end
```

* The `IBOutlet`/`@IBOutlet` and `IBAction`/`@IBAction` attributes declare that a property or method is accessible from Interface Builder
* `IBOutlet`s are weak
* `IBAction` is the same as the `void` return type in Objective-C
* The sender has type `AnyObject` or `id`, however Interface Builder does support picking a specific type (e.g. `UIButton`)

###Getters and setters
**Swift**

```swift
class MyClass {
    var temperatureInCelsius: Double = 0;
    
    var temperatureInFahrenheit: Double {
        get {
            return (temperatureInCelsius * 9.0 / 5.0) + 32.0
        }
        set(fahrenheit) {
            temperatureInCelsius = (fahrenheit - 32) * 5.0 / 9.0
        }
    }
}
```

**Objective-C**

```objc
@interface MyClass: NSObjet

@property double temperatureInCelsius;
@property (nonatomic) double temperatureInFahrenheit;

@end

@implementation MyClass

- (double)temperatureInFahrenheit {
    return (self.temperatureInCelsius * 9.0 / 5.0) + 32.0;
}

- (void)setTemperatureInFahrenheit:(double)fahrenheit {
    self.temperatureInCelsius = (fahrenheit - 32) * 5.0 / 9.0;
}

@end
```

* To be able to write a custom setter for a property in Objective-C you need to declare it as `nonatomic`
* You don't have to write a getter method if you write a setter method and vice versa

##Blocks and functional patterns

* Objective-C block syntax: [http://fuckingblocksyntax.com](http://fuckingblocksyntax.com)
* Swift closure syntax: [http://fuckingclosuresyntax.com](http://fuckingclosuresyntax.com)

###No parameters, no return value

**Swift**

```swift
let closure: () -> () = {
    ...
}
//Call as:
closure()
```

**Objective-C**

```objc
void (^block)() = ^(){
    ...
};
//Call as
block();
```

* In Objective-C closures are called blocks
* In Swift `Void -> Void` is the same as `() -> ()`

###Parameters and return value

**Swift**

```swift
let discriminantOfQuadratic: (Double, Double, Double) -> Double = { (a, b, c) in
    return b * b - 4 * a * c
}

let quadraticHasRealSolutions: (Double, Double, Double) -> Bool = { q in
    //Arguments are taken as a tuple
    //This is not available in Objective-C
    return discriminantOfQuadratic(q) >= 0
}
```

**Objective-C**

```objc
double(^discriminantOfQuadratic)(double, double, double) = ^double(double a, double b, double c) {
    return b * b - 4 * a * c;
};

BOOL(^quadraticHasRealSolutions)(double, double, double) = ^BOOL(double a, double b, double c) {
    return discriminantOfQuadratic(a, b, c) >= 0;
};
```

* In both languages you must use the declare the closure/block with a specific type
* In Swift you should use `let` when declaring blocks, but `var` will also work
* Swift allows you to take all of the arguments as a tuple
* In Swift you can omit parameters by writing `_` instead of their name
* You can access by `$index` in Swift, however this is generally only useful for small blocks

###Typealias/Typedef

**Swift**

```swift
typealias Int2Int = Int -> Int
let square: Int2Int = { $0 * $0 }
```

**Objective-C**

```objc
typedef int (^Int2Int)(int);
Int2Int square = ^(int a){
    return a * a;
};
```

###Sorting

**Swift**

```swift
let fellowship = ["Gandalf", "Aragon", "Boromir", "Legolas", "Gimli", "Frodo", "Samwise", "Merry", "Pippin"]
let sortedFellowship = sorted(fellowship, { s1, s2 in s1 < s2 })
```

**Objective-C**

```objc
NSArray * fellowship = @[@"Gandalf", @"Aragon", @"Boromir", @"Legolas", @"Gimli", @"Frodo", @"Samwise", @"Merry", @"Pippin"];
NSArray * sortedFellowship [fellowship sortedArrayUsingComparator:^NSComparisonResult(id left, id right) {
    NSString * s1 = left;
    NSString * s2 = right;
    
    //The compare method of NSString returns an NSComparisonResult
    return [left compare:right];
}];
```

* The Swift closure returns a `Bool` indicating whether or not the items are already in the correct order (e.g. whether the first item comes before the second item)
* The Objective-C block returns an `NSComparisonResult`. This can have one of three values:
* `NSOrderedAscending` - the left item comes before the right item. Same as returning `true` in the Swift closure
* `NSOrderedSame` - the left item and right item are equal. Same as returning `true` in the Swift closure
* `NSOrderedDescending` - the left item should come after the right after. Same as returning `false` in the Swift closure

##Imports and project management

In Swift if you declare a class in one file it will be 'visible' to all other Swift classes in your app or framework automatically, and all non private methods will be accessible. In Objective-C you must import each class' header file with its interface declaration when you want to access its methods.

You may have a scenario where class A has an instance of class B as a property and class B has an instance of A as a property. To do this you must do forward declarations of the classes:

**ClassA.h**

```objc
//Forward declaration of ClassB
@class ClassB;

@interface ClassA: NSObject

@property ClassB * bProperty;

@end

**ClassA.m**

```objc
#import "ClassA.h"
//If you don't also import class B's header file you won't be able to use its methods
#import "ClassB.h"

@implementation ClassA
...
@end

**ClassB.h**

```objc
//Forward declaration of ClassA
@class ClassA;

@interface ClassB : NSObject

@property ClassA * aProperty;

@end

**ClassB.m**

```objc
#import "ClassB.h"
#import "ClassA.h"

@implementation ClassB
...
@end
```

For a full primer on using classes and header files, see [Team Treehouse](http://blog.teamtreehouse.com/beginners-guide-objective-c-classes-objects).