rem ###########################################################################
rem Author: Todd G. Hetrick
rem Date:   6/5/2017
rem ###########################################################################

rem Set-up variables
SET REGION="us-east-1"
SET ENTRY_POINT="index.handler"
SET FUNCTION_NAME="svcplatform-write-to-sqs"
SET FUNCTION_FILE="svcplatform-write-to-sqs.zip"
SET EXEC_ROLE="arn:aws:iam::503080364706:role/Service-Platform-Lambda-Role"
SET DESCR="Lambda function create a message on an AWS SQS Queue."
SET QUEUE_URL="https://sqs.us-east-1.amazonaws.com/503080364706/msgq-svcplatform-sowdocset-builder"

rem Step 1: Remove svcplatform-write-to-sqs.zip and recreate with 7zip Command Line Utiilty
del %FUNCTION_FILE%
7z a %FUNCTION_FILE% * -r -x!*.zip -x!*.log -x!*.git -x!*.bat

rem Step 2: Upload the Lambda function
rem aws lambda create-function ^
rem   --region %REGION% ^
rem   --function-name %FUNCTION_NAME% ^
rem   --zip-file fileb://%FUNCTION_FILE% ^
rem   --role %EXEC_ROLE% ^
rem   --environment Variables={REGION=%REGION%,QUEUE_URL=%QUEUE_URL%} ^
rem   --handler %ENTRY_POINT% ^
rem   --runtime nodejs6.10 ^
rem   --description %DESCR% ^
rem   --timeout 60 ^
rem   --memory-size 128 ^
rem   --debug

aws lambda update-function-code ^
    --function-name %FUNCTION_NAME% ^
    --zip-file fileb://%FUNCTION_FILE% ^