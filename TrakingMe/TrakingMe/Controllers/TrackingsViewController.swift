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
        formatter.dateFormat = "HH:mm\ndd/MM"
        return formatter
    }
    
    fileprivate var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    fileprivate var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
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
//        insertDataTest()
        
        dataArray = filterTrackingsData().reversed()
        titleSections = fixtureSectionData(of: dataArray).reversed()
        
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
    func newTracking(_ sender: UIBarButtonItem) {
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
    
    func resetData() {
        dataArray = filterTrackingsData().reversed()
        titleSections = fixtureSectionData(of: dataArray).reversed()
        form.removeAll()
        setupFormTableView()
        
    }
    
    
    
    /// Đếm số thứ tự từng `row` của table
    ///
    /// - Parameters:
    ///   - row:
    ///   - section:
    /// - Returns:
    func numerical(ofRow row: Int, inSection section: Int) -> Int {
        var count = 0
        
        if section == 0 {
            count = row + 1
        } else {
            count = row + 1 + numberOfRow(inSection: section)
        }

        return count
    }
    
    
    /// Đếm số lượng `row` từ `section = 0` đến `section - 1`
    ///
    /// - Parameter section: `section`
    /// - Returns: Int
    func numberOfRow(inSection section: Int) -> Int {
        return (0..<section).map { dataArray[$0].count }.reduce(0, +)
        
    }
    
    
    /// Tạo ra mảng các `title section` của table
    ///
    /// - Parameter trackings:
    /// - Returns:
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
        
        DatabaseSupport.shared.getTracking()
            .forEach { tracking in
            
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
    
    /// Tính thời gian bắt đầu bước sang ngày mới
    ///
    /// - Parameter time: TimeInterval
    /// - Returns: TimeInterval
    func startDayTime(of time: TimeInterval) -> TimeInterval {
        return time - time.truncatingRemainder(dividingBy: 1.day)
    }
    
    
    /// Tính chiều cao của `table`
    ///
    /// - Parameter data:
    /// - Returns:
    func calculateTableViewHeight(with data: [[RealmTracking]]) -> CGFloat {
        
        let sectionsHeight = Size.button.. * CGFloat(data.count)
        let rowsHeight = Size.cell.. * CGFloat(data.map { $0.count }.reduce(0, +))
        
        return sectionsHeight + rowsHeight
    }
    
    ///
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackingName = textField.text
        print(trackingName)
    }
    
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
        resetData()
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
        
//        let left = UIBarButtonItem(image: Icon.Nav.Refesh, style: .plain, target: self, action: #selector(self.resetData))
//        left.tintColor = .white
//        navigationItem.leftBarButtonItem = left
        
        let right = UIBarButtonItem(image: Icon.Nav.Add, style: .plain, target: self, action: #selector(self.newTracking(_:)))
        right.tintColor = .white
        navigationItem.rightBarButtonItem = right
    }
    
    
    fileprivate func setupFormTableView() {
        
        for (aSection, item) in titleSections.enumerated() {
            
            let section = Section() {
                
                var header = HeaderFooterView<HeaderTableView>(.class)
                header.height = { 44 }
                
                header.onSetupView = { (headerView, section) -> () in
                    headerView.title.text = item.title
                }
                
                $0.header = header
                
                var footer = HeaderFooterView<UIView>(.class)
                footer.height = { 0.1 }
                $0.footer = footer
            }
            
            for (aRow, tracker) in dataArray[aSection].enumerated() {
                
                let tracking = tracker.convertToSyncType()
                ///
                let textRow = TextRow() { row in
                        let order = numerical(ofRow: aRow, inSection: aSection)
                        row.tag = String(order)
                    
                        row.title = "\(order)."
                        row.placeholder = tracking.name
                        row.placeholderColor = UIColor.main
                        row.textFieldPercentage = 0.81
                    
                    }
                    .cellSetup({ (cell, row) in
                        cell.height = { Size.cell.. }
                        cell.textField.text = tracking.name
                    })
                    .cellUpdate({ (cell, row) in
                        cell.textLabel?.textColor = UIColor.main
                        cell.textLabel?.font = UIFont(name: FontType.latoBold.., size: FontSize.normal++)
                        cell.textLabel?.textAlignment = .right
                        
                        cell.textField.textAlignment = .left
                        cell.textField.textColor = UIColor.main
                        cell.textField.clearButtonMode = .whileEditing
//                        cell.textField.text = tracking.name
                        
                        let dateTime = self.dateTimeFormatter.string(from: Date(timeIntervalSince1970: tracking.movements[0].timestamp))
                        
                        let time = self.timeFormatter.string(from: Date(timeIntervalSince1970: tracking.movements[0].timestamp))
                        
                        let mutableStringTerms =  NSMutableAttributedString(string: dateTime,
                                                                            attributes:[NSFontAttributeName: UIFont(name: FontType.latoRegular..,
                                                                                                                    size: FontSize.small..)!,
                                                                                        NSForegroundColorAttributeName: UIColor.gray])
                        
                        
                        
                        mutableStringTerms.addAttributes([NSFontAttributeName: UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!,
                                                          NSForegroundColorAttributeName: UIColor.darkGray],
                                                         range: (dateTime as NSString).range(of: time))
                        
                        cell.detailTextLabel?.textAlignment = .center
                        cell.detailTextLabel?.numberOfLines = 0
                        cell.detailTextLabel?.attributedText = mutableStringTerms
                        
                    })
                    .onCellSelection({ (cell, row) in
                        print(cell.textField.text ?? "empty")
                        
                        guard let str = row.tag, let aRow = Int(str) else { return }
                        print("selected row: \(aRow)")
                        
                        HUD.showHUD() {
//                            print(Utility.shared.getGMSPath(from: tracking.movements.map { $0.coordinate }).encodedPath())
//                            print("-------------")
//                            print(tracking.movements.map { $0.timestamp })
                            
                            let trackingVC = TrackingViewController()
                            trackingVC.tracking = tracking
                            trackingVC.vehicleTrip = VehicleTrip(info: TrackingInfo(tracking: tracking))
                            trackingVC.vehicleOnline = VehicleOnline(tracking: tracking)
                            trackingVC.delegate = self
                            trackingVC.state = .normal
                            
                            self.dismissKeyboard()
                            self.navigationController?.pushViewController(trackingVC, animated: true)
                            HUD.dismissHUD()
                            
                        }
                        
                    })
                    .onChange({ (row) in
                        print("--> \(row.cell.textField.text)")
                        guard let newName = row.cell.textField.text, newName.characters.count > 0 else { return }
                        
                        row.updateCell()
                        DatabaseSupport.shared.updateName(of: tracker, with: newName)
                    })
                
                
                section.append(textRow)
            }
            
            form.append(section)
            
            
        }
        
        
        
        
    }
    
    
}

