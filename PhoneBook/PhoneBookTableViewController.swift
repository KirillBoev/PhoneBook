//
//  PhoneBookTableViewController.swift
//  PhoneBook
//
//  Created by Kirill Boev on 03.08.2021.
//

import UIKit
import ContactsUI

class PhoneBookTableViewController: UITableViewController {

    var allContacts: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allContacts = getAllContacts()
    }
    
    func getAllContacts() -> [CNContact] {

        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]

            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {

            }

            var results: [CNContact] = []

            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {

                }
            }

            return results
        }()

        return contacts
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneBookCell", for: indexPath)
        let contact = allContacts[indexPath.row]
        let firstPhoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
        cell.textLabel?.text = ("\(contact.givenName) \(contact.familyName) / \(firstPhoneNumber)")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = allContacts[indexPath.row]
        let firstPhoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
        let url = NSURL(string: "telprompt://\(firstPhoneNumber)")!
                
        if UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
