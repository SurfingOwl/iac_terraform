output "vpc_id" {
  value = scaleway_vpc_private_network.vpc.id
  description = "private network id"
}