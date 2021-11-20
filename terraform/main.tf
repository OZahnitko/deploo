provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = var.public_key
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "My Server Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["120.23.97.10/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.amazon_linux_free_tier.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]

  provisioner "remote-exec" {
    scripts = [
      "./scripts/init.sh"
    ]

    connection {
      host        = self.public_ip
      private_key = file("/home/sasha/.ssh/terraform")
      type        = "ssh"
      user        = "ec2-user"
    }
  }

  tags = {
    Name : "Instance with Docker"
  }
}
