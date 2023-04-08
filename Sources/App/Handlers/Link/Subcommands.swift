enum LinkCommand: String {
  case add = "add"
  case search = "search"
  case list = "list"

  init?(_ name: String) {
    switch name {
    case "add": self = .add
    case "search": self = .search
    case "list": self = .list
    default: return nil
    }
  }

  var v: String {
    self.rawValue
  }
}

enum AddOption: String {
  case url = "url"
  case description = "description"
  case tags = "tags"
  case privacy = "privacy"

  var v: String {
    self.rawValue
  }
}
