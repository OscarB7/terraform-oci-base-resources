data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.oci_tenancy_ocid
}


resource "oci_core_vcn" "base_vcn" {
  count = var.oci_vcn_id == null ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  cidr_blocks    = var.vcn_cidr_blocks
  display_name   = var.vcn_display_name
}


locals {
  oci_vcn_id = var.oci_vcn_id == null ? oci_core_vcn.base_vcn[0].id : var.oci_vcn_id
}


resource "oci_core_internet_gateway" "base_internet_gateway" {
  count = var.oci_internet_gateway_id == null ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  vcn_id         = local.oci_vcn_id
  enabled        = true
  display_name   = var.internet_gateway_display_name
}


locals {
  oci_internet_gateway_id = var.oci_internet_gateway_id == null ? oci_core_internet_gateway.base_internet_gateway[0].id : var.oci_internet_gateway_id
}


resource "oci_core_route_table" "base_route_table" {
  count = var.oci_route_table_id == null ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  vcn_id         = local.oci_vcn_id
  display_name   = var.route_table_display_name
  route_rules {
    network_entity_id = local.oci_internet_gateway_id
    description       = "Internet access"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}


locals {
  oci_route_table_id = var.oci_route_table_id == null ? oci_core_route_table.base_route_table[0].id : var.oci_route_table_id
}


resource "oci_core_security_list" "base_security_list" {
  count = var.oci_security_list_id == null ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  vcn_id         = local.oci_vcn_id
  display_name   = var.security_list_display_name
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "allow all outbound traffic from the instance"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = 6 # 6=TCP
    source      = var.your_home_public_ip
    description = "allow 22/TCP (SSH) inbound traffic from home"
    stateless   = false
    tcp_options {
      max = 22
      min = 22
    }
  }
}


locals {
  oci_security_list_id = var.oci_security_list_id == null ? oci_core_security_list.base_security_list[0].id : var.oci_security_list_id
}


resource "oci_core_subnet" "base_public_subnet" {
  count = var.oci_subnet_id == null ? 1 : 0

  cidr_block          = var.subnet_cidr_block
  compartment_id      = var.oci_tenancy_ocid
  vcn_id              = local.oci_vcn_id
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
  display_name        = var.subnet_display_name
  route_table_id      = local.oci_route_table_id
  security_list_ids   = [local.oci_security_list_id]
}


locals {
  oci_subnet_id = var.oci_subnet_id == null ? oci_core_subnet.base_public_subnet[0].id : var.oci_subnet_id
}
