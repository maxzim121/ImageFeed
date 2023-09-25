import Foundation

struct OnePhoto: Codable {
    let photo: PhotosResult
}

struct PhotosResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }

}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImageListService {

    private let dateFormatter = FormatDate.shared
    private let urlSession = URLSession.shared
    private var photosTask: URLSessionTask?
    private var likeTask: URLSessionTask?
    private let tokenStorage = OAuth2TokenKeychainStorage()

    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImageListService()

    private (set) var photos: [Photo] = []

    private var lastLoadedPage: Int?

    func fetchPhotosNextPage() {

        assert(Thread.isMainThread)
        if photosTask != nil {return}
        guard let bearerToken = tokenStorage.getToken() else { return }

        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
                lastLoadedPage = page

        var request = imagesListRequest(page: String(page))
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        photosTask = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<[PhotosResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let body):
                    body.forEach { photo in
                        let photo = Photo(id: photo.id,
                                          size: CGSize(width: photo.width, height: photo.height),
                                          createdAt: self.dateFormatter.setupModelDate(createAt: photo.createdAt),
                                          welcomeDescription: photo.description ?? "",
                                          thumbImageURL: photo.urls.thumb,
                                          largeImageURL: photo.urls.full,
                                          isLiked: photo.likedByUser)
                        self.photos.append(photo)
                    }
                    print(self.photos.count)
                    NotificationCenter.default.post(name: ImageListService.DidChangeNotification,
                                                    object: self,
                                                    userInfo: ["photos": self.photos])
                case .failure(let error):
                    print(error)
                }
                self.photosTask = nil
            }


        }

    }

    func imagesListRequest(page: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)",
            httpMethod: "get"
        )
    }

}

extension ImageListService {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo,Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if likeTask != nil {return}
        var method = isLike ? "delete" : "post"
        print(method)
        var request = likeChangeRequest(method: method, photoId: photoId)
        guard let bearerToken = tokenStorage.getToken() else { return }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        likeTask = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<OnePhoto, Error>) in
            print("работаем")
            DispatchQueue.main.async {
                print("работаем2")
                guard let self = self else {return}
                print("работаем3")
                switch result {
                case .success(let body):
                    let newPhoto = Photo(id: body.photo.id,
                                      size: CGSize(width: body.photo.width, height: body.photo.height),
                                      createdAt: self.dateFormatter.setupModelDate(createAt: body.photo.createdAt),
                                      welcomeDescription: body.photo.description ?? "",
                                      thumbImageURL: body.photo.urls.thumb,
                                      largeImageURL: body.photo.urls.full,
                                      isLiked: body.photo.likedByUser)
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                            print(newPhoto)
                            self.photos[index] = newPhoto
                    }
                    completion(.success(newPhoto))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
                self.likeTask = nil
            }
        }
    }
    
    func likeChangeRequest(method: String, photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: method
        )
    }
}
