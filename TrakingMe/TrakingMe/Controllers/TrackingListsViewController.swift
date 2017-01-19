//
//  TrackingListsViewController.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import CoreLocation
import CleanroomLogger
import GoogleMaps

class TrackingListsViewController: GeneralViewController {
    
    /**
     Enum xác định các Size
     */
    enum Size: CGFloat {
        case padding15 = 15, button = 44, cell = 54
    }
    
    let cellIdentifier = "cell"
    let cellEmpty = "cellEmpty"
    
    fileprivate var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        insertDataTest()
        
        dataArray = filterTrackingsData()
        titleSections = fixtureSectionData(of: dataArray)
        LocationSupport.shared.requestLocationAuthorization(.always)
        
        locationManager.delegate = self
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
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
//=======================================
//MARK: PRIVATE METHOD
//=======================================
extension TrackingListsViewController {
    
    func insertDataTest() {
        
        let encodePoint = "cha_CoewdSiAfAgEzCuCbCcFlEgCvBu@oAaDgFqIcNaEwGD]JwAT{@lGeEZk@xJ_HtXmR|e@u[zJaHbCaC~CcExBeEdB_FvHc^fCcLxFqNdCcGzGmPp@cCnAwHjAqTd@cN?cLLoHFa@PmDn@oD|@mAz@g@`AStAOrKOXFbA]j@c@l@gAdA_DnBsAlBi@tFs@dI_C~IwEbw@qf@rFiC`GgB`Ce@hGs@dGMbM^bOd@pN?hFMnVyAzQo@tHElP?|UAxO_@jVkBzC_@dPiCxNgDxPkFpSqIfHyCtVoJfWoHhPmEnBg@xPuFjLgFlFmCzh@u[dOwIxBaA|EuAfFu@jFWxMRlMHnJg@fNsBxYgIv^wJ|Dy@lOaBlUeBz~@uGvp@iFxm@oEfWcChKoBnIwBrKuDzN_G~XuKhR_Frk@eL`McDlSmHpEuB|KaGbMkHhEeChN_IzG{D|WoO`]{RhJ}EhD}AfRqHfC{@zSoFjDu@lKeBjNaB`RiAxJUbJC`KLbKb@jF\\fKfAxRxCtOpBrGf@vNf@rHCpb@yA|s@[rQGrIWrPoBhKmC`N}FrBoAd[{Sbn@gb@`TuNdKiFrHsCrC{@pJqBlCa@bNkAtGK`f@DjXDtPOpT_ApXmCfUcDbQoCb_Ca_@vn@}Jn`@}FxDe@xWsBlQu@fo@oCx}A{G~\\wAdRk@rHHtH\\|E`@hZbErYhD~Kr@~Vn@b]v@vJVbUj@lPNvI?`l@mApiAgCtqAuCfXk@~Jq@hFy@bHiBlBq@bHcDxZaQzL{GtFiCjKcDrJoBfi@_IhfAyOhiBiX|cAyNvtA}NztAuNjb@mEv_@uDdPqAdcAuGnd@wCfaAkGxrAoI~p@qErMeBtLiChM}DzHcDrJ_FzU{MtmA_r@n_@uSvMsGhPwG~[}KfVwHjp@eT|SmGtDyAlZqJ`ZmJvt@iVvOcFdGeAnGc@hC?zDN`WpDrrAbTr\\bFhKxAsItMuNpUgAhC_AjFgC`Jm@zAw@lBr@@dBC~@A|AHnIbCdDdA`AV?]JuBLoC|@qGxC{GdLkVvQqW|OwTfNqSpMwRjMkOha@_e@xI_KnF{G`AeB~A`AnBjApGjDzOrInG~ChMdEpHtC~M|EjKjErAJnAj@vJ~GhFvEpIdId@FfBuAbAmAxAsCrA}BpAx@zFjEfAnAxEpDrDfFpL|F~AhAnGpKlApB~G|KbCgBbCkBxCuBbCeAvN}DhI{BfEcBnBuCPSKG_Au@k@g@EKWW"
        
        if let path = GMSPath(fromEncodedPath: encodePoint) {
            let movesCoord = path.coordinates.reversed()
                .map { Movement(latitude: $0.latitude, longitude: $0.longitude, timestamp: 1483342595) }
            let tracking = Tracking(id: "test", name: "Từ quê lên Hà Nội", movements: movesCoord)
            
            DatabaseSupport.shared.insert(tracking: tracking.convertToRealmType())
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
    
    func numberOfRow(inSection section: Int) -> Int {
        return (0..<section).map { dataArray[$0].count }.reduce(0, +)
        
    }
    
    func refresh() {        
        dataArray = filterTrackingsData()
        UIView.animate(withDuration: 0.3.second) {
            self.tableView.reloadData()
        }
    }
    
    func resetData() {
        insertDataTest()
        dataArray = filterTrackingsData()
        UIView.animate(withDuration: 0.3.second) {
            self.tableView.reloadData()
        }
    }
    
    
    /// Tính chiều cao của `table`
    ///
    /// - Parameter data: Mảng dữ liệu `dataArray`
    /// - Returns:
    func calculateTableViewHeight(with data: [[RealmTracking]]) -> CGFloat {
        
        let sectionsHeight = Size.button.. * CGFloat(data.count)
        let rowsHeight = Size.cell.. * CGFloat(data.map { $0.count }.reduce(0, +))
        
        return sectionsHeight + rowsHeight
    }
    
    /// Ẩn bàn phím
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func nameTrackingChanged(_ textField: UITextField!) {
        
        guard let id = textField.placeholder, let tracking = DatabaseSupport.shared.getTracking(id: id) else {
            HUD.showMessage("Không có dữ liệu 😵", position: .center)
            return
        }
        
        guard let newName = textField.text, newName.characters.count > 0 else {
            HUD.showMessage("Chưa nhập tên mới cho lộ trình 😵")
            textField.text = tracking.name
            return
        }
        
        
        DatabaseSupport.shared.updateName(of: tracking, with: newName)
        
    }
    
    func tracking(_ sender: UIBarButtonItem) {
        showAlert(type: .addNewTracking)
    }
    
    func visibleSection(_ sender: UIGestureRecognizer) {
        guard let view = sender.view as? HeaderTableView else { return }
        
//        let visible = titleSections[view.tag].visible
        titleSections[view.tag].visible = !titleSections[view.tag].visible
        tableView.reloadSections(IndexSet(integer: view.tag), with: .automatic)

        
//        if let section = selectedSection {
//            titleSections[section].visible = !titleSections[section].visible
//            
//            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//        }
//        
//        guard selectedSection != view.tag else { selectedSection = nil; return }
//        
//        selectedSection = view.tag
//        titleSections[view.tag].visible = true
//        tableView.reloadSections(IndexSet(integer: view.tag), with: .automatic)
//        
//        let pathToLastRow = IndexPath(row: dataArray[view.tag].count - 1, section: view.tag)
//        tableView.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
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
//MARK: TRACKING DELEGATE
//=======================================
extension TrackingListsViewController: TrackingViewControllerDelegate {
    func reloadTable() {
        resetData()
    }
}

//=======================================
//MARK: TABLE DELEGATE
//=======================================
extension TrackingListsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count == 0 ? 1 : dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count == 0 ? 1 : (titleSections[section].visible ? dataArray[section].count : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellEmpty) as! EmptyTableViewCell
            configureEmptyCell(cell: cell, atIndexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TrackingTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureEmptyCell(cell: EmptyTableViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.imageView?.image = Icon.Tracking.empty.tint(UIColor.lightGray)
        cell.textLabel?.text = "Hiện tại chưa có lộ trình nào được lưu!"
        cell.selectionStyle = .none
    }
    
    func configureCell(cell: TrackingTableViewCell, indexPath: IndexPath) {
        if indexPath.row == dataArray[indexPath.section].count - 1 {
            cell.seperatorRightPadding = 0
            cell.seperatorStyle = .padding(0)
            
        } else {
            cell.seperatorRightPadding = 15
            cell.seperatorStyle = .padding(15)
        }
        
        
//        cell.imageView?.image = Icon.Tracking.map
        var count = 0
        
        if indexPath.section == 0 {
            count = indexPath.row + 1
        } else {
            count = indexPath.row + 1 + numberOfRow(inSection: indexPath.section)
        }
        
        
        let tracking = dataArray[indexPath.section][indexPath.row].convertToSyncType()
        
        cell.textLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
        cell.textLabel?.textColor = UIColor.main
        cell.textLabel?.text = "\(count)."
        
        cell.textField.text = tracking.name
        cell.textField.placeholder = tracking.id
        cell.textField.delegate = self
        cell.textField.tag = indexPath.section * 1000 + indexPath.row
        cell.textField.addTarget(self, action: #selector(self.nameTrackingChanged), for: .editingDidEnd)
        
        let dateTime = dateTimeFormatter.string(from: Date(timeIntervalSince1970: tracking.movements[0].timestamp))
        
        let time = timeFormatter.string(from: Date(timeIntervalSince1970: tracking.movements[0].timestamp))
        
        let mutableStringTerms =  NSMutableAttributedString(string: dateTime,
                                                            attributes:[NSFontAttributeName: UIFont(name: FontType.latoRegular.., size: FontSize.small..)!, NSForegroundColorAttributeName: UIColor.gray])
        
        
        
        mutableStringTerms.addAttributes([NSFontAttributeName: UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!,
                                          NSForegroundColorAttributeName: UIColor.darkGray],
                                         range: (dateTime as NSString).range(of: time))
        
        
        cell.time.attributedText = mutableStringTerms
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataArray.count > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let tracking = DatabaseSupport.shared.getTracking(id: dataArray[indexPath.section][indexPath.row].id) else { return }
        
        //1. Xóa phần tử `tracking` trong mảng `dataArray`
        dataArray[indexPath.section].remove(at: indexPath.row)
        
        //3. Xóa `tracking` trong database
        Log.message(.debug, message: "---------------- Xóa tracking `\(tracking.id)` ----------------")
        
        DatabaseSupport.shared.deleteTracking(id: tracking.id)
        
        title = "Đã lưu \(DatabaseSupport.shared.getTracking().count) lộ trình"
        
        //4. Reload cell
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //5. Nếu section hiện tại rỗng thì và reload table
        if dataArray[indexPath.section].count == 0 {
            refresh()
        }
        
        delay(1.second) {
            UIView.animate(withDuration: 0.3.second) {
                self.tableView.reloadData()
            }
        }
    }
    
}

//=======================================
//MARK: TABLE DELEGATE
//=======================================
extension TrackingListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissKeyboard()
        
        guard dataArray.count > 0 else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        HUD.showHUD() {
            let trackingVC = TrackingViewController()
            let tracker = self.dataArray[indexPath.section][indexPath.row].convertToSyncType()
            trackingVC.tracking = tracker
            trackingVC.vehicleTrip = VehicleTrip(info: TrackingInfo(tracking: tracker))
            trackingVC.vehicleOnline = VehicleOnline(tracking: tracker)
            self.navigationController?.pushViewController(trackingVC, animated: true)
            HUD.dismissHUD()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Size.button..
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArray.count == 0 ? view.frame.height : Size.cell..
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        /// Mảng các tracking có trong `section`
//        let trackings = dataArray[section]
//        
//        guard trackings.count > 0 else { return nil }
//        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
//        
//        let bg = UIView(frame: headerView.bounds)
//        bg.backgroundColor = UIColor.groupTableViewBackground
//        headerView.addSubview(bg)
//        
//        let textLabel = UILabel(frame: CGRect(x: (headerView.bounds.width - 200) / 2, y: 10, width: 200, height: 20))
//        textLabel.textAlignment = .center
//        textLabel.font = UIFont(name: FontType.latoItalic.., size: FontSize.normal..)
//        textLabel.textColor = UIColor.gray
//        textLabel.text = titleSections[section].title
//        
//        headerView.addSubview(textLabel)
//        
//        headerView.tag = section
//        
//        headerView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.visibleSection(_:)))
//        tap.cancelsTouchesInView = true
//        headerView.addGestureRecognizer(tap)
//        
//        return headerView
        
        let headerView = setupHeaderViewSection(section: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
        guard tableView.frame.origin.y < 0 else { return }
        
        UIView.animate(withDuration: 0.3.second) {
            self.tableView.frame.origin.y = 0
        }
    }
}

//=======================================
//MARK: CLLOCATION MANAGER DELEGATE
//=======================================
extension TrackingListsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        requestLocationService()
    }
}

//=======================================
//MARK: TEXTFIELD DELEGATE
//=======================================
extension TrackingListsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackingName = textField.text
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard tableView.frame.origin.y < 0 else { return true }
        
        UIView.animate(withDuration: 0.3.second) {
            self.tableView.frame.origin.y = 0
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let indexPath = IndexPath(row: textField.tag % 1000, section: textField.tag / 1000)
        
        if let cell = tableView.cellForRow(at: indexPath) as? TrackingTableViewCell {
            
            let keyboardHeight: CGFloat = 216
            let scroll = keyboardHeight - cell.frame.origin.y
            
            if scroll < 0 {
                UIView.animate(withDuration: 0.3.second) {
                    self.tableView.frame.origin.y = scroll
                }
            }

        }
        
        return true
    }
    
}

//=======================================
//MARK: SETUP VIEWS
//=======================================
extension TrackingListsViewController {
    
    fileprivate func setupAllSubviews() {
        title = "Danh sách lộ trình"
        view.backgroundColor = UIColor.groupTableViewBackground
        
        setupBarButton()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        tableView = setupTableView()
        view.addSubview(tableView)
        
    }
    
    fileprivate func setupAllConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(view.snp.top).inset(Size.padding15..)
        }
    }
    
    fileprivate func setupBarButton() {
        
        let left = UIBarButtonItem(image: Icon.Nav.Refesh, style: .plain, target: self, action: #selector(self.resetData))
        left.tintColor = .white
        navigationItem.leftBarButtonItem = left
        
        let right = UIBarButtonItem(image: Icon.Nav.Add, style: .plain, target: self, action: #selector(self.tracking(_:)))
        right.tintColor = .white
        navigationItem.rightBarButtonItem = right
    }
    
    fileprivate func setupTableView() -> UITableView {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = dataArray.count > 0
        tableView.register(TrackingTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: cellEmpty)
        return tableView
    }
    
    fileprivate func setupHeaderViewSection(section: Int) -> UIView {
        
        let headerView = HeaderTableView()
        headerView.title.text = titleSections.count > 0 ? titleSections[section].title : ""
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.tag = section
        
        headerView.arrow.isHidden = false
        guard titleSections.count > 0 else {
            headerView.arrow.alpha = 0
            headerView.seperator.alpha = 0
            return headerView
        }
        
        if titleSections[section].visible {
            headerView.arrow.transform = CGAffineTransform.identity
        } else {
            headerView.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        }
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.visibleSection(_:))))
        
        return headerView
    }
    
}





