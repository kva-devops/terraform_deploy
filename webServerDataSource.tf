# Author: Kutiavin Vladimir
# Date: 15/02/2021 
# Description: Up aws server with data source (ami)
# Modified: 15/02/2021
#-----------------------------------
provider "aws" {}

data "aws_ami" "amazon_latest" {
	owners = ["amazon"]
	most_recent = true
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}


resource "aws_instance" "my_webserver" {
	ami = data.aws_ami.amazon_latest.id
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.my_webserver.id]
	user_data = templatefile("userData.sh.tpl", {
		f_name = "Vladimir",
		l_name = "Kutiavin",
		numbers = ["first", "second", "third", "fourth"]
	})
	lifecycle {
		create_before_destroy = true 
	}
	tags = {
		Name = "Web_Server"
	}
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServerSecGroup"
  description = "Web server sec group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "web_server_ami_id" {
	value = data.aws_ami.amazon_latest.id
}
output "web_server_ami_name" {
	value = data.aws_ami.amazon_latest.name	
}
