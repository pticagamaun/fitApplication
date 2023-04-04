//
//  StatisticsTableView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

class StatisticsTableView: UITableView {
    
    private let statisticsTableViewID = "statisticsTableViewID"
    private var differenceArray = [DifferenceWorkout]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        delegate = self
        dataSource = self
        register(StatisticsTableViewCell.self, forCellReuseIdentifier: statisticsTableViewID)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
    }
    
    public func setDifferenceWorkout(model: [DifferenceWorkout]) {
        differenceArray = model
    }
    
}

extension StatisticsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        differenceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: statisticsTableViewID, for: indexPath) as? StatisticsTableViewCell else {return UITableViewCell()}
        let model = differenceArray[indexPath.row]
        cell.setCells(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }

}
