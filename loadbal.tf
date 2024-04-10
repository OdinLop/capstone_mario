resource "aws_lb" "main" {
 name               = "main-lb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.lb_sg.id]
 subnets            = [aws_subnet.main.id]

 tags = {
    Name = "main-lb"
 }
}

resource "aws_security_group" "lb_sg" {
 name        = "lb-sg"
 description = "Allow inbound traffic"
 vpc_id      = aws_vpc.main.id

 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
}
