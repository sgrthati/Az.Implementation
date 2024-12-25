variable "env" {
  type = string
}
variable "subscription_id" {
    type        = string
    description = "The subscription ID"
}
variable "location" {
  type = string
  description = "The Azure Region in which all resources in this example should be created."
}
variable "rg_name" {
    type        = string
}
variable "vnet" {
    type = map
}
variable "subnet" {
    type = map 
}
variable "vm" {
    type = map
}
variable "backend_rules" {
  type = map(object({
    priority    = number
    direction   = string
    access      = string
    protocol    = string
    source_port_range   = string
    destination_port_range  = string
    source_address_prefix   = string
    destination_address_prefix  = string
  }))
  default = {
    allow_RDP = {
      priority    = 100
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port_range   = "*"
      destination_port_range  = "3389"
      source_address_prefix   = "*"
      destination_address_prefix  = "*"
    }
    allow_SSH = {
      priority    = 200
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port_range   = "*"
      destination_port_range  = "22"
      source_address_prefix   = "*"
      destination_address_prefix  = "*"
    }
    allow_http = {
      priority    = 300
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port_range   = "*"
      destination_port_range  = "80"
      source_address_prefix   = "*"
      destination_address_prefix  = "*"
    }
    allow_https = {
      priority    = 400
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port_range   = "*"
      destination_port_range  = "443"
      source_address_prefix   = "*"
      destination_address_prefix  = "*"
    }
    allow_all = {
      priority    = 500
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Icmp"
      source_port_range   = "*"
      destination_port_range  = "*"
      source_address_prefix   = "*"
      destination_address_prefix  = "*"
    }
    # Out1 = {
    #   priority    = 100
    #   direction   = "Outbound"
    #   access      = "Allow"
    #   protocol    = "Tcp"
    #   source_port_range   = "*"
    #   destination_port_range  = "443"
    #   source_address_prefix   = "VirtualNetwork"
    #   destination_address_prefix  = "Storage"
    # }
  }
}