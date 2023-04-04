//
//  ProfileCollectionView.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 22.11.2022.
//

import UIKit

protocol ProfileCollectionProtocol: AnyObject {
    func didSelectCell()
}

final class ProfileCollectionView: UICollectionView {
    
    weak var profileViewDelegate: ProfileCollectionProtocol?
    private let collectionLayout = UICollectionViewFlowLayout()
    private let idCollectionProfile = "idCollectionProfile"
    public var workoutArray = [ResultWorkout]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.scrollDirection = .horizontal
        register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: idCollectionProfile)
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
        bounces = false
        showsHorizontalScrollIndicator = false
    }
    
    private func getWorkoutsNames() -> [String] {
        var nameArray = [String]()
        let resultsWorkout = RealmManager.shared.getWorkoutModelResults()
        
        for workoutModel in resultsWorkout {
            if !nameArray.contains(workoutModel.workoutName){ // если модель не содержит имя
                nameArray.append(workoutModel.workoutName) // поместить его в модель
            }
        }
        return nameArray
    }
    
    public func getWorkoutResults() {
        let nameArray = getWorkoutsNames()
        let workoutResults = RealmManager.shared.getWorkoutModelResults()
        
        for name in nameArray {
            let predicate = NSPredicate(format: "workoutName = '\(name)'")
            let filtredArray = workoutResults.filter(predicate).sorted(byKeyPath: "workoutName")
            var result = 0
            var image: Data?
            filtredArray.forEach { model in
                result += model.workoutReps
                image = model.workoutImage
            }
            let resultModel = ResultWorkout(name: name, result: result, image: image)
            workoutArray.append(resultModel)
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ProfileCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: idCollectionProfile, for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        let model = workoutArray[indexPath.row]
        cell.setCell(model)
        cell.backgroundColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3 ? .specialGreen : .specialYellow) 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileViewDelegate?.didSelectCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: collectionView.frame.width / 2.07,
                   height: 120)
        }
    
}
