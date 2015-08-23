//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Christina Ren on 8/22/15.
//  Copyright © 2015 Christina. All rights reserved.
//

import Foundation

class CalculatorBrain
{

    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", { $0 * $1 })
        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knownOps["+"] = Op.BinaryOperation("+", { $0 + $1 })
        knownOps["−"] = Op.BinaryOperation("−", { $1 - $0 })
        knownOps["√"] = Op.UnaryOperation("√", { sqrt($0) })
    }

    
    
    private func evaluate (ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .BinaryOperation(_, let operation):
                let operandEvalution1 = evaluate(remainingOps)
                if let operand1 = operandEvalution1.result {
                    let operandEvalution2 = evaluate(operandEvalution1.remainingOps)
                    if let operand2 = operandEvalution2.result {
                        return (operation(operand1, operand2), operandEvalution2.remainingOps)
                    }
                }
            case .UnaryOperation(_, let operation):
                let operandEvalution = evaluate(remainingOps)
                if let operand = operandEvalution.result {
                    return (operation(operand), operandEvalution.remainingOps)
                }
                
            }
        }
        
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?  {
        print("stack = \(opStack)")
        return evaluate(opStack).result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
