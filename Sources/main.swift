import SVSKit
import Foundation

//func ctlFireability(net: PetriNet, marking: Marking) {
//  let parserCTL = CTLParser()
//  let dicCTLFormulas = parserCTL.loadCTL(filePath: "CTLFireability.xml")
//  for (nameFormula, ctlFormula) in dicCTLFormulas.sorted(by: {$0.key < $1.key}) {
//    let ctlReduced = CTL(formula: ctlFormula, net: net, canonicityLevel: .full, simplified: false, debug: false).queryReduction()
//    let b = ctlReduced.eval(marking: marking)
//    print("FORMULA \(nameFormula) \(b.description.uppercased()) TECHNIQUES IMPLICIT QUERY_REDUCTION")
//  }
//}

func eval(net: PetriNet, marking: Marking, nameFile: String) {
  let parserCTL = CTLParser()
  let dicCTLFormulas = parserCTL.loadCTL(filePath: nameFile)
//  let dicCTLFormulas = parserCTL.loadCTL(filePath: "ReachabilityFireability.xml")
  for (nameFormula, ctlFormula) in dicCTLFormulas.sorted(by: {$0.key < $1.key}) {
    let ctlReduced = CTL(formula: ctlFormula, net: net, canonicityLevel: .full, simplified: false, debug: false).queryReduction()
    let b = ctlReduced.eval(marking: marking)
    print("FORMULA \(nameFormula) \(b.description.uppercased()) TECHNIQUES IMPLICIT QUERY_REDUCTION")
  }
}

// For many examples
func main() {
  let arguments = CommandLine.arguments
  let category = arguments[1]
  let parserPN = PnmlParser()
  let (net, marking) = parserPN.loadPN(filePath: "model.pnml")
  var newCapacity: [String: Int] = [:]
  for place in net.places {
    newCapacity[place] = Int.max-1
  }
  net.capacity = newCapacity
  
  switch category {
  case "CTLFireability":
    eval(net: net, marking: marking, nameFile: "CTLFireability.xml")
  case "ReachabilityFireability":
    eval(net: net, marking: marking, nameFile: "ReachabilityFireability.xml")
  default:
    print("DO_NOT_COMPETE")
  }
//  let pnmlPath = "model.pnml"
//  let ctlPath = "CTLFireability.xml"
//  let parserPN = PnmlParser()
//  let (net, marking) = parserPN.loadPN(filePath: pnmlPath)
//  var newCapacity: [String: Int] = [:]
//  for place in net.places {
//    newCapacity[place] = Int.max-1
//  }
//  net.capacity = newCapacity
//  print(net.places.count)
//  print(net.transitions.count)
//  let parserCTL = CTLParser()
//  let dicCTLFormulas = parserCTL.loadCTL(filePath: ctlPath)
//
//  for (nameFormula, ctlFormula) in dicCTLFormulas {
//    let ctlReduced = CTL(formula: ctlFormula, net: net, canonicityLevel: .full, simplified: false, debug: false).queryReduction()
//    let b = ctlReduced.eval(marking: marking)
//    print("FORMULA \(nameFormula) \(b) TECHNIQUES ...")
//  }

}

main()
