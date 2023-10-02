//
//  MultiplayerConnectivityBrowserViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 27.09.23.
//

import UIKit

final class MultiplayerConnectivityBrowserViewController: UIViewController {
        
     private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ShipsMapsBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playersTableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: ViewModelForPlayersTableView = ViewModelForPlayersTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundImage)
        self.view.addSubview(playersTableView)
        
        self.playersTableView.dataSource = self
        self.playersTableView.delegate = self
        
        self.playersTableView.register(CellForPlayersTableView.self, forCellReuseIdentifier: "cell")
        self.playersTableView.register(PlayersTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        self.playersTableView.register(PlayersTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: "footer")
        
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.playersTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.playersTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.playersTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.playersTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        configuireViewModel()
    }
        
    func setViewModelMultipeerConectivityHandler(with handler: MultiplayerConectionAsMPCHandler) {
        self.viewModel.setConnectivityHandler(with: handler)
    }
    
    func configuireViewModel() {
        self.viewModel.functionalityWhenDataRecieved = { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async(qos: .userInteractive) {
                self.playersTableView.reloadData()
            }
        }
        self.viewModel.functionalityWhenConnectionFailed = { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async(qos: .userInteractive) {
                self.playersTableView.isUserInteractionEnabled = true
            }
        }
        self.viewModel.setDelegateForConnectivity()
        self.viewModel.getDataFromDataModel()
    }
    
}

extension MultiplayerConnectivityBrowserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.givenDataForPlayerNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellForPlayersTableView
        cell.configuration(name: self.viewModel.givenDataForPlayerNames[indexPath.row], icon: self.viewModel.givenDataForPlayerIcons[indexPath.row])
        switch self.viewModel.givenDataForConnectionStates[indexPath.row] {
        case .notNonnected:
            cell.setStateLabelText(with: "Not Connected")
        case .connecting:
            cell.setStateLabelText(with: "Connecting...")
        case .connected:
            cell.setStateLabelText(with: "Connected...")
        case .networkMissing:
            cell.setStateLabelText(with: "Network missing")
        case .canceled:
            cell.setStateLabelText(with: "Invite cancelled")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.playersTableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! PlayersTableViewHeaderView
        header.configure()
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = self.playersTableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as! PlayersTableViewFooterView
        footer.configuire(with: "Searching players...")
        return footer
    }
}

extension MultiplayerConnectivityBrowserViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playersTableView.isUserInteractionEnabled = false
        self.playersTableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.multipeerConnectivityForPlayers.setInviterIndex(with: indexPath)
        let encodedData = try? JSONEncoder().encode(PlayerContextualData(playerName: DataAboutPlayerSingleton.shared.providePlayerName(), playerIconDescription: DataAboutPlayerSingleton.shared.provideIconDescription()))
        self.viewModel.multipeerConnectivityForPlayers.browserForConnect.invitePeer(self.viewModel.providePeerId(at: indexPath), to: self.viewModel.multipeerConnectivityForPlayers.multiplayerSession, withContext: encodedData, timeout: 30)
        self.viewModel.setConnectionState(self.viewModel.multipeerConnectivityForPlayers, for: indexPath, with: .connecting)
    }
}
