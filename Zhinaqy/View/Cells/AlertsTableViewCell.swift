//
//  AlertsTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class AlertsTableViewCell: UITableViewCell {

    lazy private var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 36)
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = self.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlertCell.self, forCellWithReuseIdentifier: AlertCell.reuseId)
        return collectionView
    }()
    
    let alerts: Bindable<[Date]>
    
    init(alerts: Bindable<[Date]>) {
        self.alerts = alerts
        
        super.init(style: .default, reuseIdentifier: nil)
        
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addViews() {
        self.addSubview(collectionView)
    }
    
    
    func setConstraints() {
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: CGSize(width: 0, height: 52))
    }

}

extension AlertsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alerts.value.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlertCell.reuseId, for: indexPath) as! AlertCell
        
        cell.configure(alert: alerts.value[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alerts.value.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}



