//
//  AddressManager.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation

class AddressManager {
    
    static let shared = AddressManager()
    
    private var addressList = [LocationListData]()
    
    private init() {}
    
    private func loadAddressList() throws -> [LocationListData] {
        guard let path = Bundle.main.path(forResource: "addressJSONData", ofType: "json") else {
            throw AddressManagerError.failedToGetAddressJSONFilePath
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            throw AddressManagerError.failedToConvertAddressJSONToString
        }
        guard let data = jsonString.data(using: .utf8) else {
            throw AddressManagerError.failedToConvertAddressStringToData
        }
        guard let decodedData = try? JSONDecoder().decode([LocationListData].self, from: data) else {
            throw AddressManagerError.failedToDecodeAddressJSON
        }
        return decodedData
    }
    
    func getAddressList() throws -> [LocationListData] {
        if addressList.isEmpty {
            do {
                let list = try loadAddressList()
                addressList = list
            } catch {
                throw error
            }
        }
        return addressList
    }
    
    func getCoordinates(locality: String, subLocality: String) throws -> LocationListData {
        
        guard let totaldata = addressList.filter({ $0.locality == locality && $0.subLocality == subLocality }).first else {
            throw AddressManagerError.noMatchingAddressAfterFiltering
        }
        return totaldata
    }
}
