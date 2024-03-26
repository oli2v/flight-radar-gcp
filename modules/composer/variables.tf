variable "files" {
  type = map(string)
  default = {
    "dags/dags.py"          = "dags/dags.py",
    "dags/run.py"           = "dags/run.py"
    "dags/requirements.txt" = "dags/requirements.txt"
  }
}
