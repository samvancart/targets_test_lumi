# SET ENV VARS ------------------------------------------------------------


Sys.setenv(
  MP_REM_USER_PROJECTS_DIR = file.path(Sys.getenv("MP_REM_SCRATCH"), Sys.getenv("MP_REM_PROJECT"), Sys.getenv("MP_REM_USER"))
)


# SET VARS ----------------------------------------------------------------


mp_rem_user_projects_dir <- Sys.getenv("MP_REM_USER_PROJECTS_DIR")
mp_rem_project_name <- Sys.getenv("MP_REM_PROJECT_NAME")
mp_rem_project_dir <- file.path(mp_rem_user_projects_dir, mp_rem_project_name)
mp_rem_container <- Sys.getenv("MP_REM_CONTAINER")
mp_rem_container_dir <- Sys.getenv("MP_REM_CONTAINER_DIR")
mp_rem_container_path <- file.path(mp_rem_user_projects_dir, mp_rem_container_dir, mp_rem_container)
mp_rem_crew_logs_dir <- file.path(mp_rem_project_dir, "logs")
hpc_account <- Sys.getenv("MP_REM_PROJECT")
mp_git_repo_ssh <- Sys.getenv("MP_GIT_REPO_SSH")


# DETERMINE HOST ----------------------------------------------------------


# Detect environment
host <- Sys.getenv("HOSTNAME", unset = "")

# 1. Detect Docker (local container)
in_docker <- file.exists("/.dockerenv") ||
  (file.exists("/proc/1/cgroup") &&
     any(grepl("docker", readLines("/proc/1/cgroup"))))

# 2. Detect local bare metal (hostname == "")
is_local <- (host == "" && !in_docker)

# 3. Detect CSC (Puhti or Lumi)
is_puhti <- grepl("^puhti-", host)
is_lumi  <- grepl("^uan[0-9]+", host)
is_csc   <- is_puhti || is_lumi

# Flag for HPC
hpc <- is_csc

# 4. Print where it is loaded
if (in_docker) {
  message("Loaded in local Docker container (hostname: ", host, ")")
} else if (is_local) {
  message("Loaded locally (no Docker)")
} else if (is_puhti) {
  message("Loaded on CSC Puhti (hostname: ", host, ")")
} else if (is_lumi) {
  message("Loaded on CSC Lumi (hostname: ", host, ")")
} else {
  message("Loaded in unknown environment (hostname: ", host, ")")
}

# Optional: set HPC-specific options
if (hpc) {
  options(hpc = TRUE)
} else {
  options(hpc = FALSE)
}


# SET RENV PATHS LIB ------------------------------------------------------


if(hpc) {
  Sys.setenv(
    RENV_PATHS_LIBRARY = file.path(mp_rem_project_dir, "renv")
  )
}

renv_paths_library <- Sys.getenv("RENV_PATHS_LIBRARY")


# ACTIVATE RENV -----------------------------------------------------------


source("renv/activate.R")


# WRITE CONFIG ------------------------------------------------------------


config <- list(
  MP_REM_PROJECT_NAME=mp_rem_project_name,
  MP_REM_PROJECT_DIR=mp_rem_project_dir,
  MP_REM_CONTAINER_PATH=mp_rem_container_path,
  MP_GIT_REPO_SSH=mp_git_repo_ssh
)

if (!dir.exists("config")) dir.create("config", recursive = TRUE)

# yaml::write_yaml(config, file.path("config", "rem_config.yml")) # Yaml needs to be configured in container

# --- Write ENV (for bash) ---
env_lines <- paste(names(config), unlist(config), sep="=")
writeLines(env_lines, con = file.path("config", "rem_config.env"))


# SBATCH WRAPPER ----------------------------------------------------------

sbatch_wrapper_file <- paste0(Sys.getenv("HOME"), "/bin/sbatch-wrapper")
  cmd_submit <- if(file.exists(sbatch_wrapper_file)) {
    sbatch_wrapper_file
  } else {
    "sbatch"
  }




