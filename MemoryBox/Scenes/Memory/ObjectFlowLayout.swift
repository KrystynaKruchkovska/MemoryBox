//
//  ObjectFlowLayout.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 27.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

class ObjectFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize
    {
        if referenceSizeForHeaderInSection == 1 {
            return CGSize.zero
        }
        return CGSize(width:0, height:50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
