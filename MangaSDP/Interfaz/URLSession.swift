//
//  URLSession.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 22/1/26.
//

import Foundation

extension URLSession {
    func getData(for request: URLRequest) async throws(NetworkError) -> (data: Data, response: HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, httpResponse)
        } catch {
            throw .general(error)
        }
    }
}
