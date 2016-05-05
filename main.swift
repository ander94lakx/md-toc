import Foundation



func toTOC(read: (stripNewline: Bool) -> String?) -> String {
  var toc: [(level: Int, word: String)] = []

  var prevLine = ""
  while let line = read(stripNewline: true) {
    if line.hasPrefix("```") {
      while true {
        let nextLine = read(stripNewline: true)
        if nextLine == nil || nextLine == "```" {
          break
        }
      }
    } else {
      if onlyCharacter(line, expected: Character("=")) {
        toc.append((level: 1, word: prevLine))
        continue
      }

      if onlyCharacter(line, expected: Character("-")) {
        toc.append((level: 2, word: prevLine))
        continue
      }
      prevLine = line

      if !line.hasPrefix("#") {
        continue
      }

      var level = 0
      for c in line.characters {
        if c == "#" {
          level += 1
        } else {
          break
        }
      }
      var word = line[line.startIndex.advancedBy(level)..<line.endIndex]
      while word.hasPrefix(" ") {
        word = word[word.startIndex.advancedBy(1)..<word.endIndex]
      }
      toc.append((level: level, word: word))
    }
  }
  return buildTOC(toc)
}

func onlyCharacter(target: String, expected: Character) -> Bool {
  if target.isEmpty {
    return false
  }
  for c in target.characters {
    if c != expected {
      return false
    }
  }
  return true
}

func HeaderToAnchor(target: String) -> String {
  var res = ""
  var isSym = false
  for c in target.characters {
    switch c {
      case "a"..."z", "A"..."Z", "0"..."9":
        if isSym {
          res += "-"
          isSym = false
        }
        res += String(c).lowercaseString
      default:
        isSym = true
        break
    }
  }
  return res;
}

func buildTOC(toc: [(level: Int, word: String)]) -> String {
  var res = ""
  for (level, word) in toc {
    let anchor = HeaderToAnchor(word)
    let indent = String(count: (level-1) * 2, repeatedValue: Character(" "))
    res += "\(indent)- [\(word)](#\(anchor))\n"
  }
  return res
}

print(toTOC(readLine), terminator: "")
