# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    cluster_name        = "stacks-demo"
    kubernetes_version  = "1.30"
    region              = "us-west-1"
    role_arn            = "arn:aws:iam::279788477240:role/stacks-hsankaran"
    identity_token      = identity_token.aws.jwt
    default_tags        = { stacks-preview-example = "eks-deferred-stack" }
  }
}

orchestrate "auto_approve" "no_changes" {
  check {
    # Check that the pet component has no changes
    condition = context.plan.component_changes["component.kube"].total == 0
    reason = "Not auto-approved because changes proposed to kube component."
  }
}
