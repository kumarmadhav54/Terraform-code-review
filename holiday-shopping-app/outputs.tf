output "load_balancer_dns" {
  description = "DNS name of the Load Balancer"
  value       = module.load_balancing.alb_dns_name
}

output "web_app_url" {
  description = "URL to access the web app"
  value       = "http://${module.load_balancing.alb_dns_name}"
}
