protocol BaseIterator: IteratorProtocol {
    init(items: [Item])
    func next(by name: String) -> Item?
    func allitems() -> [Item]
}


class DataFetcherService {
    let localDataFetcher: DataFetcher
    
    init(localDataFetcher: DataFetcher = LocalDataFetcher()) {
        self.localDataFetcher = localDataFetcher
    }
    
    func localFetchItem(completion: @escaping ([Item]?) -> Void) {
        let localUrlString = "json.txt"
        localDataFetcher.fetchGenericJSONData(urlString: localUrlString, response: completion)
    }
}

class SomeClassForItem {
    
    private let dataFetcherService = DataFetcherService()
    private let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    var itemIterator: ItemIterator {
        return ItemIterator(items: items)
    }
}

extension SomeClassForItem: Sequence {
    func makeIterator() -> ItemIterator {
        return ItemIterator(items: items)
    }
}

class ItemIterator: BaseIterator {
    
    private let items: [Item]
    private var current = 0
    
    required init(items: [Item]) {
        self.items = items.sorted{$0.time < $1.time}
    }
    
    func next() -> Item? {
        defer { current += 1 }
        return items.count > current ? items[current] : nil
    }
    func next(by name: String) -> Item? {
        defer { current += 1 }
        let itemByName = items.filter{ $0.name == name}
        return itemByName.count > current ? itemByName[current] : nil
    }
    
    func allitems() -> [Item] {
        return items
    }
}

let dataFetcherService = DataFetcherService()

dataFetcherService.localFetchItem { items in
    guard let items = items else { return }
    let someClassForItem = SomeClassForItem(items: items)
    
    let all = someClassForItem.itemIterator.allitems()
    print(all)
    
    let itemIterator = someClassForItem.itemIterator
    
    let erika = itemIterator.next(by: "Erika")
    print(erika)
    
    let erika1 = itemIterator.next(by: "Erika")
    print(erika1)
    
    
    let makeIterator = someClassForItem.makeIterator()
    let margaret = makeIterator.next(by: "Margaret")
    print(margaret)
    
    let margaret1 = makeIterator.next(by: "Margaret")
    print(margaret1)

}
