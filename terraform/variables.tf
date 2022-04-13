# ----- provider -----

variable "oci_region" {
  type      = string
  sensitive = true
}

variable "oci_tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "oci_user_ocid" {
  type      = string
  sensitive = true
}

variable "oci_fingerprint" {
  type      = string
  sensitive = true
}

variable "oci_private_key_base64" {
  type      = string
  sensitive = true
}


# ----- resources -----

# Base/Shared

variable "oci_vcn_id" {
  type      = string
  sensitive = false
  default   = null
}

variable "oci_internet_gateway_id" {
  type      = string
  sensitive = false
  default   = null
}

variable "oci_route_table_id" {
  type      = string
  sensitive = false
  default   = null
}

variable "oci_security_list_id" {
  type      = string
  sensitive = false
  default   = null
}

variable "oci_subnet_id" {
  type      = string
  sensitive = false
  default   = null
}

# VCN

variable "vcn_cidr_blocks" {
  type      = list(any)
  sensitive = false
  default   = ["172.16.0.0/20"]
}

variable "vcn_display_name" {
  type      = string
  sensitive = false
  default   = "base-vcn"
}

# Network

variable "internet_gateway_display_name" {
  type      = string
  sensitive = false
  default   = "base-igw"
}

variable "route_table_display_name" {
  type      = string
  sensitive = false
  default   = "base-rt"
}

variable "security_list_display_name" {
  type      = string
  sensitive = false
  default   = "base-sl"
}

variable "subnet_cidr_block" {
  type      = string
  sensitive = false
  default   = "172.16.0.0/24"
}

variable "subnet_display_name" {
  type      = string
  sensitive = false
  default   = "base-subnet"
}

variable "your_home_public_ip" {
  type      = string
  sensitive = true
}
