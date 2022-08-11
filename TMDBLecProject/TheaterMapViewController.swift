//
//  TheaterMapViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/11.
//

import UIKit
import MapKit

import CoreLocation

final class TheaterMapViewController: OrientationPortraitLockedViewController {

    let theaterList = TheaterList()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.523844, longitude: 126.980249)
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    func setUI() {
        setNav()
    }
    
}

// MARK: setNav
extension TheaterMapViewController {
    
    func setNav() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterAlert))
    }
    
    @objc
    func filterAlert() {
        setAlertSheet()
    }
    
    func setAlertSheet() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megabox = UIAlertAction(title: "메가박스", style: .default) { [weak self] _ in
            
            guard let self = self else {return}
            self.setLocationAndAnnotationOnViewMap(center: self.defaultCoordinate, annotationLocations: self.getTheaterAnnotations(theaterType: .메가박스))
        }
    
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { [weak self] _ in
            
            guard let self = self else {return}
            self.setLocationAndAnnotationOnViewMap(center: self.defaultCoordinate, annotationLocations: self.getTheaterAnnotations(theaterType: .롯데시네마))
        }
        
        let cgv = UIAlertAction(title: "CGV", style: .default) { [weak self] _ in
            
            guard let self = self else {return}
            self.setLocationAndAnnotationOnViewMap(center: self.defaultCoordinate, annotationLocations: self.getTheaterAnnotations(theaterType: .CGV))
        }
        
        let all = UIAlertAction(title: "전체보기", style: .default) { [weak self] _ in
            
            guard let self = self else {return}
            self.setLocationAndAnnotationOnViewMap(center: self.defaultCoordinate, annotationLocations: self.getTheaterAnnotations(theaterType: nil))
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(megabox)
        alert.addAction(lotte)
        alert.addAction(cgv)
        alert.addAction(all)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

// MARK: MapKit, Annotations
extension TheaterMapViewController: MKMapViewDelegate {
    
    private func setLocationAndAnnotationOnViewMap(center: CLLocationCoordinate2D, annotationLocations: [MKAnnotation]) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 15000, longitudinalMeters: 15000)

        print(#function, annotationLocations)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotationLocations)
        mapView.setRegion(region, animated: true)
    }
    
    private func setLocationAndAnnotationOnViewMap(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 15000, longitudinalMeters: 15000)

        let myAnnotation = MKPointAnnotation()
        
        myAnnotation.coordinate = center
        myAnnotation.title = "내 위치"
        
        mapView.addAnnotation(myAnnotation as MKAnnotation)
        mapView.setRegion(region, animated: true)
    }

    
    private func getTheaterAnnotations(theaterType: TheaterType?) -> [MKAnnotation] {

        var theaterData = [Theater]()
                
        if let theaterType = theaterType {
            theaterData = theaterList.mapAnnotations.filter {
                $0.type == theaterType.rawValue
            }
        } else {
            theaterData = theaterList.mapAnnotations
        }
        
        let annotations = theaterData.map { theather -> MKPointAnnotation in
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: theather.latitude, longitude: theather.longitude)
            annotation.title = theather.location
            
            return annotation
        }
        
        return annotations as [MKAnnotation]
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print(#function)
    }

}

// MARK: CLLocationManagerDelegate
extension TheaterMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 데이터 로딩 완료된 경우 호출
        // locationManager.startUpdatingLocation() 결과로 나타난다.
        if let coordinate = locations.last?.coordinate {
            setLocationAndAnnotationOnViewMap(center: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위치 데이터 가져오기 실패한 경우 호출
        print(#function)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 권한이 변하거나, locationManager가 초기화시 호출되는 함수
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한이 변하거나, locationManager가 초기화시 호출되는 함수
        checkUserDeviceLocationServiceAuthorization()
    }
    
}

// MARK: Location Custom Methods
extension TheaterMapViewController {
    
    // 3. 지금 권한이 있는지 확인
    private func checkLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined: // 권한 없으면 권한요청
            print("notDetermined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 요청 알럿 띄우기
            
        case .denied, .restricted:
            print("denied") // 권한 꺼져있으면 권한 설정 셋팅창으로 보내기
            // 아이폰 설정으로 유도하는 코드
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse: // 권한 있으면 위치 데이터 전송 시작 -> delegate: didUpdateLocations 함수
            print("authorizedWhenInUse")
            
            locationManager.startUpdatingLocation()
            
        default: print("Default")
        }
        
    }
    
    // 1. 기기의 위치 서비스가 켜져있는지 확인
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
            
        // 2. 위치 서비스가 켜져있으면 권한 확인
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
        
    }
    
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          // 설정창으로 이동하는 코드
          // 설정까지 이동하거나 설정 세부화면까지 이동
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나...
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}
