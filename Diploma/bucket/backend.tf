terraform {
    backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "devops-diplom-yandexcloud"
    region                      = "ru-central1"
    key                         = "terraform.tfstate"
    access_key = "YCAJEBGM0LmqugBRjnWxHQ4-X"
    secret_key = "YCOoWECmtUF0z8K51T12u2YuUAvh_QCpsi-lL52Y"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
