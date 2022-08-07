# Create two EC2 Instance for Kubenetes Worker Node
resource "aws_instance" "kubeWorker" {
  ami           = var.awsAmiId
  instance_type = var.awsInstanceTpye
  key_name      = "hemendra_key"
  availability_zone = element( var.availabilityZone , count.index )
  security_groups = [aws_security_group.allowALLSecurityGroup.id]
  count = var.isKubeWorker ? 2 : 0
  subnet_id      = element(aws_subnet.Subnet.*.id, count.index)
# associate_public_ip_address = "true"

  timeouts {
    create = "3m"
    delete = "3m"
  }

  tags = {
    ENV = var.kubeWorker["ENV"]
    Auther = var.kubeWorker["Auther"]
    Name = var.kubeWorker["Name"]
  }
}

# Create a EC2 Instance for Kubenetes Master Node
resource "aws_instance" "kubeMaster" {
  ami           = var.awsAmiId
  instance_type = var.awsInstanceTpye
  key_name      = "hemendra_key"
  availability_zone = element( var.availabilityZone , count.index )
  security_groups = [aws_security_group.allowALLSecurityGroup.id]
  count = var.isKubeMaster ? 1 : 0
  subnet_id      = element(aws_subnet.Subnet.*.id, length(var.Subnet_cidrBlock)-count.index)
# associate_public_ip_address = "true"

  timeouts {
    create = "3m"
    delete = "3m"
  }

  tags = {
    ENV = var.kubeMaster["ENV"]
    Auther = var.kubeMaster["Auther"]
    Name = var.kubeMaster["Name"]
  }
}



# Printing Public IP of Master Node
output "kubeMasterPublicIP" {
  value = aws_instance.kubeMaster.*.public_ip
}

# Printing Public IP of Worer Node
output "kubeWorkerPublicIP" {
  value = aws_instance.kubeWorker.*.public_ip
}
