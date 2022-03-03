//
//  CityDetailViewController.swift
//  Assignment
//
//  Created by Adeel-dev on 3/3/22.
//

import UIKit
import MapKit

class CityDetailViewController: UIViewController {
    ///outlets
    @IBOutlet weak var mapView: MKMapView!
    
    ///Privates
    private let viewModel: CityViewModel
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func configureDetails() {
        let coordinates = viewModel.coord
        self.title = viewModel.title //set navigationBar title
        let location = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        mapView.setCenter(location, animated: true)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = location
        annotation1.title = viewModel.name
        mapView.addAnnotation(annotation1)
    }
}
