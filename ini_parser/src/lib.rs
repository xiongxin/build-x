use std::collections::HashMap;
use std::fmt;
use thiserror::Error;

#[derive(Debug)]
pub struct Section {
  properties: HashMap<String, String>,
}

pub struct Ini {
  sections: HashMap<String, Section>,
}

impl fmt::Display for Section {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "<Section {:?}>", self.properties)
  }
}

impl fmt::Display for Ini {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "<Ini {:?}>", self.sections)
  }
}

impl Section {
  pub fn new() -> Section {
    Section {
      properties: HashMap::new(),
    }
  }
}

#[derive(Error, Debug)]
pub enum IniError {
  #[error("Ini doesn't have section {0}")]
  NotContainSectionNameError(String),

  #[error("Ini section {0} doesn't have property {1}")]
  NotContainPropertyNameError(String, String),

  #[error("Key is not exist")]
  KeyReadError,

  #[error("Key({0})'s value is not exist")]
  ValueReadError(String),
}

impl Ini {
  fn new() -> Ini {
    Ini {
      sections: HashMap::new(),
    }
  }

  pub fn set_section(&mut self, name: &str, section: Section) {
    self.sections.insert(String::from(name), section);
  }

  pub fn get_section(&self, name: &str) -> Option<&Section> {
    self.sections.get(name)
  }

  pub fn has_section(&self, name: &str) -> bool {
    self.sections.get(name).is_some()
  }

  pub fn delete_section(&mut self, name: &str) {
    self.sections.remove(name);
  }

  pub fn section_count(&self) -> usize {
    self.sections.keys().count()
  }

  pub fn has_property(&self, section_name: &str, key: &str) -> bool {
    self.sections.contains_key(section_name)
      && self
        .sections
        .get(section_name)
        .unwrap()
        .properties
        .contains_key(key)
  }

  pub fn set_property(
    &mut self,
    section_name: &str,
    key: &str,
    value: &str,
  ) -> Result<(), IniError> {
    if self.sections.contains_key(section_name) {
      self
        .sections
        .get_mut(section_name)
        .unwrap()
        .properties
        .insert(key.to_owned(), value.to_owned());
      Ok(())
    } else {
      Err(IniError::NotContainSectionNameError(
        section_name.to_owned(),
      ))
    }
  }

  pub fn get_property(&self, section_name: &str, key: &str) -> Result<&str, IniError> {
    if self.sections.contains_key(section_name) {
      self
        .sections
        .get(section_name)
        .unwrap()
        .properties
        .get(key)
        .map(|v| &v[..])
        .ok_or(IniError::NotContainPropertyNameError(
          section_name.to_owned(),
          key.to_owned(),
        ))
    } else {
      Err(IniError::NotContainSectionNameError(
        section_name.to_owned(),
      ))
    }
  }

  pub fn delete_property(&mut self, section_name: &str, key: &str) -> Result<(), IniError> {
    if self.sections.contains_key(section_name) {
      self
        .sections
        .get_mut(section_name)
        .unwrap()
        .properties
        .remove(key)
        .map(|_| ())
        .ok_or(IniError::NotContainPropertyNameError(
          section_name.to_owned(),
          key.to_owned(),
        ))
    } else {
      Err(IniError::NotContainSectionNameError(
        section_name.to_owned(),
      ))
    }
  }

  pub fn to_ini_string(&self) -> String {
    let mut res = String::new();

    for (sect_name, section) in self.sections.iter() {
      res += &format!("[{}]", sect_name);
      for (k, v) in section.properties.iter() {
        res += &format!("{}={}\n", k, v);
      }
    }

    res
  }

  pub fn parse(s: &str) -> Result<Ini, IniError> {
    let mut ini = Ini::new();
    let mut state = ParserState::ReadSection;
    let mut current_section_name = "";

    for line in s.lines() {
      if line.trim() == "" || line.starts_with(";") || line.starts_with("#") {
        continue;
      }

      if line.starts_with("[") && line.ends_with("]") {
        state = ParserState::ReadSection;
      }
      match state {
        ParserState::ReadSection => {
          current_section_name = &line[1..line.len() - 1];
          ini.set_section(current_section_name, Section::new());
          state = ParserState::ReadKV;
        }
        ParserState::ReadKV => {
          let mut parts = line.split("=");
          let key = parts.next().ok_or(IniError::KeyReadError)?.trim();
          let value = parts
            .next()
            .ok_or(IniError::ValueReadError(String::from(key)))?
            .trim();
          ini.set_property(current_section_name, key, value)?;
        }
      }
    }

    Ok(ini)
  }
}

enum ParserState {
  ReadSection, // when we are supposed to extract section name from the current line
  ReadKV,      // when we are supposed to read the line in key value pair mode
}
