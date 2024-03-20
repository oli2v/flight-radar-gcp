variable "dataproc_master_machine_type" {
  type        = string
  description = "dataproc master node machine type"
  default     = "e2-standard-2"
}

variable "dataproc_worker_machine_type" {
  type        = string
  description = "dataproc worker nodes machine type"
  default     = "e2-standard-2"
}

variable "dataproc_workers_count" {
  type        = number
  description = "count of worker nodes in cluster"
  default     = 2
}

variable "dataproc_master_bootdisk" {
  type        = number
  description = "primary disk attached to master node, specified in GB"
  default     = 250
}

variable "dataproc_worker_bootdisk" {
  type        = number
  description = "primary disk attached to master node, specified in GB"
  default     = 125
}

variable "dataproc_init_script_name" {
  type        = string
  description = "Name of the initialization script"
  default     = "initialize_cluster.sh"
}

variable "files" {
  type = map(string)
  default = {
    "dags.py"          = "dags/dags.py",
    "run.py"           = "dags/run.py"
    "requirements.txt" = "dags/requirements.txt"
  }
}
