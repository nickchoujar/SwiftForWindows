//
//  CatchupContacts.swift
//  CatchUp
//
//  Created by aplome on 21/08/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

class CatchupContacts: NSObject {

    var contactTemp = [AnyObject]()
    var addressBook: ABAddressBook?
    
    static let sharedInstance = CatchupContacts()
    
    fileprivate override init() {
        
    }
    
    
    func importContactsFromPhone() -> [[String:String]] {
        
        if #available(iOS 9.0, *)
        {
            let contacts: [CNContact] =
            {
                let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactImageDataKey] as [Any]
                
                // Get all the containers
                var allContainers: [CNContainer] = []
                do
                {
                    allContainers = try contactStore.containers(matching: nil)
                }
                catch
                {
                    print("Error fetching containers")
                }
                
                var results: [CNContact] = []
                
                // Iterate all containers and append their contacts to our results array
                for container in allContainers
                {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    do{
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        results.append(contentsOf: containerResults)
                    }
                    catch{
                        print("Error fetching results for container")
                    }
                }
                
                return results
            }()
            
            self.contactTemp = contacts
            return self.getContactFromCNContact(contacts: contacts)
            
        }
        else
        {
            // Fallback on earlier versions
            switch ABAddressBookGetAuthorizationStatus()
            {
            case .authorized:
                print("Already authorized")
                return createAddressBook()
                /* Access the address book */
            case .denied:
                print("Denied access to address book")
                
            case .notDetermined:
                return createAddressBook()
                if let theBook: ABAddressBook = addressBook
                {
                    ABAddressBookRequestAccessWithCompletion(theBook,{success, error in
                        if success {
                            print("granted")
                        } else {
                            print("error")
                        }
                    })
                }
                
            case .restricted:
                print("Access restricted")
                
            default:
                print("Other Problem")
            }
         
            return  []
        }
    }
    
    @available(iOS 9.0, *)
    func getContactFromCNContact(contacts:[CNContact]) -> [[String:String]] {
        
        var inviteList = [[String:String]]()
        for contactPerson in contacts {
            var dict = [String:String]()
            var fname: String = contactPerson.givenName
            if fname.characters.count <= 0 {
                fname = ""
            }
            dict["fname"] = fname
            var lname: String = contactPerson.familyName
            if lname.characters.count <= 0 {
                lname = ""
            }
            dict["lname"] = lname
            if (contactPerson.isKeyAvailable(CNContactEmailAddressesKey)) {
                dict["email"] = ""
                for email:CNLabeledValue in contactPerson.emailAddresses {
                    let emailId = email.value
                    dict["email"] = emailId as String
                   // dict["email"] = "test@test.com"
                    break
                }
                
            } else {
                
                dict["email"] = ""
            }
            
            if (contactPerson.isKeyAvailable(CNContactPhoneNumbersKey)) {
                
                dict["phoneNumber"] = ""
                for phoneNumber:CNLabeledValue in contactPerson.phoneNumbers {
                    let numberValue = phoneNumber.value
                    let digits = numberValue.value(forKey: "digits") as? String
                    dict["phoneNumber"] = digits
                    break
                }
            } else {
                dict["phoneNumber"] = ""
            }
            
            
            
            if((dict["fname"]?.characters.count)! > 0 || (dict["lname"]?.characters.count)! > 0){
                if((dict["phoneNumber"]?.characters.count)! > 0 || (dict["email"]?.characters.count)! > 0){
                    
                    if(inviteList.count < 355){
                        let string:String = dict["email"]! as String
//                        if !string.contains("-") && !string.contains("yael") && !string.contains("+") && string.characters.count < 30 {
//                            inviteList.append(dict)
//                            print("culrpits  --  " + string)
//                        }
                        if  string.characters.count < 30 {
                            inviteList.append(dict)
                        }
                        
                    }
                   
                }
            }
            
            
        }
        
        
        return inviteList
    }

    
    @available(iOS 8.0, *)
    func createAddressBook() -> [[String:String]]
    {
        var error: Unmanaged<CFError>?
        self.addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        self.contactTemp = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as [AnyObject]
        
        return self.getContactsFromAddressBook()
        
    }
    
    @available(iOS 8.0, *)
    func getContactsFromAddressBook() -> [[String:String]] {
        
        var inviteList = [[String:String]]()
        
        for record:ABRecord in self.contactTemp {
            
            var dict = [String:String]()
            
            let contactPerson: ABRecord = record
            var contactPhomeNum: String = ""
            var contactEmail: String = ""
            var fName: String = ""
            var lName: String = ""
            
            let phoneProperty: ABMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValue
            let emailProperty: ABMultiValue = ABRecordCopyValue(record, kABPersonEmailProperty).takeRetainedValue() as ABMultiValue
            let allPhoneNums: NSArray = ABMultiValueCopyArrayOfAllValues(phoneProperty).takeUnretainedValue() as NSArray
            let allEmails: NSArray = ABMultiValueCopyArrayOfAllValues(emailProperty).takeUnretainedValue() as NSArray
            
            for phone in allPhoneNums
            {
                let phoneNum = phone as! String
                contactPhomeNum = phoneNum
            }
            
            for email in allEmails
            {
                let emailId = email as! String
                contactEmail = emailId
            }
            
            if let contactFirstName = ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty).takeRetainedValue() as? NSString {
                print("\t\t contactFirstName : \(contactFirstName)")
                fName = contactFirstName as String
            }
            
            if let contactLastName = ABRecordCopyValue(contactPerson, kABPersonLastNameProperty).takeRetainedValue() as? NSString {
                print("\t\t contactLastName : \(contactLastName)")
                lName = contactLastName as String
            }
            
            let fullName = fName + " " + lName
            
            dict["name"] = fullName
            dict["number"] = contactPhomeNum
            dict["email"] = contactEmail
            
            inviteList.append(dict)
        }
        
        return inviteList
    }
    
    
//Mark: Upload contacts to server
    func uploadUserContactInDB(contactsArray: [[String:String]], completion:@escaping (_ success: Bool, _ responseDict:[String: AnyObject])->()) {
        
        HandleResponse.saveContactsInDB(phoneContacts: contactsArray)
        let result = Utitlity.getContactsTuple(contacts: contactsArray)
        let emailContacts: [[String:String]] = result.emailContacts
    
        if emailContacts.count > 0 {
            let emailContactList: [[String: String]] = emailContacts.reversed()
            let params = ["contact_list":["user_id":String(describing: Utitlity.sharedInstance.user_profile!.user_Id),
                                          "contact_list":emailContactList]] as [String : Any]
            NetworkServices.sharedInstance.postContactsWebServiceWith(paths.user_contacts, params:params as [String : AnyObject], headers: [:]) { (success, responseDict) in
                
                if(success){
                    completion(success, responseDict)
                }
                else{
                
                    print(responseDict)
                }
            }
        }
    }
}
