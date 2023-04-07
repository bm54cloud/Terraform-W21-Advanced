# output "subnet_ids" {
#     description = "Subnet IDs"
#     value = aws_subnet.public-subnets-tf[each.key].id
# }

# output "public_ip" {
#     description = "Public IP addresses of insyestances"
#     value = aws_instance.instance-1.public_ip
# }

# output "alb_dns_name" {
#     description = "Domain name of the load balancer"
#     value = aws_alb.***.dns_name
# }