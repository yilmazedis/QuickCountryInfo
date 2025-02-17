//
//  SearchCountry.swift
//  CountryApp
//
//  Created by yilmaz on 19.05.2022.
//

import UIKit

final class SearchCountryViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: K.cell)
        return table
    }()
    
    lazy var searchBar:UISearchBar = UISearchBar()
    private let viewModel = SearchCountryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        configureSearchBar()
        configureNavigationBar(with: "Search Country")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search Country"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        tableView.tableHeaderView = searchBar
    }
}

extension SearchCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCountryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        
        let country = viewModel.getCountry(at: indexPath.row)
        
        let name = country.name
        let nativeName = country.nativeName
        let flag = country.flag
        
        cell.textLabel?.text = flag + "    " + name + " - " + nativeName
        cell.textLabel?.labelSizeChange(into: UIFont.systemFont(ofSize: 40), from: 0, to: 4)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let country = viewModel.getCountry(at: indexPath.row)
        vc.viewModel.setCountry(with: country)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(K.cellHight)
    }
}

extension SearchCountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if textSearched.isEmpty {
            viewModel.unload()
            tableView.reloadData()
            return
        }
        
        print(textSearched)
        loadTableViewCells(with: textSearched)
    }
    
    private func loadTableViewCells(with what: String) {
        viewModel.fetchCountries(with: K.baseUrl + K.fetchByName + what) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

