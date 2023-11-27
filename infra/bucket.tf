backend "s3" {
  key       = "tf.tfstate"
  bucket    = "babyteacher-bucket"
  endpoints = { s3 = "https://s3.fr-par.scw.cloud" }
  region    = "fr-par"

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}
