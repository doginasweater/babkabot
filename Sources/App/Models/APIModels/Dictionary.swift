struct ApiResponse: Decodable {
  let word: String?
  let phonetic: String?
  let phonetics: [Phonetic]?
  let origin: String?
  let meanings: [Meaning]?
  let license: License?
  let sourceUrls: [String]?
}

struct Meaning: Decodable {
  let partOfSpeech: String?
  let definitions: [Definition]?
}

struct Definition: Decodable {
  let definition: String?
  let example: String?
  let synonyms: [String]?
  let antonyms: [String]?
}

struct Phonetic: Decodable {
  let text: String?
  let audio: String?
  let sourceUrl: String?
  let license: License?
}

struct License: Decodable {
  let name: String?
  let url: String?
}
