//
//  GraphView.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/15/23.
//

import UIKit

final class GraphView: UIView {
    // MARK: - Constants
    enum Constants {
        static let defaultPadding: CGFloat = 14
        static let defaultStrokeWidth: CGFloat = 4.0
        static let dividingWidthRatio: CGFloat = 6.0
        static let strokeLineJoin: CGLineJoin = .miter
        static let strokeLineCap: CGLineCap = .round
    }
    
    enum GraphLineType {
        case maxTemp(lists: [List]?), minTemp(lists: [List]?), humidity(lists: [List]?)
        
        var strokeLineColor: UIColor {
            switch self {
            case .maxTemp: UIColor.systemRed
            case .minTemp: UIColor.systemBlue
            case .humidity: UIColor.white
            }
        }
        
        var graphData: [CGFloat] {
            switch self {
            case .maxTemp(let lists):
                guard let compactLists = lists?.compactMap({$0.main?.tempMax}) else {
                    return []
                }
                
                return compactLists.map({CGFloat($0)})
            case .minTemp(let lists):
                guard let compactLists = lists?.compactMap({$0.main?.tempMin}) else {
                    return []
                }
                
                return compactLists.map({CGFloat($0)})
            case .humidity(let lists):
                guard let compactLists = lists?.compactMap({$0.main?.humidity}) else {
                    return []
                }
                
                return compactLists.map({CGFloat($0)})
            }
        }
    }
    
    var lists: [List]?
    
    override func draw(_ rect: CGRect) {
        guard let lists = lists else {
            return
        }
        
        drawTemperatureLineByType(rect, lineType: .maxTemp(lists: lists))
        drawTemperatureLineByType(rect, lineType: .minTemp(lists: lists))
        drawTemperatureLineByType(rect, lineType: .humidity(lists: lists))
    }
}

// MARK: View Drawing Methods
extension GraphView {
    private func drawTemperatureLineByType(_ rect: CGRect, lineType: GraphLineType) {
        let line = UIBezierPath(rect: CGRect(x: rect.origin.x + Constants.defaultPadding,
                                             y: rect.origin.y + Constants.defaultPadding,
                                             width: rect.width - Constants.defaultPadding,
                                             height: rect.height - Constants.defaultPadding))
        line.lineWidth = Constants.defaultStrokeWidth
        line.lineCapStyle = Constants.strokeLineCap
        line.lineJoinStyle = Constants.strokeLineJoin
        lineType.strokeLineColor.set()
        let data = lineType.graphData
        guard let high = data.max(),
              let low = data.min()
        else { return }
        let ratio = rect.height / 100 * (high - low)
        
        for index in 1...6 {
            if index == 0 {
                line.move(to: CGPoint(x: rect.minX, y: rect.height - data[index] * ratio))
            } else {
                line.addLine(to: CGPoint(x: rect.minX / 6 * CGFloat(index), y: rect.height - data[index] * ratio))
            }
        }
    }
}
