# Remove instances from Rancher

This is a Lambda function that removes instances from Rancher when they are removed from an auto scaling group. 

## How it works?

When an instance is removed from an autoscaling group it will be shown as detached from Rancher. Rancher does not 
automatically remove instances that are 'manually' attached. Therefore we must tell Rancher to delete the host. 

## How to make changes and build a new deployment package?

1. Execute the following commands to create a new virtual environment and activate it

        virtualenv env
        . ./env/bin/activate
2. Install python packages

        pip3 install -r requirements.txt
3. Run the build script
        
        sh ./build.sh
        

## How is this function used on AWS?

1. The Lambda function is uploaded to AWS in this project. Whenever an instance is removed from the autoscaling group a
lifecycle hook is called. This sends a message to SNS. The Lambda function
