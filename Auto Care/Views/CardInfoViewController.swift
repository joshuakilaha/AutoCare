//
//  CarInfoViewController.swift
//  Auto Care
//
//  Created by Kilz on 18/07/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import Stripe

protocol CardInfoViewControllerDelaget {
    func didClickDone(_ token: STPToken)
    func didClickCancel()
}

class CardInfoViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    let paymentCardTextfield = STPPaymentCardTextField()
    
    var delegate: CardInfoViewControllerDelaget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(paymentCardTextfield)
        
        paymentCardTextfield.delegate = self
        paymentCardTextfield.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextfield, attribute: .top, relatedBy: .equal, toItem: doneButtonOutlet, attribute: .bottom, multiplier: 1, constant: 30))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextfield, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextfield, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
        
    }
    
    //MARK: - Actions


    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.didClickCancel()
        dismissView()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        processCard()
    }
    
    
    //MARK: - Helpers
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func processCard() {
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextfield.cardNumber
        cardParams.expMonth = paymentCardTextfield.expirationMonth
        cardParams.expYear = paymentCardTextfield.expirationYear
        cardParams.cvc = paymentCardTextfield.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if error == nil {
               
                self.delegate?.didClickDone(token!)
                self.dismissView()
                
            }else {
                print("Error processing token", error!.localizedDescription)
            }
        }
    }
}

extension CardInfoViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        doneButtonOutlet.isEnabled = textField.isValid
    }
}
