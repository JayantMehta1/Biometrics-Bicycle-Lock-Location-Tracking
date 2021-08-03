//
//  ContentView.swift
//  Biometrics Bicycle Lock iOS Tracker
//
//  Created by Jayant Mehta on 2021-07-23.
//

import SwiftUI
import MapKit
import Combine

import CoreMotion

struct ContentView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    
    private let pedometer: CMPedometer = CMPedometer()
    @State private var steps: Int?
    @State private var distance: Double?
    
    private var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    private func updateUI(data: CMPedometerData) {
        steps = data.numberOfSteps.intValue
        guard let pedometerDistance = data.distance else { return }
        let distanceInMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        distance = distanceInMeters.converted(to: .kilometers).value
    }
    
    private func initializePedometer() {
        if isPedometerAvailable {
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
                return
            }

            pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
                guard let data = data, error == nil else { return }
                
//                steps = data.numberOfSteps.intValue
//                distance = data.distance?.doubleValue
                
                updateUI(data: data)

            }
        }
    }
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    var body: some View {
//        VStack {
//            if locationManager.location != nil {
//                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//            } else {
//                Text("Locating user location...")
//            }
//        }
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        return VStack {
//            MapView()
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)

            Text("\(coordinate.latitude), \(coordinate.longitude)")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            
            Text(steps != nil ? "\(steps!) steps" : "")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            
            Text(distance != nil ? String(format: "%.2f km", distance!) : "")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
            .onAppear {
                setCurrentLocation()
                initializePedometer()
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
