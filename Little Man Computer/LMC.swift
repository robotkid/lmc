//
//  LMC.swift
//  Little Man Computer
//
//  Created by Dan Horwood on 6/06/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

import Foundation

let LMC_MEM_SIZE = 100
let LMC_MAX_VALUE = 999
let LMC_MIN_VALUE = -999


enum lmcOpcode: Int {
    case Halt = 0
    case Add
    case Subtract
    case Store
    case Load = 5
    case BranchAlways
    case BranchIfZero
    case BranchIfZeroOrPositive
    case IO
    case Input = 901
    case Output
}


class LMC {
    var cir = 0
    var pc = 0
    var acc = 0
    let memory = [Int](count: LMC_MEM_SIZE, repeatedValue: 0)
    var running = false

    class func analyseInstructions(command: Int) -> (opcode: lmcOpcode?, operand: Int?) {
        var opcode: lmcOpcode?
        var operand: Int?
        
        return (lmcOpcode.fromRaw(command/100), command % 100)
    }
}