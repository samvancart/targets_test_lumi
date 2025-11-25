# LOAD LIBS ---------------------------------------------------------------


library(targets)
library(tarchetypes)
library(crew)
library(crew.cluster)


# SET ACCOUNT -------------------------------------------------------------


print(hpc_account)


# SCRIPT LINES ------------------------------------------------------------


# Lines for running crew in a container
script_lines_container <- c(
paste0("#SBATCH --account=", hpc_account),
paste0("cd ",  mp_rem_project_dir),
paste0("CONTAINER=", mp_rem_container),
  "export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK",
  paste0("singularity exec \\
  --bind ", mp_rem_project_dir, ":", mp_rem_project_dir, " \\
  --bind ", renv_paths_library,":", renv_paths_library, " \\
  --bind $HOME/bin:/home/$USER/bin \\
  --env PATH=$PATH \\
  --env RENV_PATHS_LIBRARY=", renv_paths_library," \\
  $CONTAINER \\")
    )

# Script lines for the EasyBuild R installation
script_lines_lumi <- c(paste0("#SBATCH --account=", hpc_account),
      paste0("module load LUMI/24.03"),
      paste0("module load R"))


# CONTROLLERS --------------------------------------------------------------


controller_hpc_small <- crew.cluster::crew_controller_slurm(
  name = "hpc_small",
  # host = host_ip, # Should not be needed
  workers = 1,
  seconds_idle = 20, # time until workers are shut down after idle
  options_cluster = crew.cluster::crew_options_slurm(
    verbose = TRUE, #prints job ID when submitted
    command_submit = paste0(Sys.getenv("HOME"), "/bin/sbatch-wrapper"),
    # command_terminate = "scancel-wrapper", # Deprecated
        script_lines = script_lines_container,
    log_output = file.path(mp_rem_crew_logs_dir, "crew_small_log_%A.out"),
    log_error = file.path(mp_rem_crew_logs_dir, "crew_small_log_%A.err"),
    script_directory = tools::R_user_dir("crew.cluster", which = "cache"),
    memory_gigabytes_per_cpu = 5,
    cpus_per_task = 3,
    time_minutes = 2, # wall time for each worker
    partition = "debug"
  )
)


controller_local <- crew::crew_controller_local(
  name = "local",
  workers = 1,
  options_local = crew::crew_options_local(log_directory = "logs"),
  # Uncomment to add logging via the autometric package
  # options_metrics = crew::crew_options_metrics(
  #   path = "/dev/stdout",
  #   seconds_interval = 1
  # )
)


# SET TARGET OPTIONS ------------------------------------------------------


tar_option_set(
  packages = c("data.table"), # Packages that your targets need for their tasks.
  controller = crew::crew_controller_group(
    controller_local,
    controller_hpc_small
  ),
  resources = tar_resources(
    # if on HPC use "hpc_small" controller by default, otherwise use "local"
   crew = tar_resources_crew(controller = ifelse(hpc, "hpc_small", "local"))
  )
)


# SOURCE FUNCTIONS --------------------------------------------------------


# Source all functions in R/
tar_source()


# TARGETS LIST ------------------------------------------------------------


# Replace the target list below with your own:
list(
    tar_target(
        name = values,
        command = c(100000, 100000)
        ),
  tar_target(
    name = data,
    command =   print(data.table(x = rnorm(values), y = rnorm(values))),
    pattern = map(values),
    iteration = "list"
    # format = "qs" # Efficient storage for general data objects.
  ),
  resources = tar_resources(
    # if on HPC use "hpc_small" controller by default, otherwise use "local"
   crew = tar_resources_crew(controller = ifelse(hpc, "hpc_small", "local"))
  )
)










