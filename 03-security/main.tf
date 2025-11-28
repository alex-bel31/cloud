resource "yandex_kms_symmetric_key" "key-a" {
  name              = "bucket-symetric-key"
  description       = "symmetric bucket key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

resource "yandex_storage_bucket" "bucket" {
  bucket = "novitskiiva-bucket"

    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "img" {
  bucket = "novitskiiva-bucket"
  key    = "test/img"
  source = "./img/nlb.JPG"
}
