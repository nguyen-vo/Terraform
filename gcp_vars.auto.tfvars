gcp_project = {
  projectID   = "terraform-test-nv-12a"
  projectName = "terraform-test-1a"
  region      = "europe-west3"
  zone        = "europe-west3-c"
}
firestore = {
  collection = "terraform-config"
  docID      = "local"
  fields = {
    fieldname = {
      mapValue = {
        fields = {
          childField = {
            stringValue = "value"
          }
          listField = {
            arrayValue = {
              values = [
                {
                  "stringValue" = "x"
                },
                {
                  "stringValue" = "y"
                },
                {
                  "stringValue" = "z"
                },
                {
                  "booleanValue" = true
                },
                {
                  "integerValue" = 123
                },
                {
                  "doubleValue" = 23.65
                },
                {
                  "nullValue" = null
                },
              ]
            }
          }
        }
      }
    }
    name = {
      stringValue = "terrform"
    }
    source = {
      stringValue = "from your local machine to Cloud Firestore"
    }
    description = {
      stringValue = "Test terraform config on creating and updating Firestore document"
    }
  }
}
