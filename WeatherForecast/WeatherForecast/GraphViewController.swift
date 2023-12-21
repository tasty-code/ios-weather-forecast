//
//  GraphViewController.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/20/23.
//

import UIKit

final class GraphViewController: UIViewController {
    // MARK: View Components
    private lazy var graphView: GraphView = {
        let graphView = GraphView(frame: CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height))
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.lists = lists
        return graphView
    }()
    
    // MARK: Properties
    var lists: [List]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpConstraint()
    }
}

// MARK: AutoLayout Methods
extension GraphViewController {
    private func setUpLayout() {
        view.addSubview(graphView)
    }
    
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
