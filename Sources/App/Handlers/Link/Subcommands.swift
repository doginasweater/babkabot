enum LinkCommand {
  case add, search, list

  init?(_ name: String) {
    switch name {
    case "add": self = .add
    case "search": self = .search
    case "list": self = .list
    default: return nil
    }
  }
}
