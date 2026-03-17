Setup
1.	Infrastructure Provisioning
- Launched an EC2 instance (Ubuntu).
- Attached an EBS volume for persistent database storage.
- Configured security groups to allow HTTP (port 80) and SSH (port 22).
2.	Environment Configuration
a  Wrote a provision.sh script to:
- Update system packages
- Install Docker and Docker Compose
- Create required directories
- Mount the EBS volume
- Set correct permissions
3.	Containerized Application
a Defined services in docker-compose.yml:
- WordPress exposed on port 80
- MySQL with data stored on /mnt/mysql-data
- Used a .env file for database credentials to avoid hardcoding secrets
- Configured both containers on the same Docker network
4.	Backup Strategy
a Created backup.sh script to:
- Run mysqldump inside the MySQL container
- Generate timestamped backup files
- Upload backups to S3 using AWS CLI

Decisions
-	Docker-based deployment
Chosen for portability and consistency. Containers simplify dependency management and reduce configuration drift.
-	Single EC2 instance
Simplifies setup and reduces cost. Suitable for learning or small-scale deployments.
-	EBS for database persistence
Ensures MySQL data survives container restarts or recreation.
-	S3 for backups
Provides durable, scalable, and low-cost storage for database backups.
-	Environment variables (.env file)
Keeps credentials separate from code and improves security 

Trade offs
-	Single instance limitation
Both WordPress and MySQL run on one EC2 instance. This creates a single point of failure and limits scalability.
-	Manual scaling
No auto-scaling or load balancing. Scaling requires manual intervention or redesign.
-	Security considerations
Storing credentials in .env is better than hardcoding, but still less secure than using AWS Secrets Manager or IAM roles.
-	Operational overhead
Managing Docker, backups, and updates manually increases maintenance effort compared to managed services.


