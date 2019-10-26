import tables, strutils

type 
  Section = ref object
    properties: Table[string, string]
  Ini = ref object
    sections: Table[string, Section]
  ParserState = enum
    readSection
    readKV
  

proc setProperty*(this: Section, name: string, value: string) =
  this.properties[name] = value

proc newSection*(): Section =
  result = Section()
  result.properties = initTable[string, string]()


proc `$`*(this: Section) : string =
  result = "<Section" & $this.properties & " >"

proc newIni*() : Ini =
  result = Ini()
  result.sections = initTable[string, Section]()

proc `$`*(this: Ini) : string =
  result = "<Ini " & $this.sections & " >"

proc setSection*(this: Ini, name: string, section: Section) =
    this.sections[name] = section

proc getSection*(this: Ini, name: string): Section =
    return this.sections.getOrDefault(name)

proc hasSection*(this: Ini, name: string): bool =
    return this.sections.contains(name)

proc deleteSection*(this: Ini, name:string) =
    this.sections.del(name)

proc sectionsCount*(this: Ini) : int = 
    echo $this.sections
    return len(this.sections)

proc hasProperty*(this: Ini, sectionName: string, key: string): bool=
  return this.sections.contains(sectionName) and this.sections[sectionName].properties.contains(key)

proc setProperty*(this: Ini, sectionName: string, key: string, value:string) =
  echo $this.sections
  if this.sections.contains(sectionName):
    this.sections[sectionName].setProperty(key, value)
  else:
    raise newException(ValueError, "Ini doesn't have section " & sectionName)

proc getProperty*(this: Ini, sectionName: string, key: string) : string =
  if this.sections.contains(sectionName):
    return this.sections[sectionName].properties.getOrDefault(key)
  else:
    raise newException(ValueError, "Ini doesn't have section " & sectionName)


proc deleteProperty*(this: Ini, sectionName: string, key: string) =
  if this.sections.contains(sectionName) and this.sections[sectionName].properties.contains(key):
    this.sections[sectionName].properties.del(key)
  else:
    raise newException(ValueError, "Ini doesn't have section " & sectionName)

proc toIniString*(this: Ini, sep:char='=') : string =
  var output = ""
  for sectName, section in this.sections:
    output &= "[" & sectName & "]" & "\n"
    for k, v in section.properties:
      output &= k & sep & v & "\n" 
    output &= "\n"
  return output

proc parseIni*(s: string) : Ini =
  result = newIni()
  var state: ParserState = readSection
  let lines = s.splitLines()

  var currentSectionName : string = ""
  var currentSection = newSection()

  for line in lines:
    if line.strip() == "" or line.startsWith(";") or line.startsWith("#"): continue
    if line.startsWith("[") and line.endsWith("]"):
      state = readSection

    if state == readSection:
      currentSectionName = line[1 .. ^2]
      result.setSection(currentSectionName, currentSection)
      state = readKV
      continue
    if state == readKV:
      let parts = line.split({ '=' })
      if len(parts) == 2:
        result.setProperty(currentSectionName, parts[0].strip(), parts[1].strip())
  

when isMainModule:
  var s = """
[general]
appname = configparser
version = 0.1

[author]
name = xmonader
email = notxmonader@gmail.com
"""
  var ini = parseIni(s)
  echo repr($ini)
  echo ini.getProperty("general", "appname")
  echo ini.getProperty("author", "email")