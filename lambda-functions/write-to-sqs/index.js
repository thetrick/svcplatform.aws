/**
 * Created by Todd G. Hetrick
 * Last Updated: 6/6/2017
 *
 * Required Env Vars:
 *    REGION
 *    QUEUE_URL
 */
'use strict';

var AWS = require('aws-sdk');
var sqs = new AWS.SQS({ region: process.env.REGION });

exports.handler = function (event, context) {
  var params = {
    MessageBody: JSON.stringify(event),
    QueueUrl: process.env.QUEUE_URL
  };
  sqs.sendMessage(params, function (err, data) {
    if (err) {
      console.log('error:', "Fail Send Message" + err);
      context.done('error', "ERROR Put SQS");  // ERROR with message
    } else {
      console.log('data:', data.MessageId);
      context.done(null, '');  // SUCCESS 
    }
  });
}