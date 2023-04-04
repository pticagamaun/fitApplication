//
//  MainTableView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

protocol MainTableViewProtocol: AnyObject {
    func deleteModel(model: WorkoutModel, index: Int)
}

class MainTableView: UITableView {
    
    weak var mainTableDelegate: MainTableViewProtocol?
    private let tableViewID = "tableViewID"
    private var workoutsArray = [WorkoutModel]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Funcs
    private func configure() {
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        register(MainTableViewCell.self, forCellReuseIdentifier: tableViewID)
    }
    
    private func setupView() {
        backgroundColor = .none
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Public Funcs
    public func setWorkout(array: [WorkoutModel]) {
        workoutsArray = array
    }
    
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutsArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: tableViewID, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let model = workoutsArray[indexPath.row] // помещаем в model каждый элемент из базы данных
        cell.configureCell(model: model) // устанавливаем все элементы в ячейки
        cell.maintTableViewCellDelegate = mainTableDelegate as? MainTableViewCellProtocol // подписываем под делегата maintTableViewCellDelegate = mainTableDelegate и кастим до необходимого протокола 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") {_,_,_ in
            let model = self.workoutsArray[indexPath.row]
            self.mainTableDelegate?.deleteModel(model: model, index: indexPath.row)
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        return UISwipeActionsConfiguration(actions: [action])
    }
}


