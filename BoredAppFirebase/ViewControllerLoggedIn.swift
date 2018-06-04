//
//  ViewControllerLoggedIn.swift
//  BoredAppFirebase
//
//  Created by BulBul on 01.06.18.
//  Copyright © 2018 BulBul. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import ContactsUI
import CoreLocation
import MapKit


class ViewControllerLoggedIn: UIViewController, CLLocationManagerDelegate {

    var docRef: CollectionReference!
    let locationManager: CLLocationManager = CLLocationManager()
    
   
    @IBOutlet weak var MapView: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            
            
            print( "location: ", currentLocation.coordinate)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
            MapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = currentLocation.coordinate
            annotation.title = Auth.auth().currentUser?.email
            annotation.subtitle = "Activity"
            
            let annotation2 = MKPointAnnotation()
            
            annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.332331410000002, longitude: -122.0312189)
            annotation2.title = Auth.auth().currentUser?.email
            annotation2.subtitle = "Activity"
            
            
            let AnotationsArray = [annotation,annotation2]
            MapView.addAnnotations(AnotationsArray)
            
            
            
            
            //uploadLocation(latitude: currentLocation.coordinate.latitude.description, Longtitude: currentLocation.coordinate.longitude.description)
            loadLocations()
            
            
        }
    }

    
    
    @IBAction func LogOut(_ sender: Any) {
        
        try! Auth.auth().signOut()
        print("signed out")
        self.performSegue(withIdentifier: "Logout", sender: self)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.email)
        docRef = Firestore.firestore().collection("Locations")
        ContactAcess()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       locationManager.distanceFilter = 50
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    private func uploadLocation(latitude : String, Longtitude : String) {
        
        
        docRef.document((Auth.auth().currentUser?.email)!).setData([
            "Latitude": latitude,
            "Longtitude": Longtitude
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private func loadLocations()
    {
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }
    
    private func uploadContacts(contactName : String, TelNr : String) {
        
        
        docRef.document(contactName).setData([
            "Contactname": contactName,
            "TelefonNummer": TelNr
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    /////
    private func ContactAcess(){
        
        
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        
        contactStore.requestAccess(for: .contacts) { (granted, err) in
            if let err = err
            {
                print("failed to request", err)
                return
                
            }
            if granted {
                print("access granted")
                
                do{
                    
                    try contactStore.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        print(contact.givenName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        //self.uploadContacts(contactName: contact.givenName, TelNr: contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        
                    })
                    
                    
                }
                catch let err {
                    
                    print("failed to Enumerate Contacts", err)
                }
                
                
                
            }else{
                print("access denied")
                
            }
    }



}
}
