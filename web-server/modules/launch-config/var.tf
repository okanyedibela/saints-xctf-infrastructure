/**
 * Variables for the saintsxctf website launch configuration of EC2 instances
 * Author: Andrew Jarombek
 * Date: 12/10/2018
 */

variable "prod" {
  description = "If the environment of the launch configuration is production"
  default = false
}

variable "max_size" {
  description = "Max number of instances in the auto scaling group"
  default = 1
}

variable "min_size" {
  description = "Min number of instances in the auto scaling group"
  default = 1
}

variable "desired_capacity" {
  description = "The desired number of intances in the autoscaling group"
  default = 1
}

variable "autoscaling_schedules" {
  description = "A list of autoscaling schedule parameters"
  type = list
  default = []
}

variable "instance_port" {
  description = "The port on the EC2 instances to receive requests from the load balancer"
  default = 8080
}

variable "launch-config-sg-rules-cidr" {
  description = "A list of security group rules for the launch configuration (using CIDR blocks)"
  type = list
  default = []
}

variable "launch-config-sg-rules-source" {
  description = "A list of security group rules for the launch configuration (using source Security Groups)"
  type = list
  default = []
}

variable "load-balancer-sg-rules-cidr" {
  description = "A list of security group rules for the load balancer (using CIDR blocks)"
  type = list
  default = []
}

variable "load-balancer-sg-rules-source" {
  description = "A list of security group rules for the load balancer (using source Security Groups)"
  type = list
  default = []
}