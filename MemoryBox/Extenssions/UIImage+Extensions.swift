//
//  UIImage+Extensions.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 23.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(to width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
