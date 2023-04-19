variable "sm_vpc_id" {
  default = "vpc-049a399ff675b52c4"
}

variable "sm_subnets" {
  default = ["subnet-045fcce83e192d95d", "subnet-0af0671369d241ee1", "subnet-044616a80711462d4"]
}

variable "sm_sec_group" {
  default = ["sg-04efbf7ed86739c3e", "sg-03facf6963ccc9d93"]
}

variable "sm_domain_name" {
  default = "secon-domain"
}

variable "sm_user_profile_name" {
  default = "secon-user"
}

variable "sm_app_name" {
  default = "secon-large-language-model"
}
