//
//  ProductionCompaniesCell.swift
//  MovieApp
//
//  Created by Mohamed Kelany on 7/28/18.
//  Copyright © 2018 Mohamed Kelany. All rights reserved.
//

import UIKit

class ProductionCompaniesCell: UITableViewCell {

    @IBOutlet weak var productCompanyImageView: UIImageView!

    @IBOutlet weak var productCompanyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(productCompany: ProductionCompanies){
        productCompanyLabel.text = productCompany.name
        let imagePath = "https://image.tmdb.org/t/p/w300\(productCompany.logo_path ?? "no image")"
        let url = URL(string: imagePath)
        productCompanyImageView.kf.setImage(with: url)

    }

}
