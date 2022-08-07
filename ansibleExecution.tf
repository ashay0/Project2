resource "null_resource" "executeAnsiblePlaybook" {
  depends_on = [
    aws_instance.kubeMaster,
    aws_instance.kubeWorker
  ]

  connection {
    type     = "ssh"
    user     = var.ansibleConnection["User"]
    password = var.ansibleConnection["Password"]
    host     = "20.204.69.94"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/hemendra/ansible/setup.yml"
    ]
  }
}
