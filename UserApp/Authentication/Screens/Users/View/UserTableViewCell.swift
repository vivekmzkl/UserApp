//
//  UserTableViewCell.swift
//  UserApp
//
//  Created by Vivek M on 28/11/23.
//

import UIKit

protocol CellIdentifieble {
    static var identifier: String { get }
}

extension CellIdentifieble {
    static var identifier: String {
        String(describing: self.self)
    }
}

class UserTableViewCell: UITableViewCell, CellIdentifieble {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUser(_ user: User) {
        lblName.text = user.name
        lblEmail.text = user.email
        lblGender.text = user.gender.title
        lblStatus.text = user.status.title
        lblStatus.textColor = user.status == .active ? .green : .red
    }

}
