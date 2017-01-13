//
//  TrackingsViewController.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/12/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import CoreLocation
import CleanroomLogger
import GoogleMaps
import Eureka

class TrackingsViewController: FormViewController {
    
    fileprivate var didSetupConstraints = false
    
    enum Size: CGFloat {
        case padding = 15, button = 44, cell = 54, padding10 = 10
    }
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss\ndd/MM/yyyy"
        return formatter
    }
    
    fileprivate var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    fileprivate var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    /// Các thông báo
    var alertController: UIAlertController!
    var showingAlert: AlertType?
    enum AlertType {
        case addNewTracking
        case requestLocationService
        
        func alertTitle() -> String {
            switch self {
            case .requestLocationService:
                return "Thông báo"
            case .addNewTracking:
                return "Thêm mới lộ trình"
            }
        }
        
        func alertMessage() -> String {
            switch self {
            case .requestLocationService:
                return "Ứng dụng yêu cầu Dịch vụ vị trí để chạy"
            case .addNewTracking:
                return ""
            }
        }
    }
    
    fileprivate var dataArray: [[RealmTracking]] = []
    fileprivate var titleSections = [TitleSection]()
    fileprivate var selectedSection: Int? = nil
    fileprivate var trackingName: String!
    
    //-------------------------------------
    // MARK: - CYCLE LIFE
    //-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = filterTrackingsData()
        titleSections = fixtureSectionData(of: dataArray)
        LocationSupport.shared.requestLocationAuthorization(.always)
        
        locationManager.delegate = self
        
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
        
        setupFormTableView()
    }
    
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestLocationService()
    }
    
    func requestLocationService() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.showAlert(type: .requestLocationService)
            return
        }
        let status = CLLocationManager.authorizationStatus()
        guard status != .notDetermined else { return }
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            self.showAlert(type: .requestLocationService)
            return
        }
        
        if let showingAlert = showingAlert, showingAlert == .requestLocationService {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


//-------------------------------------
// MARK: - SELECTOR
//-------------------------------------
extension TrackingsViewController {
    func tracking(_ sender: UIBarButtonItem) {
        showAlert(type: .addNewTracking)
    }
}

//-------------------------------------
// MARK: - PRIVATE METHOD
//-------------------------------------
extension TrackingsViewController {
    
    func insertDataTest() {
        
        let encodePoint = "cha_CoewdSiAfAgEzCuCbCcFlEgCvBu@oAaDgFqIcNaEwGD]JwAT{@lGeEZk@xJ_HtXmR|e@u[zJaHbCaC~CcExBeEdB_FvHc^fCcLxFqNdCcGzGmPp@cCnAwHjAqTd@cN?cLLoHFa@PmDn@oD|@mAz@g@`AStAOrKOXFbA]j@c@l@gAdA_DnBsAlBi@tFs@dI_C~IwEbw@qf@rFiC`GgB`Ce@hGs@dGMbM^bOd@pN?hFMnVyAzQo@tHElP?|UAxO_@jVkBzC_@dPiCxNgDxPkFpSqIfHyCtVoJfWoHhPmEnBg@xPuFjLgFlFmCzh@u[dOwIxBaA|EuAfFu@jFWxMRlMHnJg@fNsBxYgIv^wJ|Dy@lOaBlUeBz~@uGvp@iFxm@oEfWcChKoBnIwBrKuDzN_G~XuKhR_Frk@eL`McDlSmHpEuB|KaGbMkHhEeChN_IzG{D|WoO`]{RhJ}EhD}AfRqHfC{@zSoFjDu@lKeBjNaB`RiAxJUbJC`KLbKb@jF\\fKfAxRxCtOpBrGf@vNf@rHCpb@yA|s@[rQGrIWrPoBhKmC`N}FrBoAd[{Sbn@gb@`TuNdKiFrHsCrC{@pJqBlCa@bNkAtGK`f@DjXDtPOpT_ApXmCfUcDbQoCb_Ca_@vn@}Jn`@}FxDe@xWsBlQu@fo@oCx}A{G~\\wAdRk@rHHtH\\|E`@hZbErYhD~Kr@~Vn@b]v@vJVbUj@lPNvI?`l@mApiAgCtqAuCfXk@~Jq@hFy@bHiBlBq@bHcDxZaQzL{GtFiCjKcDrJoBfi@_IhfAyOhiBiX|cAyNvtA}NztAuNjb@mEv_@uDdPqAdcAuGnd@wCfaAkGxrAoI~p@qErMeBtLiChM}DzHcDrJ_FzU{MtmA_r@n_@uSvMsGhPwG~[}KfVwHjp@eT|SmGtDyAlZqJ`ZmJvt@iVvOcFdGeAnGc@hC?zDN`WpDrrAbTr\\bFhKxAsItMuNpUgAhC_AjFgC`Jm@zAw@lBr@@dBC~@A|AHnIbCdDdA`AV?]JuBLoC|@qGxC{GdLkVvQqW|OwTfNqSpMwRjMkOha@_e@xI_KnF{G`AeB~A`AnBjApGjDzOrInG~ChMdEpHtC~M|EjKjErAJnAj@vJ~GhFvEpIdId@FfBuAbAmAxAsCrA}BpAx@zFjEfAnAxEpDrDfFpL|F~AhAnGpKlApB~G|KbCgBbCkBxCuBbCeAvN}DhI{BfEcBnBuCPSKG_Au@k@g@EKWW"
        
        if let path = GMSPath(fromEncodedPath: encodePoint) {
            let movesCoord = path.coordinates.reversed()
                .map { Movement(latitude: $0.latitude, longitude: $0.longitude, timestamp: 1483342595) }
            let tracking = Tracking(id: "test", name: "Từ quê lên Hà Nội", movements: movesCoord)
            
            DatabaseSupport.shared.insert(tracking: tracking.convertToRealmType())
        }
    }
    
    func refresh() {
        dataArray = filterTrackingsData()
        UIView.animate(withDuration: 0.3.second) {
            //            self.tableView.reloadData()
        }
    }
    
    func resetData() {
        insertDataTest()
        dataArray = filterTrackingsData()
        UIView.animate(withDuration: 0.3.second) {
            //            self.tableView.reloadData()
        }
    }
    
    
    func fixtureSectionData(of trackings: [[RealmTracking]]) -> [TitleSection] {
        
        return trackings.map { trackings -> TitleSection in
            var text = dateFormatter.string(from: Date(timeIntervalSince1970: trackings[0].time))
            
            let count = trackings.count
            if count > 1,
                startDayTime(of: trackings[count - 1].time) - startDayTime(of: trackings[0].time) >= 1.days {
                text = dateFormatter.string(from: Date(timeIntervalSince1970: trackings[0].time)) +
                    " ☞ " + dateFormatter.string(from: Date(timeIntervalSince1970: trackings[count - 1].time))
            }
            
            return TitleSection(title: text, visible: true)
        }
        
    }
    
    func filterTrackingsData(by time: TimeInterval = 3.days) -> [[RealmTracking]] {
        /// Lọc theo từng ngày
        //        return DatabaseSupport.shared.getTracking()
        //            .partitionBy { $0.time - $0.time.truncatingRemainder(dividingBy: 1.day) }
        
        
        /// Lọc theo từng khoảng thời gian `time`
        var result = [[RealmTracking]]()
        
        DatabaseSupport.shared.getTracking().forEach { tracking in
            
            if result.count == 0 {
                result.append([tracking])
            } else {
                if startDayTime(of: tracking.time) - startDayTime(of: result[result.count - 1].first!.time) <= time {
                    result[result.count - 1].append(tracking)
                } else {
                    result.append([tracking])
                }
            }
            
        }
        
        return result
        
    }
    
    /// Hàm tính thời gian bắt đầu bước sang ngày mới
    ///
    /// - Parameter time: TimeInterval
    /// - Returns: TimeInterval
    func startDayTime(of time: TimeInterval) -> TimeInterval {
        return time - time.truncatingRemainder(dividingBy: 1.day)
    }
    
    func numberOfRow(ofAnother section: Int) -> Int {
        return (0..<section).map { dataArray[$0].count }.reduce(0, +)
        
    }
    
    func calculateTableViewHeight(with data: [[RealmTracking]]) -> CGFloat {
        
        let sectionsHeight = Size.button.. * CGFloat(data.count)
        let rowsHeight = Size.cell.. * CGFloat(data.map { $0.count }.reduce(0, +))
        
        return sectionsHeight + rowsHeight
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(type: AlertType) {
        
        let style: UIAlertControllerStyle!
        
        switch type {
        default:
            style = .alert
        }
        
        alertController = UIAlertController(title: type.alertTitle(), message: type.alertMessage(), preferredStyle: style)
        guard let alert = alertController else { crashApp(message: "Lỗi Alert VC không init được - 22") }
        
        switch type {
            
        case .requestLocationService:
            alert.addAction(UIAlertAction(title: "Cài đặt", style: .default, handler: { [unowned self] _ in
                
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
                self.showingAlert = nil
                self.requestLocationService()
                
            }))
            
        case .addNewTracking:
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Nhập tên lộ trình mới"
                textField.borderStyle = .roundedRect
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.textAlignment = .left
                textField.textColor = UIColor.main
                textField.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
                textField.autocorrectionType = .no
                textField.autoresizingMask = UIViewAutoresizing()
                textField.clearButtonMode = .whileEditing
                textField.autocapitalizationType = .sentences
                textField.returnKeyType = .done
                textField.delegate = self
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                
                self.dismissKeyboard()
                
                print(self.trackingName)
                
                guard let newName = self.trackingName, newName.characters.count > 0 else {
                    HUD.showMessage("Chưa nhập tên lộ trình 😎", position: .center)
                    return
                }
                
                HUD.showHUD() {
                    let trackingVC = TrackingViewController()
                    trackingVC.state = .tracking
                    trackingVC.tracking = Tracking(id: UUID().uuidString, name: newName, movements: [])
                    trackingVC.delegate = self
                    self.navigationController?.pushViewController(trackingVC, animated: true)
                    HUD.dismissHUD()
                }
            }))
            
        }
        
        alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        showingAlert = type
    }
    
}

//=======================================
//MARK: TEXTFIELD DELEGATE
//=======================================
extension TrackingsViewController: UITextFieldDelegate {
    
}

//=======================================
//MARK: CLLOCATION MANAGER DELEGATE
//=======================================
extension TrackingsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        requestLocationService()
    }
}

extension TrackingsViewController: TrackingViewControllerDelegate {
    func reloadTable() {
        
    }
}




//-------------------------------------
// MARK: - SETUP
//-------------------------------------
extension TrackingsViewController {
    func setupAllSubviews() {
        title = "Danh sách lộ trình"
        view.backgroundColor = .white
        
        setupBarButton()
    }
    
    func setupAllConstraints() {
        
        
    }
    
    fileprivate func setupBarButton() {
        
        let left = UIBarButtonItem(image: Icon.Nav.Refesh, style: .plain, target: self, action: #selector(self.resetData))
        left.tintColor = .white
        navigationItem.leftBarButtonItem = left
        
        let right = UIBarButtonItem(image: Icon.Nav.Add, style: .plain, target: self, action: #selector(self.tracking(_:)))
        right.tintColor = .white
        navigationItem.rightBarButtonItem = right
    }

    
    fileprivate func setupFormTableView() {
        
        for (i, item) in titleSections.enumerated() {
            
            let section = Section() {
                
                        var header = HeaderFooterView<HeaderTableView>(.class)
                        header.height = { 44 }
                        
                        header.onSetupView = { (headerView, section) -> () in
                            headerView.title.text = item.title
                        }
                
                    $0.header = header
                }
            
            for (j, track) in dataArray[i].enumerated() {
                
                let tracking = track.convertToSyncType()
                
//                let row = NameRow() {
//                        $0.title = tracking.name
//                        $0.placeholder = tracking.id
//                    }
//                    .cellSetup { cell, row in
//                        cell.imageView?.image = Icon.Tracking.map
//                    }
                
                let row = ButtonRow() { (row: ButtonRow) -> Void in
                    
                    row.title = tracking.name
                    row.tag = String(j)
                    }
                    .onCellSelection { [unowned self] (cell, row) in
                        
                        guard let str = row.tag, let aRow = Int(str) else { return }
                        print("aRow: \(aRow)")
                        
                        HUD.showHUD() {
                            let trackingVC = TrackingViewController()
                            trackingVC.tracking = tracking
                            trackingVC.vehicleTrip = VehicleTrip(info: TrackingInfo(tracking: tracking))
                            trackingVC.vehicleOnline = VehicleOnline(tracking: tracking)
                            self.navigationController?.pushViewController(trackingVC, animated: true)
                            HUD.dismissHUD()
                            
                        }
                }
                
                section.append(row)
            }
            
            form.append(section)
            
            
            

        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
}
