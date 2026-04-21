variable "greeting" {
  default = "Welcome Home, Doctor."
}

resource "local_file" "main" {
  content = "${var.denied}\n${var.completed}\nPrimary object received.\n${var.greeting}"
  filename = "${path.module}/greeting.txt"
}
