resource "kubernetes_secret_v1" "secret_cloudflare_api_token_secret" {
  metadata {
    name = "base-cloudflare-api-token-secret"
  }

  data = {
    api-token = var.cloudflare_api_token
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "issuer_letsencrypt_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Issuer"
    "metadata" = {
      "name" = "letsencrypt-issuer"
      "namespace" = "default"
    }
    "spec" = {
      "acme" = {
        "email" = var.letsencrypt_email
        "privateKeySecretRef" = {
          "name" = "letsencrypt-issuer-acme-account-key"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "dns01" = {
              "cloudflare" = {
                "apiTokenSecretRef" = {
                  "key" = "api-token"
                  "name" = kubernetes_secret_v1.secret_cloudflare_api_token_secret.metadata.0.name
                }
              }
            }
          },
        ]
      }
    }
  }
}


resource "kubernetes_manifest" "certificate_zizi_press" {
  depends_on = [
    kubernetes_manifest.issuer_letsencrypt_issuer
  ]
  computed_fields = ["spec.duration", "spec.isCA"]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Certificate"
    "metadata" = {
      "name" = "zizi-press"
      "namespace" = "default"
    }
    "spec" = {
      "dnsNames" = [
        "*.zizi.press",
      ]
      "duration" = "2160h"
      "isCA" = false
      "issuerRef" = {
        "group" = "cert-manager.io"
        "kind" = "Issuer"
        "name" = kubernetes_manifest.issuer_letsencrypt_issuer.manifest.metadata.name
      }
      "privateKey" = {
        "algorithm" = "RSA"
        "encoding" = "PKCS1"
        "size" = 2048
      }
      "renewBefore" = "360h0m0s"
      "secretName" = "zizi-press-tls"
      "secretTemplate" = {
        "annotations" = {
          "my-secret-annotation-1" = "foo"
          "my-secret-annotation-2" = "bar"
        }
        "labels" = {
          "my-secret-label" = "foo"
        }
      }
      "subject" = {
        "organizations" = [
          "jetstack",
        ]
      }
      "usages" = [
        "server auth",
        "client auth",
      ]
    }
  }
}
