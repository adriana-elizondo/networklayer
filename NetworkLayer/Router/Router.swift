//
//  Router.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation
import UIKit

public typealias NetworkRouterCompletion<T> = (_ data: T?,
    _ response: URLResponse?, _ error: NetworkResponseError?) -> Void
public protocol NetworkRouter: class {
    associatedtype EndPoint
    associatedtype ResponseObject
    func request(with route: EndPoint, completion: @escaping NetworkRouterCompletion<ResponseObject>)
    func cancel()
}
public protocol RouterCompletionDelegate: class {
    func didFinishWithSuccess()
    func didFinishWithError()
}
public class Router<E: EndpointType, R: Codable>: NetworkRouter {
    public typealias EndPoint = E
    public typealias ResponseObject = R
    private var task: URLSessionTask?
    private weak var delegate: RouterCompletionDelegate?
    public init() {}
    public func request(with route: E, completion: @escaping (R?, URLResponse?,
        NetworkResponseError?) -> Void) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                //Check status code first
                if error == nil, let urlResponse = response as? HTTPURLResponse, data != nil {
                    //If request succeded and there is a responses
                    if let statusError = self.checkStatusCode(with: urlResponse) {
                        self.handleFailureResponse(with: statusError, with: completion)
                    } else {
                        self.handleSuccessResponse(with: data!, and: response, with: completion)
                    }
                } else {
                    completion(nil, nil, NetworkResponseError.requestFailed)
                }
            })
        } catch {
            completion(nil, nil, NetworkResponseError.requestFailed)
        }
        task?.resume()
    }
    private func buildRequest(from route: E) throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request: break
        case .requestWithParameters(let bodyParameters, let urlParameters):
            do {
                try self.configureParameters(with: bodyParameters, urlParameters: urlParameters, and: &request)
            } catch {
                throw error
            }
        }
        return request
    }
    private func configureParameters<T: Encodable>(with bodyParameters: T?,
                                                   urlParameters: Parameters?, and request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    private func checkStatusCode(with urlResponse: HTTPURLResponse) -> NetworkResponseError? {
        switch urlResponse.statusCode {
        case 200...299:return nil
        case 300...399:
            return NetworkResponseError.redirected
        case 403:
            return NetworkResponseError.forbidden
        case 400...499:
            return NetworkResponseError.badRequest
        case 500...509:
            return NetworkResponseError.serverError
        default:return nil
        }
    }
    private func handleSuccessResponse(with data: Data, and urlResponse: URLResponse?,
                                       with completion: @escaping (R?, URLResponse?, NetworkResponseError?) -> Void) {
        delegate?.didFinishWithSuccess()
        if let responseObject = try? JSONDecoder().decode(ResponseObject.self, from: data) {
            completion(responseObject, urlResponse, nil)
        } else {
            completion(nil, urlResponse, NetworkResponseError.parsingError)
        }
    }
    private func handleFailureResponse(with error: NetworkResponseError,
                                       with completion: @escaping (R?, URLResponse?, NetworkResponseError?) -> Void) {
        delegate?.didFinishWithError()
        completion(nil, nil, error)
    }
    public func cancel() {
        task?.cancel()
    }
}
public class Downloader {
    public typealias DownloadCompletion = (UIImage?, NetworkError?) -> Void
    private let imageCache = NSCache<NSString, AnyObject>()
    static let sharedInstance = Downloader()
    func downloadImage(from url: URL, with completion:@escaping DownloadCompletion) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data) {
                        completion(imageToCache, nil)
                        return
                    }
                    completion(nil, NetworkError.encodingFailed)
                }
            }.resume()
        }
    }
}
