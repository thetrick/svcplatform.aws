rem ###########################################################################
rem Author: Todd G. Hetrick
rem Date:   6/5/2017
rem ###########################################################################

rem Set-up variables
SET REGION="us-east-1"
SET ENTRY_POINT="index.handler"
SET FUNCTION_NAME="svcplatform-sqs-consumer"
SET FUNCTION_FILE="svcplatform-sqs-consumer.zip"
SET EXEC_ROLE="arn:aws:iam::503080364706:role/Service-Platform-SQS-Consumer-Lambda-Role"
SET DESCR="Lambda function pops messages off the AWS SQS SOW Builder Queue."
SET TASK_QUEUE_URL="https://sqs.us-east-1.amazonaws.com/503080364706/msgq-svcplatform-sowdocset-builder"
SET WORKER_LAMBDA_NAME="svcplatform-sqs-worker"

rem Remove svcplatform-sqs-consumer.zip and recreate with 7zip Command Line Utiilty
del %FUNCTION_FILE%
7z a %FUNCTION_FILE% * -r -x!*.zip -x!*.log -x!*.git -x!*.bat -x!.jshint*

rem goto create
goto update

:create
rem Create the Lambda function
rem Only use this the first time uploading the lambda function
aws lambda create-function ^
    --region %REGION% ^
   --function-name %FUNCTION_NAME% ^
   --zip-file fileb://%FUNCTION_FILE% ^
   --role %EXEC_ROLE% ^
   --environment Variables={REGION=%REGION%,TASK_QUEUE_URL=%TASK_QUEUE_URL%,WORKER_LAMBDA_NAME=%WORKER_LAMBDA_NAME%} ^
   --handler %ENTRY_POINT% ^
   --runtime nodejs6.10 ^
   --description %DESCR% ^
   --timeout 60 ^
   --memory-size 128 ^
   --debug

goto endit

:update
rem Update the Lambda's function's code
rem Once the function has been created, use the following command to update codebase
aws lambda update-function-code ^
    --function-name %FUNCTION_NAME% ^
    --zip-file fileb://%FUNCTION_FILE% ^

goto endit

:endit