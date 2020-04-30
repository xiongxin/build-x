use std::thread;
use std::sync::mpsc; // 多生产 单消费
use std::sync::Arc;
use std::sync::Mutex;

pub struct ThreadPool {
  workers: Vec<Worker>,
  sender: mpsc::Sender<Job>,
}


impl ThreadPool {
  pub fn new(size: usize) -> ThreadPool {
    assert!(size > 0);

    let (sender, receiver) = mpsc::channel();
    let receiver = Arc::new(Mutex::new(receiver));
    let mut workers = Vec::with_capacity(size);

    for id in 0..size {
      // create some threads and store them in the vector
      workers.push(Worker::new(id, Arc::clone(&receiver)));
    }

    ThreadPool { workers, sender }
  }

  pub fn execute<F>(&self, f: F) 
  where 
    F: FnOnce() + Send + 'static, 
  {
    let job = Box::new(f);

    self.sender.send(job).unwrap();
  }
}

struct Worker {
  id: usize,
  thread: thread::JoinHandle<()>,
}

impl Worker {
  fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
    let thread = thread::spawn(move || {
      while let Ok(job) = receiver.lock().unwrap().recv() {
        println!("Worker {} got a job; executing.", id);

        job();
      }
    });

    Worker { id, thread }
  }
}

type Job = Box<dyn FnOnce() + Send + 'static>;