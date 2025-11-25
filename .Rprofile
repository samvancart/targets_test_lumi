# SET ENV VARS ------------------------------------------------------------


Sys.setenv(
  MP_REM_USER_PROJECTS_DIR = file.path(Sys.getenv("MP_REM_SCRATCH"), Sys.getenv("MP_REM_PROJECT"), Sys.getenv("MP_REM_USER"))
)


# SET VARS ----------------------------------------------------------------

mp_rem_user_projects_dir <- Sys.getenv("MP_REM_USER_PROJECTS_DIR")
mp_rem_project_dir <- file.path(mp_rem_user_projects_dir, Sys.getenv("MP_REM_PROJECT_NAME"))
mp_rem_container <- Sys.getenv("MP_REM_CONTAINER")
mp_rem_container_dir <- Sys.getenv("MP_REM_CONTAINER_DIR")
mp_rem_crew_logs_dir <- file.path(mp_rem_project_dir, "logs")
mp_rem_container_path <- file.path(mp_rem_user_projects_dir, mp_rem_container_dir, mp_rem_container)
hpc_account <- Sys.getenv("MP_REM_PROJECT")


# DETERMINE HOST ----------------------------------------------------------


slurm_host <- Sys.getenv("HOSTNAME")
# print(paste0("HOST: ", slurm_host))


# SET HPC -----------------------------------------------------------------


hpc <- ifelse(slurm_host=="", F, T) # If no host detected then local


# SET RENV PATHS LIB ------------------------------------------------------


if(hpc) {
  Sys.setenv(
    RENV_PATHS_LIBRARY = file.path(mp_rem_project_dir, "renv")
  )
}

renv_paths_library <- Sys.getenv("RENV_PATHS_LIBRARY")

# ACTIVATE RENV -----------------------------------------------------------


source("renv/activate.R")













