//
//  ViewController.swift
//  NewArray
//
//  Created by Greg Hughes on 9/9/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var g = NewArray<String>(count: 3, type: "f")!
        
//        print(g)
        
        g.append(item: "a")
        for (i,item) in g.enumerated() {
            

            print(item)
        }
    }


}
struct StringIterator<Element>: IteratorProtocol {

    let stringValue: Element
    

    
    
    mutating func next() -> Element? {
        return stringValue
    }
}

struct NewArray<Element>: Sequence {
    
    
    __consuming func makeIterator() -> MyIterator {
        MyIterator(array: self)
    }
    
    
    
    struct MyIterator: IteratorProtocol {
        
        var currentIndex: Int = 0
        var array: NewArray<Element>
        
        mutating func next() -> Element? {
            
            
            if currentIndex > array.endIndex! {
                currentIndex = 0
                return nil
            }
            let element = array.pointer.baseAddress?.advanced(by: currentIndex).pointee
            currentIndex += 1
            return element
        }
        
        
    }
    typealias Iterator = MyIterator
    var count: Int
    var currentIndex: Int = 0
    var startIndex: Int?
    var pointer: UnsafeMutableBufferPointer<Element>
    var endIndex: Int?
    
    



    
    mutating func append(item: Element) {
        guard endIndex != nil else {return}
        
        if endIndex == count - 1 {
            count *= 2
            
            endIndex! += 1
            let newPointer = UnsafeMutableBufferPointer<Element>.allocate(capacity: count)
            newPointer.initialize(from: self)
            newPointer.baseAddress?.advanced(by: endIndex!).pointee = item
            

            pointer.deallocate()
            pointer = newPointer
            
            return
        }
        
        
        endIndex! += 1
        pointer.baseAddress?.advanced(by: endIndex!).pointee = item
    }
    

    
    
    init?(count: Int, type: Element) {

        if count > 0 {
            startIndex = 0
            endIndex = count - 1
            self.count = count
        }else {
            startIndex = nil
            endIndex = nil
            self.count = 0
            return nil
        }
        pointer =  UnsafeMutableBufferPointer<Element>.allocate(capacity: count)
        pointer.initialize(repeating: type)

        
    }
    
    subscript(position: Int) -> Element {
        get {
            return pointer.baseAddress!.advanced(by: position).pointee
        }
    }
    //NEEDS TO HAVE APPEND


    
    

    
    
}
