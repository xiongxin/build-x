use crate::ParserState::{NoOp, ReadKeyValue, ReadList, SectionName};
use std::collections::HashMap;
use std::fs;

fn main() {
  let code = fs::read_to_string("test.txt").unwrap();
  println!("{:#?}", parse_dmi(code));
}

#[derive(Default, Debug, Clone)]
struct Property {
  val: String,
  items: Vec<String>,
}

#[derive(Default, Debug)]
struct Section {
  handle_line: String,
  title: String,
  props: HashMap<String, Property>,
}

impl Property {
  fn add_item(&mut self, item: String) {
    self.items.push(item);
  }
}

fn get_indent_level(line: &str) -> usize {
  for (idx, c) in line.chars().enumerate() {
    if !c.is_ascii_whitespace() {
      return idx;
    }
  }

  return 0;
}

enum ParserState {
  NoOp,         // no action yet
  SectionName,  // read section name
  ReadKeyValue, // read  a line has colon : in it into a key value pair
  ReadList,     // when the next line has greater indentation level than the property line
}

fn parse_dmi(source: String) -> HashMap<String, Section> {
  let mut state = NoOp;
  let lines = source.lines();
  let mut sects = HashMap::new();
  let mut s: Option<Section> = None;
  let mut p = Property::default();
  let mut lines_peekable = lines.peekable();
  let mut k = String::default();
  let mut v = String::default();

  loop {
    let mut current_line = lines_peekable.next();
    let next_line = lines_peekable.peek();
    let next_line_indent = next_line.map_or(0, |line| {
      let idx = get_indent_level(line);
      idx
    });

    if current_line.is_none() {
      s = s.and_then(|s| {
        let title = s.title.clone();
        sects.insert(title, s);
        None
      });
      break;
    } else {
      let mut current_line = current_line.unwrap();
      let current_line_indent = get_indent_level(current_line);
      if current_line.starts_with("Handle") {
        let mut sd = Section::default();
        sd.handle_line = String::from(current_line);
        s = Some(sd);
        state = SectionName;
        continue;
      }

      match state {
        SectionName => {
          s = s.and_then(|mut s| {
            s.title = String::from(current_line);
            Some(s)
          });
          state = ReadKeyValue;
        }
        ReadKeyValue => {
          let mut pair = current_line.split(":");
          k = pair.next().unwrap().trim().to_string();
          v = pair.next().unwrap_or("").trim().to_string();
          p = Property {
            val: v,
            items: vec![],
          };
          if next_line_indent > current_line_indent {
            // 读取 items
            state = ReadList
          } else {
            s = s.and_then(|mut s| {
              s.props.insert(k.clone(), p.clone());
              Some(s)
            });
          }
        }
        ReadList => {
          p.items.push(String::from(current_line.trim()));
          if current_line_indent > next_line_indent {
            state = ReadKeyValue;
            s = s.and_then(|mut s| {
              s.props.insert(k.clone(), p.clone());
              Some(s)
            });
          }
        }
        _ => {}
      }
    }
  }

  return sects;
}
