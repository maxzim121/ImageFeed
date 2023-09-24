//import Foundation
//
//struct PhotosResult: Codable {
//    let id: String
//    let createdAt: String
//    let width: Int
//    let height: Int
//    let description: String
//    let likedByUser: Bool
//    let urls: UrlsResult
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case width
//        case height
//        case description
//        case likedByUser = "liked_by_user"
//        case urls
//    }
//
//}
//
//struct UrlsResult: Codable {
//    let full: String
//    let thumb: String
//}
//
//struct Photo {
//    let id: String
//    let size: CGSize
//    let createdAt: Date?
//    let welcomeDescription: String?
//    let thumbImageURL: String
//    let largeImageURL: String
//    let isLiked: Bool
//}
//
//final class ImageListService {
//
//    private let dateFormatter = FormatDate.shared
//    private let urlSession = URLSession.shared
//    private var task: URLSessionTask?
//
//    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
//
//    private (set) var photos: [Photo] = []
//
//    private var lastLoadedPage: Int?
//
////    let nextPage = lastLoadedPage == nil
////        ? 1
////        : lastLoadedPage!.number + 1
//
//    func fetchPhotosNextPage() {
//
//        assert(Thread.isMainThread)
//        if task == nil {return}
//
//        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
//                lastLoadedPage = page
//
//        var request = imagesListRequest(page: String(page))
//
//        task = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<[PhotosResult], Error>) in
//            DispatchQueue.main.async {
//                guard let self = self else {return}
//                switch result {
//                case .success(let body):
//                    body.forEach { photo in
//                        let photo = Photo(id: photo.id,
//                                          size: CGSize(width: photo.width, height: photo.height),
//                                          createdAt: self.dateFormatter.setupModelDate(createAt: photo.createdAt),
//                                          welcomeDescription: photo.description,
//                                          thumbImageURL: photo.urls.thumb,
//                                          largeImageURL: photo.urls.full,
//                                          isLiked: photo.likedByUser)
//                        self.photos.append(photo)
//                    }
//                    NotificationCenter.default.post(name: ImageListService.DidChangeNotification,
//                                                    object: self,
//                                                    userInfo: ["URL": self.photos])
//                case .failure(let error):
//                    print(error)
//                }
//            }
//
//
//        }
//
//    }
//
//    func imagesListRequest(page: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/photos"
//            + "?page=\(page)",
//            httpMethod: "get"
//        )
//    }
//
//}
