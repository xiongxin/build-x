use std::collections::HashMap;
use std::fmt;
use thiserror::Error;

pub struct Task {
  pub requires: Vec<String>,
  pub actions: String,
  pub name: String,
}

pub struct Bake {
  pub tasks_graph: HashMap<String, Vec<String>>,
  pub tasks: HashMap<String, Task>,
}

impl fmt::Display for Task {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(
      f,
      "Task {} Requirements: {:?}, actions {}",
      self.name, self.requires, self.actions
    )
  }
}

#[derive(Error, Debug)]
enum BakeError {}

enum NodeColor {
  NcWhite, // 未处理
  NcGrary, // 正在处理
  NcBlack, // 处理完成
}

impl Bake {
  pub fn new() -> Bake {
    Bake {
      tasks_graph: HashMap::new(),
      tasks: HashMap::new(),
    }
  }

  pub fn add_task(&mut self, task_name: &str, deps: Vec<String>, actions: &str) {
    let t = Task {
      name: task_name.to_owned(),
      requires: deps.clone(),
      actions: actions.to_owned(),
    };

    self.tasks_graph.insert(task_name.to_owned(), deps.clone());
    self.tasks.insert(task_name.to_owned(), t);
  }

  pub fn run_task(&self, task_name: &str) {
    // CODE OMITTED FOR FINDING CYCLES...

    let mut deps = Vec::new();
    let mut seen = Vec::new();

    self.run_task_helper(task_name, &mut deps, &mut seen);

    for tsk in deps {
      match self.tasks.get(&tsk) {
        Some(t) => println!("{}", t.actions),
        None => {}
      }
    }
  }

  fn run_task_helper(&self, task_name: &str, deps: &mut Vec<String>, seen: &mut Vec<String>) {
    let task_name = task_name.to_owned();
    if seen.contains(&task_name) {
      println!("[+] Solved {} before no need to repeat action", task_name);
    } else {
      seen.push(task_name.clone());

      match self.tasks.get(&task_name) {
        Some(tsk) => {
          if tsk.requires.len() > 0 {
            match self.tasks_graph.get(&task_name) {
              Some(ts) => {
                for c in ts {
                  self.run_task_helper(c, deps, seen);
                }
              }
              None => {}
            }
          }

          deps.push(task_name.to_owned());
        }
        None => {}
      }
    }
  }

  fn graph_has_cycle(
    &self,
    graph: &HashMap<String, Vec<String>>,
  ) -> (bool, HashMap<String, String>) {
    let mut colors = HashMap::new();
    for (node, _) in graph {
      colors.insert(node.clone(), NodeColor::NcWhite);
    }

    let mut parent_map = HashMap::new();
    let mut has_cycle = false;
    for (node, _) in graph {
      parent_map.insert(node.clone(), "null".to_owned());
      if let Some(NodeColor::NcWhite) = colors.get(node) {
        self.has_cycle_dfs(graph, node, &mut colors, &mut has_cycle, &mut parent_map);
      }
      if has_cycle {
        return (true, parent_map);
      }
    }

    (false, parent_map)
  }

  fn has_cycle_dfs(
    &self,
    graph: &HashMap<String, Vec<String>>,
    node: &str,
    colors: &mut HashMap<String, NodeColor>,
    has_cycle: &mut bool,
    parent_map: &mut HashMap<String, String>,
  ) {
    if *has_cycle {
      return;
    }
    // 当前节点设置为灰色
    colors.insert(node.to_owned(), NodeColor::NcGrary);
    // 处理当前节点的依赖
    if let Some(deps) = graph.get(node) {
      for dep in deps {
        // 处理依赖的依赖
        parent_map.insert(dep.clone(), node.to_owned());
        if let Some(NodeColor::NcGrary) = colors.get(dep) {
          *has_cycle = true;
          parent_map.insert(format!("__CYCLESTART__"), dep.clone());
          return;
        }
        if let Some(NodeColor::NcWhite) = colors.get(dep) {
          self.has_cycle_dfs(graph, node, colors, has_cycle, parent_map);
        }
      }
    }
  }
}
