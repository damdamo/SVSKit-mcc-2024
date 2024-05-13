import SVSKit
import Foundation


/// Evaluate a CTL query by calling the library SVSKit
/// - Parameters:
///   - net: Current Petri net
///   - marking: Current marking from a Petri net
///   - nameFile: The file containing CTL formulas
func eval(net: PetriNet, marking: Marking, nameFile: String) {
  let parserCTL = CTLParser()
  let dicCTLFormulas = parserCTL.loadCTL(filePath: nameFile)
  for (nameFormula, ctlFormula) in dicCTLFormulas.sorted(by: {$0.key < $1.key}) {
    let ctlReduced = CTL(formula: ctlFormula, net: net, canonicityLevel: .full, simplified: false, debug: false).queryReduction()
    let b = ctlReduced.eval(marking: marking)
    print("FORMULA \(nameFormula) \(b.description.uppercased()) TECHNIQUES SEQUENTIAL_PROCESSING IMPLICIT QUERY_REDUCTION STATE_COMPRESSION")
  }
}

// Return the results for the MCC competiton, this script is made to be inserted in the MCC virtual machine
func main() {
  if let data = FileManager.default.contents(atPath: "iscolored") {
    var isColoredString: String = ""
    for b in data {
      isColoredString += String(UnicodeScalar(UInt8(b)))
    }
    let arguments = CommandLine.arguments
    let category = arguments[1]
    if isColoredString == "FALSE" {
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
    } else {
      switch category {
      case "CTLFireability":
        print("CANNOT_COMPUTE")
      case "ReachabilityFireability":
        print("CANNOT_COMPUTE")
      default:
        print("DO_NOT_COMPETE")
      }
      print("CANNOT_COMPUTE")
    }
  } else {
    print("CANNOT_COMPUTE")
  }
}

main()
