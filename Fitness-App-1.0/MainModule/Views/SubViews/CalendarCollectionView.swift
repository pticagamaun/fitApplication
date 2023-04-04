//
//  CalendarCollectionView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 11.11.2022.
//

import UIKit

protocol CalendarCollectionProtocol: AnyObject {
    func selectItem(date: Date)
}

class CalendarCollectionView: UICollectionView {
    
    let collectionLayout = UICollectionViewFlowLayout()
    
    private let collectionViewID = "collectionViewID"
    weak var calendarDelegate: CalendarCollectionProtocol?
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
//        collectionLayout.minimumLineSpacing = 3
        register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewID)
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CalendarCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewID, for: indexPath) as? CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let dateTimeZone = Date() // константа dateTimeZone хранит в себе дату
        let weekArray = dateTimeZone.getWeekDay() // константа weekArray хранит в себе дату с массивом [[String]]
        
        cell.dateForCell(numberOfDay: weekArray[1][indexPath.row], dayOfWeek: weekArray[0][indexPath.row]) // присваиваем элементы массива к каждой ячейке
        
        if indexPath.row == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateTimeZone = Date()
        let date = dateTimeZone.offsetDay(day: 6 - indexPath.row)
        calendarDelegate?.selectItem(date: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 10,
               height: collectionView.frame.height)
    }
    
}
