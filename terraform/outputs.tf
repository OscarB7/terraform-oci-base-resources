output "local_oci_vcn_id" {
  value = local.oci_vcn_id
}

output "local_oci_internet_gateway_id" {
  value = local.oci_internet_gateway_id
}

output "local_oci_route_table_id" {
  value = local.oci_route_table_id
}

output "local_oci_security_list_id" {
  value = local.oci_security_list_id
}

output "local_oci_subnet_id" {
  value = local.oci_subnet_id
}

output "availability_domains" {
  value = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
}
