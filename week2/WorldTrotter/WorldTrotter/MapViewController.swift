//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by 임성훈 on 2017. 7. 6..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: 위치 위/경도 구조체
struct LocationPoints {
    static let livingPlacePoint = CLLocationCoordinate2D(latitude: 37.496922, longitude: 127.028620)
    static let favoritePlacePoint = CLLocationCoordinate2D(latitude: 37.340139, longitude: 126.733424)
    static let birthPlacePoint = CLLocationCoordinate2D(latitude: 37.501477, longitude: 127.004417)
}

// MARK: 위치 명 구조체
struct LocationNames {
    static let livingPlaceName: String = "현재 있는 곳 : 강남"
    static let favoritePlaceName: String = "좋아 하는 곳 : 학교"
    static let birthPlaceName: String = "태어난 곳 : 서울 성모병원"
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var annotationIsSet: Bool = false
    var annotationIndex: Int = 0
    
    override func loadView() {
        mapView = MKMapView()
        mapView.delegate = self
        locationManager.delegate = self
        view = mapView
        
        let mapShapeOption: [String] = ["Standard", "Hybrid", "Satellite"]
        let mapShapeOptionControl = UISegmentedControl(items: mapShapeOption)
        
        mapShapeOptionControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        mapShapeOptionControl.selectedSegmentIndex = 0
        
        // 명시적인 제약 조건과 충돌하지 않도록 오토리사이징 마스크 false
        mapShapeOptionControl.translatesAutoresizingMaskIntoConstraints = false
        
        mapShapeOptionControl.addTarget(self, action: #selector(mapTypeChanged(segControl:)), for: .valueChanged)
        
        // 코드로 현재 위치 버튼 추가
        let currentLocationButton: UIButton = UIButton(type: UIButtonType.roundedRect)
        currentLocationButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        currentLocationButton.backgroundColor = UIColor.white
        currentLocationButton.setTitle("현재 위치", for: .normal)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        currentLocationButton.addTarget(self, action: #selector(zoomToCurruntLocation), for: .touchUpInside)
        
        // 코드로 핀 표시 버튼 추가
        let pinButton: UIButton = UIButton(type: UIButtonType.roundedRect)
        pinButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        pinButton.backgroundColor = UIColor.white
        pinButton.setTitle("핀", for: .normal)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.addTarget(self, action: #selector(tappedPinButton), for: .touchUpInside)
        
        view.addSubview(mapShapeOptionControl)
        view.addSubview(currentLocationButton)
        view.addSubview(pinButton)
        
        let margins = view.layoutMarginsGuide
        
        // 현재 위치 버튼 제약 조건
        let leadingOfCurrentLocationButton = currentLocationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let bottomOfCurrentLocationButton = currentLocationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        let widthOfCurrentLocationButton = currentLocationButton.widthAnchor.constraint(equalToConstant: currentLocationButton.bounds.width)
        let heightOfCurrentLocationButton = currentLocationButton.heightAnchor.constraint(equalToConstant: currentLocationButton.bounds.height)
        
        
        /* let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor) */
        
        // 맵 형태 선택 세그먼트 컨트롤 제약 조건
        let topOfMapShapeOptionControl = mapShapeOptionControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingOfMapShapeOptionControl = mapShapeOptionControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingOfMapShapeOptionControl = mapShapeOptionControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        // 핀 버튼 제약 조건
        let trailingOfPinButton = pinButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let bottomOfPinButton = pinButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        // 너비와 폭은 현재위치 버튼과 같게
        let widthOfPinButton = NSLayoutConstraint(item: pinButton, attribute: .width, relatedBy: .equal, toItem: currentLocationButton, attribute: .width, multiplier: 1.0, constant: 0.0)
        let heightOfPinButton = NSLayoutConstraint(item: pinButton, attribute: .height, relatedBy: .equal, toItem: currentLocationButton, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        // 제약조건 활성화
        topOfMapShapeOptionControl.isActive = true
        leadingOfMapShapeOptionControl.isActive = true
        trailingOfMapShapeOptionControl.isActive = true
        leadingOfCurrentLocationButton.isActive = true
        bottomOfCurrentLocationButton.isActive = true
        widthOfCurrentLocationButton.isActive = true
        heightOfCurrentLocationButton.isActive = true
        trailingOfPinButton.isActive = true
        bottomOfPinButton.isActive = true
        widthOfPinButton.isActive = true
        heightOfPinButton.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
    
    // MARK: 맵 타입 선택 세그먼트 컨트롤 값 변경 시 액션
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    // MARK: 현재위치 버튼 탭할 시 액션
    func zoomToCurruntLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: 핀 버튼 탭할 시 액션
    func tappedPinButton() {
        // 어노테이션 셋팅 안되어있으면 셋팅
        if !annotationIsSet {
            let livingPlace = MKPointAnnotation()
            let favoritePlace = MKPointAnnotation()
            let birthPlace = MKPointAnnotation()
            
            livingPlace.coordinate = LocationPoints.livingPlacePoint
            livingPlace.title = LocationNames.livingPlaceName
            favoritePlace.coordinate = LocationPoints.favoritePlacePoint
            favoritePlace.title = LocationNames.favoritePlaceName
            birthPlace.coordinate = LocationPoints.birthPlacePoint
            birthPlace.title = LocationNames.birthPlaceName
            
            mapView.addAnnotations([livingPlace, favoritePlace, birthPlace])
            
            annotationIsSet = true
        } else {
            mapView.selectAnnotation(mapView.annotations[annotationIndex] , animated: true)
            annotationIndex = (annotationIndex + 1) % mapView.annotations.count
            print(annotationIndex)
        }
    }
    
    // MARK: 현재위치 업데이트 시 호출되는 델리게이트 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.first else {
            return
        }
        let viewRegion = MKCoordinateRegionMakeWithDistance(current.coordinate, 500, 500)
        mapView.setRegion(viewRegion, animated: true)
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinateOfAnnotation = view.annotation?.coordinate else {
            return
        }
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinateOfAnnotation, 500, 500)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
