/**
 * Created by Todd G. Hetrick
 * Last Updated: 6/6/2017
 *
 * Required Env Vars:
 *    REGION
 *    TASK_QUEUE_URL
 */

'use strict';

var AWS = require("aws-sdk");

var TASK_QUEUE_URL = process.env.TASK_QUEUE_URL;
var REGION = process.env.REGION;

var sqs = new AWS.SQS({ region: REGION });
var s3 = new AWS.S3({ region: REGION });

function deleteMessage(receiptHandle, cb) {
    sqs.deleteMessage({
        ReceiptHandle: receiptHandle,
        QueueUrl: TASK_QUEUE_URL
    }, cb);
}

function work(task, cb) {
    console.log(task);
    // TODO implement
    cb();
}

exports.handler = function (event, context, callback) {
    work(event.Body, function (err) {
        if (err) {
            callback(err);
        } else {
            deleteMessage(event.ReceiptHandle, callback);
        }
    });
};
