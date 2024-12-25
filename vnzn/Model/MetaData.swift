import Foundation

@Observable
final class MetaData {

    var archive = Archive()
    var index = Index()
    var tags = Tags()
    var serials = Serials()
    var timeline = Timeline()
    var persons = PersonsRegister()
    var movies = MoviesRegister()
    var books = BooksRegister()
    var indices = IndexRegister()
}
