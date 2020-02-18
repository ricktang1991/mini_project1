//
//  main.swift
//  fileTree
//
//  Created by student on 2020-02-18.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation

var lastOrNotOfParents: [Bool] = []

func writeRoot(_ item: URL) {
    print(item.lastPathComponent)
}

func writeItem(_ item: URL,_ lastOrNotOfItem: Bool) {
    var str = ""
    for i in lastOrNotOfParents {
        str += i ? "    " : " │ "
    }
    
    str += (lastOrNotOfItem ? " └ " : " ├ ") + item.lastPathComponent
    print(str)
}

func doRoot(_ root: URL) {
    lastOrNotOfParents = []
    writeRoot(root)
    doChildren(root)
}

func isDirectory(_ parent: URL) -> Bool {
    var isDir: ObjCBool = false
    let fileManage = FileManager.default
    fileManage.fileExists(atPath: parent.path, isDirectory: &isDir)
    return isDir.boolValue
}

func doChildren(_ parent: URL) {

    do {
        if isDirectory(parent) {
            let children = try FileManager.default.contentsOfDirectory(at: parent, includingPropertiesForKeys: nil);

            var iterator = children.makeIterator()
            var child = iterator.next()

            while(child != nil){
                let next = iterator.next()
                doEachItems(child!, next == nil)
                child = next
            }
        }
    } catch {
        print(error)
    }
}

func doEachItems(_ item: URL, _ lastOrNotOfItem: Bool) {
    writeItem(item, lastOrNotOfItem)
    lastOrNotOfParents += [lastOrNotOfItem]
    doChildren(item)
    lastOrNotOfParents.removeLast()
}

let path = FileManager.default.currentDirectoryPath
doRoot(URL(fileURLWithPath: path))



