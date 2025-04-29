provider "azurerm" {
  features {
  }
  use_oidc                        = false
  resource_provider_registrations = "none"
  subscription_id                 = "fcbf2503-63d9-4e16-9389-863eedc63c95"
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
}
