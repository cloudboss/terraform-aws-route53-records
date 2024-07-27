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

variable "dns_records" {
  type = list(object({
    alias = optional(object({
      evaluate_target_health = bool
      name                   = string
      zone_id                = string
    }), null)
    allow_overwrite = optional(bool, null)
    cidr_routing_policy = optional(object({
      collection_id = string
      location_name = string
    }), null)
    failover_routing_policy = optional(object({
      type = string
    }), null)
    geolocation_routing_policy = optional(object({
      continent   = string
      country     = string
      subdivision = optional(string, null)
    }), null)
    geoproximity_routing_policy = optional(object({
      aws_region = optional(string, null)
      bias       = optional(number, null)
      coordinates = optional(object({
        latitude  = string
        longitude = string
      }), null)
      local_zone_group = optional(string, null)
    }), null)
    latency_routing_policy = optional(object({
      region = string
    }), null)
    multivalue_answer_routing_policy = optional(bool, null)
    weighted_routing_policy = optional(object({
      weight = number
    }), null)
    name           = string
    records        = optional(list(string), null)
    set_identifier = optional(string, null)
    ttl            = optional(number, null)
    type           = string
  }))
  description = "A list of DNS records to create."
}

variable "route53_zone_name" {
  type        = string
  description = "Name of the Route 53 zone in which to create the records."
}

variable "private_zone" {
  type        = bool
  description = "Whether or not the Route 53 zone is private."

  default = false
}
