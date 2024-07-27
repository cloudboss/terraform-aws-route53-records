# Copyright © 2024 Joseph Wright <joseph@cloudboss.co>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

locals {
  dns_records = { for record in var.dns_records :
    record.name => record
  }
}

data "aws_route53_zone" "it" {
  name         = var.route53_zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "them" {
  for_each = local.dns_records

  allow_overwrite = each.value.allow_overwrite
  name            = each.value.name
  records         = each.value.records
  set_identifier  = each.value.set_identifier
  ttl             = each.value.ttl
  type            = each.value.type
  zone_id         = data.aws_route53_zone.it.zone_id

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]
    content {
      evaluate_target_health = alias.value.evaluate_target_health
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
    }
  }

  dynamic "cidr_routing_policy" {
    for_each = (
      each.value.cidr_routing_policy == null
      ? []
      : [each.value.cidr_routing_policy]
    )
    content {
      collection_id = cidr_routing_policy.value.collection_id
      location_name = cidr_routing_policy.value.location_name
    }
  }

  dynamic "failover_routing_policy" {
    for_each = (
      each.value.failover_routing_policy == null
      ? []
      : [each.value.failover_routing_policy]
    )
    content {
      type = failover_routing_policy.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = (
      each.value.geolocation_routing_policy == null
      ? []
      : [each.value.geolocation_routing_policy]
    )
    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }

  dynamic "geoproximity_routing_policy" {
    for_each = (
      each.value.geoproximity_routing_policy == null
      ? []
      : [each.value.geoproximity_routing_policy]
    )
    content {
      aws_region       = geoproximity_routing_policy.value.aws_region
      bias             = geoproximity_routing_policy.value.bias
      local_zone_group = geoproximity_routing_policy.value.local_zone_group

      dynamic "coordinates" {
        for_each = (
          geoproximity_routing_policy.value.coordinates == null
          ? []
          : [geoproximity_routing_policy.value.coordinates]
        )
        content {
          latitude  = coordinates.value.latitude
          longitude = coordinates.value.longitude
        }
      }
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = (
      each.value.weighted_routing_policy == null
      ? []
      : [each.value.weighted_routing_policy]
    )
    content {
      weight = weighted_routing_policy.value.weight
    }
  }
}
