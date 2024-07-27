# route53-records

A Terraform module to manage Route53 records.

## Example

```
module "lb_tsa" {
  source  = "cloudboss/elbv2/aws"
  version = "0.1.0"

  ...
}

module "lb_web" {
  source  = "cloudboss/elbv2/aws"
  version = "0.1.0"

  ...
}

module "dns_web" {
  source  = "cloudboss/route53-records/aws"
  version = "0.1.0"

  dns_records = [
    {
      alias = {
        evaluate_target_health = true
        name                   = module.lb_tsa.load_balancer.dns_name
        zone_id                = module.lb_tsa.load_balancer.zone_id
      }
      name = "tsa.example.com"
      type = "A"
    },
    {
      alias = {
        evaluate_target_health = true
        name                   = module.lb_web.load_balancer.dns_name
        zone_id                = module.lb_web.load_balancer.zone_id
      }
      name = "www.example.com"
      type = "A"
    },
  ]
  route53_zone_name = "example.com"
}
```
