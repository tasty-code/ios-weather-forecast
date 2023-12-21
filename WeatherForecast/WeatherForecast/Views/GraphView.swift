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
//        drawTemperatureLineByType(rect, lineType: .humidity(lists: lists))
    }
}

// MARK: View Drawing Methods
extension GraphView {
    
    private func drawTemperatureLineByType(_ newRect: CGRect, lineType: GraphLineType) {
        let newRect = CGRect(x: newRect.origin.x + Constants.defaultPadding,
                             y: newRect.origin.y + Constants.defaultPadding,
                             width: newRect.width - Constants.defaultPadding,
                             height: newRect.height - Constants.defaultPadding)
        
        let line = UIBezierPath()
        line.lineWidth = Constants.defaultStrokeWidth
        line.lineCapStyle = Constants.strokeLineCap
        line.lineJoinStyle = Constants.strokeLineJoin
        lineType.strokeLineColor.set()
        let data = lineType.graphData
        
        for index in 1...6 {
            let currentTemp = data[index]
            var currentTempPositionY = 0.0
            
            if currentTemp > 0 {
                currentTempPositionY = (currentTemp / 50)
            } else {
                currentTempPositionY = (currentTemp / -50)
            }
            
            if index == 1 {
                if currentTemp > 0 {
                    line.move(to: CGPoint(x: newRect.minX, y: newRect.maxY * currentTempPositionY))
                } else {
                    line.move(to: CGPoint(x: newRect.minX, y: (newRect.maxY * currentTempPositionY) + (newRect.height / 2)))
                }
            } else {
                if currentTemp > 0 {
                    line.addLine(to: CGPoint(x: newRect.maxX / 6 * CGFloat(index), y: newRect.maxY * currentTempPositionY))
                } else {
                    line.addLine(to: CGPoint(x: newRect.maxX / 6 * CGFloat(index), y: (newRect.maxY * currentTempPositionY) + (newRect.height / 2)))
                }
            }
        }
        
        line.stroke()
    }
}
