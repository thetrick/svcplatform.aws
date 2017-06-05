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

rem Remove svcplatform-write-to-sqs.zip and recreate with 7zip Command Line Utiilty
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
    --environment Variables={REGION=%REGION%,QUEUE_URL=%QUEUE_URL%} ^
    --handler %ENTRY_POINT% ^
    --runtime nodejs6.10 ^
    --description %DESCR% ^
    --timeout 60 ^
    --memory-size 128 ^
    --debug

goto endit

:update
aws lambda update-function-code ^
    --function-name %FUNCTION_NAME% ^
    --zip-file fileb://%FUNCTION_FILE% ^

goto endit

:endit