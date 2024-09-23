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

deployment "production" {
  inputs = {
    cluster_name        = "stacks-demo-prod"
    kubernetes_version  = "1.30"
    region              = "us-west-1"
    role_arn            = "arn:aws:iam::279788477240:role/stacks-hsankaran"
    identity_token      = identity_token.aws.jwt
    default_tags        = { stacks-preview-example = "eks-deferred-stack-prod" }
  }
}

orchestrate "auto_approve" "addition_plans" {
 check {
     # Only auto-approve in development environment if no resources are being removed
     condition = context.plan.changes.remove == 0 && context.plan.deployment == deployment.development
     reason = "Plan has ${context.plan.changes.remove} resources to be removed."
 }
}
