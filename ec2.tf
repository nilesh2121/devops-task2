# added the ec2 instance details 
resource "aws_instance" "webserver" {
    ami = "ami-08d4ac5b634553e16"
    instance_type = "t2.micro"
    key_name = "mylaptop"
    subnet_id = data.aws_subnet.public-subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.websg.id]
    tags = {
      Name = "web-server"
    }
    # user_data = file("script/user.sh")

    connection {
      type         = "ssh"
      host        = aws_instance.webserver.public_ip
      user        = "ubuntu"
      private_key = file(var.priv_key)
      timeout     = "4m"
    } 

    provisioner "remote-exec" {
      inline = [
        # !/bin/bash
        "sudo apt update",
        "sudo apt install software-properties-common",
        "sudo add-apt-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y"
        
      ]

    }

    provisioner "file" {
      source = "/Study 2020/devops task/devops-task2/apache.yml"
      destination = "/home/ubuntu/apache.yml"
      
    }




    provisioner "local-exec" {
      #command = "sudo ansible-playbook  -i ${aws_instance.webserver.public_ip}, --private-key ${file("~/.ssh/id_rsa")} apache.yml"
      command = "ansible-playbook -i ${aws_instance.webserver.public_ip} apache.yml"
    
  }


         

   
      
}

    





# resource "local_file" "sshcopy" {
#   content = "sshcopy"
#   filename = "/home/devops/.ssh/id_rsa.pub"
# }

  
# }





resource "aws_instance" "dbserver" {
    ami = "ami-08d4ac5b634553e16"
    instance_type = "t2.micro"
    key_name = "mylaptop"
    subnet_id = aws_subnet.private_subnet.id
    vpc_security_group_ids = [aws_security_group.dbsg.id]
    tags = {
      Name = "db-server"
    }
    # user_data = file("script/user.sh")
    

   





}


# resource "local_file" "ssh" {
#   content = "sshcopy"
#   filename = "/home/devops/.ssh/id_rsa.pub"

  
# }



# added the keypaire location - production

resource "aws_key_pair" "mylaptop-us" {
    key_name = "mylaptop"
    public_key = file("/home/devops/Key/.ssh/id_rsa.pub")
    
}


# added the keypaire location -- staging 

# resource "aws_key_pair" "mylaptop-us" {
#     key_name = "mylaptop-us"
#     public_key = file("~/.ssh/id_rsa.pub")
# }





# Method two for

# resource "aws_key_pair" "keypair" {
#     key_name = "keypair"
#     public_key = tls_private_key.rsa.public_key_openssh

# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits = 4096
  
# }

# resource "local_file" "keypair" {
#   content = tls_private_key.rsa.private_key_pem
#   filename = "tfkey"
  
# }
