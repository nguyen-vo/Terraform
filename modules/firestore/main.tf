
#create a document
resource "google_firestore_document" "mydoc" {
  project     = var.project_id
  collection  = var.firestore.collection
  document_id = var.firestore.docID
  fields      = jsonencode(var.firestore.fields)
}
