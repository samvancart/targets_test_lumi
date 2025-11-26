# GENERATE PARAMS ---------------------------------------------------------


gen_params <- function(seed, n, workers, size = 100, path = "data/input/params.rds") {
  set.seed(seed)
  x <- c(10,100,1000,10000,100000,1000000)
  values <- sample(x, size = size, replace = TRUE)
  dt <- data.table(val = values)[, id := .GRP, by = .I]
  params <- list(dt = dt, n = n, workers = workers)
  saveRDS(params, path)
  invisible(NULL)
}


# PARALLEL ----------------------------------------------------------------


test_parallel_future <- function(n = 4, val = 1e5, workers = 1) {
  
  plan(multisession, workers = workers)   # multicore on Linux/macOS, multisession on Windows
  
  # Define task: generate a data.table, pause, and return everything
  task <- function(i) {
    Sys.sleep(5)  # simulate workload / delay
    
    dt <- data.table(
      x = rnorm(val),
      y = rnorm(val)
    )
    
    list(
      worker = i,
      pid = Sys.getpid(),  # process ID to confirm parallelism
      table = dt           # full data.table returned
    )
  }
  
  # Execute tasks in parallel
  results <- future_lapply(1:n, task, future.seed = T)
  
  return(results)
}




