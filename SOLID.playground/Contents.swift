import UIKit

// 1 Single Responsibility Principle («Принцип единой ответственности», SRP)

// Cоздадим протокол включатель
protocol CanBeOn {
    func on()
}

// протокол выключатель
protocol CanBeOff {
    func off()
}

// Создадим включатель. Он имеет два метода, которые меняют значение свойства
class Switch: CanBeOn, CanBeOff {
    var stateOn = false
    func on() {
        stateOn = true
    }
    func off() {
        stateOn = false
    }
   
}

// Теперь отдельно создадим класс, отвечающий за включение. Внутри создали выключатель, который имеет тип протокол и метод, который внутри себя запускае метод определения значения stateOn в кклассе Switch
class SwitchOn {
    let switcher: CanBeOn
    init(switcher: CanBeOn) {
        self.switcher = switcher
    }
    func execute() {
        switcher.on()
    }
}

// Теперь отдельно создадим класс, отвечающий за включение.
class SwitchOff {
    let switcher: CanBeOff
    init(switcher: CanBeOff) {
        self.switcher = switcher
    }
    func execute() {
        switcher.off()
    }
}

// Создадим экземпляр выключателя и определим свойсто stateOn
let switcher = Switch()
switcher.stateOn

// Изменим значение свойства stateOn. Создали экземпляр класса SwitchOn и передали в инициализатор экземпляр класса Switch - это возможно тк они оба используют протокол CanBeOn
let switcherOn = SwitchOn(switcher: switcher)
switcherOn.execute()
switcher.stateOn
//:_______________________________________________________________________________________________________________________________________________________________
// 2. Open-Closed Principle («Принцип открытости-закрытости», OCP)

// Cоздадим протокол, который говорит, что программист может писать на каком-то языке
protocol CanWriteCode {
    func programming() -> String
}

//Создадим три класса, показывающие на каком языке может писать программист
class IosDeveloperCool: CanWriteCode {
    func programming() -> String {
        "Swift"
    }
}

class IosDeveloper: CanWriteCode {
    func programming() -> String {
        "Object-C"
    }
}

class WebDeveloper: CanWriteCode {
    func programming() -> String {
        "Ruby"
    }
}

// Теперь создадим команду для проекта. Минут в том, что с приходом нового программиста, мы должны вписывать его в класс и тем самым увеличивать класс. Мы вынудженны изменять класс, что нарушает второй принцип SOLID

class Team {
    let ios: [IosDeveloper]
    let iosCool: [IosDeveloperCool]
    init(ios: [IosDeveloper], iosCool: [IosDeveloperCool]) {
        self.ios = ios
        self.iosCool = iosCool
    }
    func programmingTeam() -> [String] {
        ios.map {$0.programming()} + iosCool.map {$0.programming()}
    }
}

// Создадим класс не нарушающий второй принцип SOLID
class CoolTeam {
    let team: [CanWriteCode]
    init(team: [CanWriteCode]) {
        self.team = team
    }
    func programmingCoolTeam() -> [String] {
        team.map {$0.programming()}
    }
}

// Cоздаем команду из двух программистов
let ios1 = IosDeveloper()
let ios2 = IosDeveloper()

let iosCool1 = IosDeveloperCool()
let iosCool2 = IosDeveloperCool()

let team = Team(ios: [ios1, ios2], iosCool: [iosCool1, iosCool2])
team.programmingTeam()



// создадим новую команду, основанную на новом протоколе
// создадим недостающего веб разработчика
let wemDev = WebDeveloper()

let coolTeam = CoolTeam(team: [ios1, iosCool1, wemDev])
coolTeam.programmingCoolTeam()
//:______________________________________________________________________________________________________________________________________________________
// 3. Liskov Substitution Principle («Принцип подстановки Барбары Лисков», LSP)
// Создадим общий класс класс "Птица"
class Bird {
    var name: String
    var flySpeed: Double
    init(name: String, flySpeed: Double) {
        self.name = name
        self.flySpeed = flySpeed
    }
}

// создадим два класса для какой-то конкретной птицы&
class Eagle: Bird {
    
}

// пингвины могут плавать, добавим свойство скорость плавания
class Penguin: Bird {
    var swimSpeed: Double
     init(name: String, flySpeed: Double, swimSpeed: Double) {
        self.swimSpeed = swimSpeed
        super .init(name: name, flySpeed: flySpeed)
    }
}

// создадим двух птиц
let eagle = Eagle(name: "Eagle", flySpeed: 25)
// При создаднии пингвина хочется написать в параметре flySpeed, что он не умеет летать, но не можем тк тип в суперклассе Double
// let peanguin = Penguin(name: "Penguin", flySpeed: "can't fly", swimSpeed: 15)

// Как сделать так, чтобы не изменять принцип базового класса, а дополнять его
// Создадим два протокола
protocol CanFly {
    var flySpeed: Double {get set}
}

protocol CanSwim {
    var swimSpeed: Double {get set}
}
// Cоздадим класс "Птицы"
class GeneralBirds {
    var name: String
    init(name: String) {
        self.name = name
    }
}
// В наследуемом классе мы дополняем его новым свойством, а не ищзменяем супер калсс
class GoodEagle: GeneralBirds, CanFly {
    var flySpeed: Double
    init(name: String, flySpeed: Double) {
        self.flySpeed = flySpeed
        super.init(name: name)
    }
}
// В наследуемом классе мы дополняем его новым свойством, а не ищзменяем супер калсс
class GoodPeanguin: GeneralBirds,CanSwim {
   var swimSpeed: Double
    init(name: String, swimSpeed: Double) {
        self.swimSpeed = swimSpeed
        super.init(name: name)
    }
}

let goodEagle = GoodEagle(name: "Eagle", flySpeed: 25)
let goodPeanguin = GoodPeanguin(name: "Peanguin", swimSpeed: 10)

//:_____
// 4. Interface Segregation Principle («Принцип разделения интерфейса», ISP)
// Например нам необходимы разработчики в команду по разным вакансиям и у нах должны быть определенные скилы.
// Создадим протокол, объединяющий все скилы
protocol Skills {
    var swift: Bool {get set}
    var objectC: Bool {get set}
    var html: Bool {get set}
    var css: Bool {get set}
    var ruby: Bool {get set}
    var php: Bool {get set}
}

// теперь необходимо создать класс под каждого разработчика и мы подпишем его на протокол скилов
class Ios: Skills {
    var swift: Bool
    var objectC: Bool
    var html: Bool
    var css: Bool
    var ruby: Bool
    var php: Bool
    init(swift: Bool, objectC: Bool, html: Bool, css: Bool, ruby: Bool, php: Bool) {
        self.swift = swift; self.objectC = objectC; self.html = html; self.css = css; self.ruby = ruby; self.php = php
    }
}
// Допустим, мы написали для всех вакансий и у нас получился огромный столб однотипного кода - это уже плохо. Теперь создадим конкретную вакансию и увидим, что много нам не надо. Т.е тут нарушается 4 принцип, что мы зависим от требований нашего протокола.
let ios = Ios(swift: true, objectC: true, html: false, css: false, ruby: false, php: false)

// перепишем код не нарушая 4 принцип
// создадим несколько протоколов под каждую вакансию
protocol IosSkill {
    var swift: Bool {get set}
    var objectC: Bool {get set}
}

protocol FrontSkill {
    var html: Bool {get set}
    var css: Bool {get set}
}

protocol BackSkill {
    var ruby: Bool {get set}
    var php: Bool {get set}
}

class IOS: IosSkill {
    var swift: Bool
    var objectC: Bool
    init(swift: Bool, objectC: Bool) {
        self.swift = swift
        self.objectC = objectC
    }
}

class Front: FrontSkill {
    var html: Bool
    var css: Bool
    init(html: Bool, css: Bool) {
        self.css = css
        self.html = html
    }
}

class Back: BackSkill {
    var ruby: Bool
    var php: Bool
    init(ruby: Bool, php: Bool) {
        self.php = php
        self.ruby = ruby
    }
}

// Теперь можем создать конкретного программиска с конкретными навыками
let iosDev = IOS(swift: true, objectC: true)
let front = Front(html: true, css: true)
let back = Back(ruby: true, php: true)

//:_____
// 5. Dependency Inversion Principle («Принцип инверсии зависимостей», DIP)
// например опишем несчастливого человека.
// Данный код нарушает принцип зависимости. У мужа может быть только одна жена, он зависит о нижнего класса. Мы не можем добавить ему новую жену.
class UnhappyMan {
    let wife = FirstWife()
    var food: String {
        wife.getFood()
    }
}

class FirstWife {
    func getFood() -> String {
        "Vegeterian food"
    }
}

// Изменим код чтобы жена нашего мужа была абстрактной - являлась протоколом
protocol Wife {
    func getFood() -> String
}

class HappyMan {
    let wife: Wife
    var food: String {wife.getFood()}
    init(wife: Wife) {
        self.wife = wife
    }
}

class GoodWife: Wife {
    func getFood() -> String {
        "Good food"
    }
}

class SecondWife: Wife {
    func getFood() -> String {
        "Best food"
    }
}

let man = HappyMan(wife: GoodWife())
man.food
let newMan = HappyMan(wife: SecondWife())
newMan.food


// Но теперь, этому мужу, чтобы поесть, необходимо жениться. Сделаем его независимым от жен.
// создадим абстракцию готовки еды.
protocol GetFood {
    func getFood() -> String
}

// Создадим членов семьи, которые умеют готовить
class Mother: GetFood {
    func getFood() -> String {
        "Bestly food"
    }
}

class Sister: GetFood {
    func getFood() -> String {
         "Like food"
    }
}

class ThirdWife: GetFood {
    func getFood() -> String {
        "fust food"
    }
}

// Создадим нашего парня
class HappiestMan {
    var foodProvider: GetFood
    init(foodProvider: GetFood) {
        self.foodProvider = foodProvider
    }
    var food: String {foodProvider.getFood()}
    
}

// Данный код показывает, что все сущности зависят от абстракций, что соответствует 5 принципу.

let happiestMan = HappiestMan(foodProvider: Mother())
happiestMan.food
happiestMan.foodProvider = Sister()
happiestMan.food
happiestMan.foodProvider = ThirdWife()
happiestMan.food


























































