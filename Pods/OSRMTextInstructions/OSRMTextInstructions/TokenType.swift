import Foundation

@objc(OSRMTokenType)
public enum TokenType: Int, CustomStringConvertible {
    
    case wayName
    case destination
    case rotaryName
    case exit
    case laneInstruction
    case modifier
    case direction
    case wayPoint
    
    public init?(description: String) {
        let type: TokenType
        switch description {
        case "way_name":
            type = .wayName
        case "destination":
            type = .destination
        case "rotary_name":
            type = .rotaryName
        case "exit_number":
            type = .exit
        case "lane_instruction":
            type = .laneInstruction
        case "modifier":
            type = .modifier
        case "direction":
            type = .direction
        case "way_point":
            type = .wayPoint
        default:
            return nil
        }
        self.init(rawValue: type.rawValue)
    }
    
    public var description: String {
        switch self {
        case .wayName:
            return "way_name"
        case .destination:
            return "destination"
        case .rotaryName:
            return "rotary_name"
        case .exit:
            return "exit_number"
        case .laneInstruction:
            return "lane_instruction"
        case .modifier:
            return "modifier"
        case .direction:
            return "direction"
        case .wayPoint:
            return "way_point"
        }
    }
}
