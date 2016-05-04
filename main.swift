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
      let word = line[line.startIndex.advancedBy(level)..<line.endIndex]
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

func buildTOC(toc: [(level: Int, word: String)]) -> String {
  var res = ""
  for (level, word) in toc {
    res += String(count: (level-1) * 2, repeatedValue: Character(" "))
    res += "- "
    res += word
    res += "\n"
  }
  return res
}

print(toTOC(readLine), terminator: "")
