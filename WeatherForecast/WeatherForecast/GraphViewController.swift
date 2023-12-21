//
//  GraphViewController.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/20/23.
//

import UIKit

final class GraphViewController: UIViewController {
    // MARK: View Components
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "RootViewBackground")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        self.view.backgroundColor = .systemBackground
        setUpLayout()
        setUpConstraint()
    }
}

// MARK: AutoLayout Methods
extension GraphViewController {
    private func setUpLayout() {
        view.addSubviews([backgroundImageView, graphView])
        graphView.backgroundColor = .clear
    }
    
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
