# Task 1 - Access log analytics

 

## To count the total number of HTTP requests recorded in the access logfile:

We can use grep and the  wc command in a bash script to count the total number of HTTP requests recorded in an access logfile. 

Here's how the script works:

It defines the logfile variable, which should contain the path to your access logfile. You should replace "access.log" with the actual path to your log file.
It uses the grep command to search for lines in the log file that contain "HTTP/1.1". This assumes that all HTTP requests are logged in this format. Adjust the pattern to match the format of your log entries if necessary.
The grep output is piped to wc -l, which counts the number of lines matching the pattern.
Finally, it prints the total count of HTTP requests to the console.
Make sure to save the script in a file (e.g., count_http_requests.sh), give it executable permissions using chmod +x count_http_requests.sh, and then run it with ./count_http_requests.sh in the same directory as your log file.

## Find the country that made the most requests

To find the country that made the most requests based on the source IP addresses in your log file. To achieve this, we can use the geoiplookup command to determine the country associated with each IP address. 

we need to install geoiplookup command, on my OS, Ubuntu:
$ sudo apt install geoip-bin

Here's how the script works:

It defines the logfile variable, which should contain the path to your access logfile. Replace "access.log" with the actual path.
It creates an associative array country_counts to store the counts of requests for each country.
The get_country function takes an IP address as input and uses geoiplookup to determine the associated country. It then returns the country name.
The script reads each line of the log file and extracts the source IP address. It uses the get_country function to get the country for each IP address and increments the count in the country_counts array.
Finally, it finds the country with the most requests by iterating through the associative array and prints the result.
Make sure to save the script in a file (e.g., find_most_requests_country.sh), give it executable permissions using chmod +x find_most_requests_country.sh, and then run it with ./find_most_requests_country.sh in the same directory as your log file.

## To find the Top 10 hosts that made the most requests from 2019-06-10 00:00:00 up to and including 2019-06-19 23:59:59

To find the top 10 hosts that made the most requests from June 10, 2019, 00:00:00 to June 19, 2019, 23:59:59 in a Bash script, we can use awk and sort. 

Here's how the script works:

It defines the logfile variable with the path to your access logfile. Replace "access.log" with the actual path.
It defines the start_date and end_date variables to specify the date range you want to analyze.
It uses awk to filter log entries within the specified date range using the $4 field (assuming the date is in the fourth field of each log entry). It then extracts the host (IP address) from each entry.
The sort and uniq -c commands are used to count the number of requests for each host.
Finally, it uses sort -nr to sort the hosts in descending order by the number of requests and displays the top 10 hosts.
Make sure to save the script in a file (e.g., top_hosts.sh), give it executable permissions using chmod +x top_hosts.sh, and then run it with ./top_hosts.sh in the same directory as your log file. Note: I would personalty and probably no choose this architecture, I used it here because its the assignment preferred tech stack and I have very limited time to deliver this output. Eventually I will be able to propose a better architecture (in my opinion). 

## Application System Architecture:

#### Components:

1. **API Server**: Handles incoming requests from users. Exposes two endpoints - one for URL submission and another for URL redirection.
2. **Database (DynamoDB)**: Stores mappings between short URLs and their corresponding original URLs. DynamoDB offers high availability and scalability.
3. **Cache (Amazon ElastiCache)**: Caches frequently accessed URLs to reduce database load and improve response times.
4. **Load Balancer (ELB)**: Distributes incoming requests to multiple API server instances for high availability.
5. **Auto Scaling Group**: Scales API server instances horizontally based on traffic load.
6. **Kubernetes Cluster**: Manages containerized API server deployments.
7. **Docker Containers**: Hosts the application code, making it easy to deploy and scale.
8. **CI/CD Pipeline**: Automates testing, building, and deploying the application and infrastructure changes.
9. **Monitoring & Logging (CloudWatch)**: Monitors system health and logs important events.

### Approach:

1. **API Server**: Develop a RESTful API service using a framework like Flask (Python) or Express (Node.js). Ensure that shortened URLs are immutable.
2. **Database (DynamoDB)**: Design a schema to store URL mappings. Use DynamoDB's high availability and scalability features.
3. **Cache (ElastiCache)**: Implement caching of frequently accessed URLs. Use a Least Recently Used (LRU) eviction policy.
4. **Load Balancer**: Configure an Elastic Load Balancer (ELB) to distribute traffic to API server instances in multiple Availability Zones (AZs) for high availability.
5. **Auto Scaling**: Set up an Auto Scaling Group for API server instances to automatically scale based on traffic load.
6. **Kubernetes**: Deploy the API server as containers in a Kubernetes cluster. Use Helm charts for managing deployments.
7. **CI/CD Pipeline**: Implement CI/CD pipelines for each component (API server, database, cache) using terraform and preferred CI/CD tool (GitHub Actions).
8. **Monitoring & Logging**: Configure CloudWatch for monitoring system metrics and logs. Implement alarms for critical thresholds.

### Assumptions/Limitations:

- DNS Management: Assume that DNS management for the shortened URLs is handled properly.
- Security: Implement proper authentication and authorization mechanisms for API endpoints if necessary.
- Costs: Be aware of AWS costs associated with services used and monitor them closely.

An architecture diagram for a highly available and scalable application with two web API endpoints running on AWS, using Kubernetes, Docker, and hosted on a generic Linux system:

              +-------------------------+
              |        Internet         |
              +-------------------------+
                       | DNS
                       |
              +--------v--------+
              |   Load Balancer  |
              | (AWS Elastic LB) |
              +--------|--------+
                       |
             +---------v---------+
             |      VPC (AWS)     |
             |                    |
             | +----------------+ |
             | |   Subnet 1     | |
             | |  +----------+  | |
             | |  |   Worker |  | |
             | |  |  Node 1  |  | |
             | |  |  (K8s)   |  | |
             | |  +----------+  | |
             | |                | |
             | |  +----------+  | |
             | |  |   Worker |  | |
             | |  |  Node 2  |  | |
             | |  |  (K8s)   |  | |
             | |  +----------+  | |
             | |                | |
             | |   Subnet 2     | |
             | |                | |
             | +----------------+ |
             |                    |
             +---------|----------+
                       |
                       | Private Network
             +---------v---------+
             |   Kubernetes     |
             |   Cluster        |
             |                  |
             | +--------------+ |
             | | Ingress /   | |
             | | API Gateway  | |
             | |   (Nginx)    | |
             | +--------------+ |
             |                  |
             | +--------------+ |
             | |    Node 1    | |
             | |  (K8s Node)  | |
             | |              | |
             | +--------------+ |
             |                  |
             | +--------------+ |
             | |    Node 2    | |
             | |  (K8s Node)  | |
             | |              | |
             | +--------------+ |
             |                  |
             |                  |
             +------------------+

Explanation:

1. **Internet**: Represents the external network where incoming requests originate.
2. **Load Balancer (AWS Elastic LB)**: Distributes incoming traffic across multiple Kubernetes nodes for high availability.
3. **VPC (Virtual Private Cloud)**: An isolated network environment in AWS.
4. **Subnet 1 and Subnet 2**: Isolated subnetworks within the VPC.
5. **Worker Nodes**: Virtual machines or EC2 instances running Kubernetes nodes.
6. **Kubernetes Cluster**: Manages Docker containers for your application (**EKS**, **ECS** or **EC2** instances manage by us).
7. **Ingress/API Gateway (Nginx)**: Routes incoming requests to the appropriate services inside the Kubernetes cluster.
8. **Nodes 1 and 2**: Kubernetes nodes running your Docker containers.

This architecture ensures high availability with multiple nodes in different subnets, and scalability by utilizing Kubernetes for container orchestration. The load balancer handles distribution of traffic across nodes. In a real-world setup, you would also include database services, monitoring, and other components as needed.



## A simplified architecture diagram for a CI/CD pipeline using GitHub Actions and Terraform to create an Amazon EKS (Elastic Kubernetes Service) cluster on AWS:

```plaintext
GitHub Repository
     +-----------------------+
     |                       |
     |   GitHub Actions      |
     |   Workflow            |
     |                       |
     |   +----------------+  |
     |   |   Build and    |  |
     |   |   Test Scripts |  |
     |   +----------------+  |
     |           |           |
     |           v           |
     |   +----------------+  |
     |   |   Docker Build |  |
     |   |   and Push     |  |
     |   +----------------+  |
     |           |           |
     |           v           |
     |   +----------------+  |
     |   |   Terraform    |  |
     |   |   Scripts      |  |
     |   +----------------+  |
     |           |           |
     |           v           |
     |   +----------------+  |
     |   |   AWS           |  |
     |   |   Infrastructure|  |
     |   |   Deployment   |  |
     |   +----------------+  |
     |           |           |
     |           v           |
     |   +----------------+  |
     |   |   EKS Cluster  |  |
     |   |   Creation     |  |
     |   +----------------+  |
     |           |           |
     |           v           |
     |   +----------------+  |
     |   |   Deploy       |  |
     |   |   Application  |  |
     |   +----------------+  |
     |                       |
     +-----------------------+
```

Explanation:

1. **GitHub Repository**: The source code and configuration files for your application and infrastructure are stored in a GitHub repository.

2. **GitHub Actions Workflow**: This defines the steps and triggers for your CI/CD pipeline. It includes building, testing, and deploying your application and infrastructure.

3. **Build and Test Scripts**: These scripts are executed to build and test your application code.

4. **Docker Build and Push**: Your application is containerized using Docker, and the Docker images are pushed to a container registry (e.g., Amazon ECR or Docker Hub).

5. **Terraform Scripts**: Terraform scripts define your AWS infrastructure, including the EKS cluster.

6. **AWS Infrastructure Deployment**: Terraform is used to create and manage AWS resources, including the EKS cluster, VPC, subnets, and more.

7. **EKS Cluster Creation**: Amazon EKS is provisioned using Terraform to create and manage the Kubernetes cluster.

8. **Deploy Application**: Your application is deployed to the EKS cluster using tools like kubectl or Helm charts.

This diagram outlines a typical CI/CD pipeline for deploying an application on an Amazon EKS cluster. GitHub Actions automates the pipeline, Docker containers enable portability, and Terraform manages the infrastructure as code. The pipeline can be triggered on code commits, ensuring automatic deployment to the EKS cluster whenever changes are made to the repository.



