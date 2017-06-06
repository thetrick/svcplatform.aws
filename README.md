# Service Platform Serverless Backend
1. __TODO: Write-to-SQS Explanation__
2. __TODO: SQS Consumer Explanation__
3. __TODO: SQS Worker Explanation__
4. __TODO: Include Architecture Diagram__

# Processing States
## start
	- Exposes RESTful Endpoint to submit an SOW Creation Task to SQS
	- Place "get-metadata" task on the queue
## get-metadata
	- Queries Azure DocumentDB and populates AWS DynamoDB with SOW Metadata
	- List of Metadata:
		* Name
		* Customer Name
		* AE
		* SE
		* SOW Status
		* SOW Due Date
		* SOW Approved Date
		* Microsoft Funding
		* Solution Practice
		* Services Bucket
		* Business Unit (Don't currently have this data in service platform)
		* Delivery Team (Don't currently have this data in service platform)
		* Services Type
		* Services Revenue
		* Team (Don't currently have this data in service platform)
	- Deletes "get-metadata" task from the queue
	- Place "gen-document" task on the queue
## gen-document
	- Calls Service Platform's Generate Quote Service
	- Copies the <id>.docx to AWS s3
	- Update DynamoDB with the Quote's S3 Url
	- Deletes "gen-document" task from the queue
	- Place "create-sp-doc-set" task on the queue
## create-sp-doc-set
	- Queries AWS DynamoDB for the SOW Metadata
	- Authenticates against SharePoint Online SOW Tracking Site
	- Creates a new Document Set with the SOW Metadata
	- Update DynamoDB with the SharePoint Document Set's Url
	- Deletes "create-sp-doc-set" task from the queue
	- Place "copy-doc" task on the queue	
## copy-doc
	- Queries AWS DynamoDB for the SharePoint Document Set's Url, Name and Customer Name
	- Authenticates against SharePoint Online SOW Tracking Site
	- Copy <id>.docx to SharePoint; rename using format: <Customer Name>-<Name>.docx
	- Deletes "copy-doc" task from the queue
	- Place "end" task on the queue		
## end
	- Send Notification to the Appropriate Group
	- Deletes "end" task from the queue