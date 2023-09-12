//
//  MapViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/06/25.
//

import UIKit
import NMapsMap
import Alamofire

protocol ItemSelectVCDelegate {
    func dismissItemSelectVC(shopData: ShopAPIResponse, itemID: Int)
}

class MapViewController: UIViewController {
    
    var itemData: ItemAPIResponse?
    var shopData: ShopAPIResponse?
    var itemID: Int = 0
    var itemName: String?
    var enuri_link: String?
    var danawq_link: String?
    var naver_link: String?
    var reviewData: BlogReviewAPIResponse?
    var makers: [NMFMarker] = []
    let infoWindow = NMFInfoWindow()
    var cameraChangeReason: Int = 0
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest // 높은 위치 정확도
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        
        return manager
     }()
    
    var userLat: Double?
    var userLon: Double?
    var mapViewCenterLat: Double?
    var mapViewCenterLon: Double?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: NMFNaverMapView!
    @IBOutlet weak var itemInfoView: UIView!
    @IBOutlet weak var itemInfoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBAction func goTextSearch(_ sender: Any) {
        let url = Bundle.main.getSecret(name: "TEXT_SEARCH_API_URL")
        
        let parameters: Parameters = ["search": itemName!]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: SearchAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.itemName = successData.response.item.itemName
                self.enuri_link = successData.response.shop.enuri?.list
                self.danawq_link = successData.response.shop.danawa?.list
                self.naver_link = successData.response.shop.naver?.list
                self.performSegue(withIdentifier: "showSearchResultInMap", sender: self)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
    }
    
    @IBAction func goBlogSearch(_ sender: Any) {
        
        let url = Bundle.main.getSecret(name: "Blog_Review_SEARCH_API_URL")
        
        let parameters: Parameters = ["search": itemName!]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: BlogReviewAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.reviewData = successData
                self.performSegue(withIdentifier: "showSearchBlogReviewInMap", sender: self)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.hideKeyboardWhenTappedAround()
        
        mapView.mapView.touchDelegate = self
        mapView.mapView.addCameraDelegate(delegate: self)
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
        // Stop location tracking when leaving the view controller
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    deinit {
        // Ensure that the locationManager is deallocated properly
        locationManager.delegate = nil
    }
    
}

extension MapViewController {
    
    func updateUI() {
        
        mapView.showLocationButton = true
        mapView.mapView.positionMode = .normal
        mapView.mapView.zoomLevel = 16
        
        print("위치 서비스 On 상태")
        locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate)
        
        //현 위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        mapView.mapView.moveCamera(cameraUpdate)
        
        // itemInfoView를 아래로 숨김
        let itemInfoViewHeight: CGFloat = itemInfoView.frame.size.height
        itemInfoViewBottomConstraint.constant = -itemInfoViewHeight
        view.layoutIfNeeded()
        
        itemInfoView.layer.borderWidth = 0.5
        itemInfoView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setMapMarker() {
        guard let shopList = shopData?.response.markets else {return}
        for shop in shopList {
            
            let latitude = shop.marketCoords.lat
            let longitude = shop.marketCoords.lon
            let marker = NMFMarker()
            makers.append(marker)
            marker.position = NMGLatLng(lat: latitude, lng: longitude)
            marker.mapView = self.mapView.mapView
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    if marker.infoWindow == nil {
                        let dataSource = CustomInfoWindowView(shopName: " [\(shop.marketName)]", shopAddress: " \(shop.marketAddress) ", itemPrice: " 가격 : \(shop.item.itemPrice)원", updatedAt: "  갱신일: \(String(shop.item.updatedAt.prefix(10)))")
                        self?.infoWindow.dataSource = dataSource
                        
                        // 해당 marker로 카메라 이동
                        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: shop.marketCoords.lat, lng: shop.marketCoords.lon))
                        cameraUpdate.animation = .easeIn
                        self!.mapView.mapView.moveCamera(cameraUpdate)
                        
                        // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                        self?.infoWindow.open(with: marker)
                        
                    } else {
                        // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                        self?.infoWindow.close()
                    }
                }
                return true
            }
            
        }
        
    }
    
    func itemSearch(search: String) {
        
        let url = Bundle.main.getSecret(name: "ITEM_SEARCH_API_URL")
        
        let parameters: Parameters = ["search": search]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ItemAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                if successData.response.items.count == 0 {
                    // 알림창 띄우기
                    return
                }
                self.itemData = successData
                self.performSegue(withIdentifier: "showItemSelect", sender: self)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showItemSelect" && CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate)
            
            if segue.identifier == "showItemSelect" {
                let vc = segue.destination as? ItemSelectViewController
                vc?.itemData = itemData
                vc?.userLat = self.mapViewCenterLat
                vc?.userLon = self.mapViewCenterLon
                vc?.itemSelectVCDelegate = self
            }
            if let sheet = segue.destination.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            
        } else {
            print("위치 서비스 Off 상태")
        }
        
        if segue.identifier == "showSearchResultInMap" {
            let vc = segue.destination as? SearchResultViewController
            vc?.itemName = itemName
            vc?.enuri_link = enuri_link
            vc?.danawa_link = danawq_link
            vc?.naver_link = naver_link
        }
        
        if segue.identifier == "showSearchBlogReviewInMap" {
            let vc = segue.destination as? BlogReviewViewController
            vc?.itemName = itemName
            vc?.reviewData = reviewData
        }
        
    }
    
    func shopSearch(id: Int, lat: Double, lon: Double, completion: @escaping (Bool) -> Void) {
        
        let url = Bundle.main.getSecret(name: "SHOP_SEARCH_API_URL")
        
        let parameters: Parameters = ["id": id, "lat": lat, "lon": lon]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ShopAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.shopData = successData
                completion(true)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
                completion(false)
            }
        }
        
    }

}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 시작
        
        // 키보드가 올라와 있을때, 내려가게 처리
        searchBar.resignFirstResponder()
        
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
//        print("--> 검색어: \(searchBar.text!)")
        
        itemSearch(search: searchBar.text!)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
        //location4
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //location5
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude

        userLat = Double(latitude)
        userLon = Double(longtitude)
    }
}

extension MapViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    // 지도를 탭하면 정보 창을 닫음
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        infoWindow.close()
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//        print("카메라 변경 - reason: \(reason)")
        cameraChangeReason = reason
    }
    
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        if cameraChangeReason == -1 {
            // mapView에 들어있는 정보
            let latitude = mapView.cameraPosition.target.lat
            let longitude = mapView.cameraPosition.target.lng
            mapViewCenterLat = latitude
            mapViewCenterLon = longitude
           print("지도 움직임종료")
           
           shopSearch(id: itemID, lat: latitude, lon: longitude) { success in
               if success {
                   for maker in self.makers {
                       maker.mapView = nil
                   }
                   self.makers = []
                   self.setMapMarker()
               } else {
                   print("fail")
               }
           }
        }
         
     }
}

extension MapViewController: ItemSelectVCDelegate {
    
    func dismissItemSelectVC(shopData: ShopAPIResponse, itemID: Int) {
        print("데이터 받음 \(shopData)")
        self.shopData = shopData
        self.itemID = itemID
        for maker in self.makers {
            maker.mapView = nil
        }
        self.makers = []
        setMapMarker()
        // itemInfoView를 올림
        itemInfoViewBottomConstraint.constant = 0
        // 레이아웃 변경을 적용합니다.
        view.layoutIfNeeded()
        
        for item in itemData!.response.items {
            if item.id == itemID {
                self.itemName = item.itemName
                itemNameLabel.text = item.itemName
                
                let baseUrl = Bundle.main.getSecret(name: "BASE_API_URL")
                
                if let imageUrl = item.itemImg {
                    itemImageView.kf.setImage(with: URL(string: baseUrl+imageUrl))
                } else {
                    itemImageView.kf.setImage(with: URL(string: "https://icon-library.com/images/no-image-icon/no-image-icon-0.jpg"))
                }
                
            }
        }

    }
}
