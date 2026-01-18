variable "rg" {
  type = list(string)
  default = ["mohan", "ram", "shyam"]
}
variable "location" {
    type = string
    default = "Central India"
}
variable "address_space" {
    type = string
    default = "10.0.0.0/16"
}