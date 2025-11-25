source("renv/activate.R")


# SET ENV VARS ------------------------------------------------------------


Sys.setenv(
  MP_REM_PROJECT_DIR = file.path(Sys.getenv("MP_REM_SCRATCH"), Sys.getenv("MP_REM_PROJECT"), Sys.getenv("MP_REM_USER"), Sys.getenv("MP_REM_PROJECT_NAME"))
)


# SET VARS ----------------------------------------------------------------


mp_rem_project_dir <- Sys.getenv("MP_REM_PROJECT_DIR")
hpc_account <- Sys.getenv("MP_REM_PROJECT")
mp_rem_container <- Sys.getenv("MP_REM_CONTAINER")
mp_rem_crew_logs_dir <- file.path(mp_rem_project_dir, "logs")


# DETERMINE HOST ----------------------------------------------------------


slurm_host <- Sys.getenv("HOSTNAME")
# print(paste0("HOST: ", slurm_host))


# SET HPC -----------------------------------------------------------------


hpc <- ifelse(slurm_host=="", F, T) # If no host detected then local


# SET RENV PATHS LIB ------------------------------------------------------


if(hpc) {
  Sys.setenv(
    RENV_PATHS_LIBRARY = Sys.getenv("MP_REM_RENV_PATHS_LIBRARY")
  )
}

renv_paths_library <- Sys.getenv("RENV_PATHS_LIBRARY")
