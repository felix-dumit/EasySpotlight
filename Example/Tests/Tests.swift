// https://github.com/Quick/Quick

import Quick
import Nimble
import CoreSpotlight
@testable import EasySpotlight

class EasySpotlighTests: QuickSpec {
    override func spec() {

        let index = MockSearchableIndex()
        EasySpotlight.searchableIndex = index

        let items = ["andy", "bob", "carol", "derek"].compactMap {
            //swiftlint:disable:next force_try
            try! SimpleStruct.retrieveItem(with: $0)()
        }

        describe("these will test saving and removing to index") {

            it("can index a single element") {
                let item = items[0]
                EasySpotlight.index(item) { _ in
                    expect(index.indexedItems.count) == 1
                    expect(index.indexedItems.first!.uniqueIdentifier) == item.uniqueIdentifier
                }
            }

            it("will deIndex a single element") {
                let item = items[0]
                EasySpotlight.deIndex(item) { _ in
                    expect(index.indexedItems).to(beEmpty())
                }
            }

            it("will index an array of elements") {
                EasySpotlight.index(items) { _ in
                    expect(index.indexedItems.count) == items.count
                    expect(index.indexedItems.map {$0.uniqueIdentifier}) == items.map {$0.uniqueIdentifier}
                }
            }

            it("will deinxed of a specific type") {
                let newItem = CSSearchableItem()
                index.indexedItems.append(newItem)
                EasySpotlight.deIndexAll(of: SimpleStruct.self) { _ in
                    expect(index.indexedItems.count) == 1
                    expect(index.indexedItems.first!) === newItem
                    index.indexedItems.removeAll()
                }
            }
        }

        describe("these will test registering and handling user") {
            it("will register a handler") {
                var itemReturned: SimpleStruct?

                EasySpotlight.registerIndexableHandler(SimpleStruct.self) {
                    itemReturned = $0
                }

                let item = items[0]
                EasySpotlight.handle(activity: item.userActivityWhenOpened)

                expect(itemReturned).toEventually(equal(item))
            }
        }
    }
}
