console.log('Loading function');
exports.handler = async(event, context, callback) => {
    console.log(event)
    console.log(context)
    // TODO implement
    callback(null, {
        "statusCode": 200,
        headers: {
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            // "Access-Control-Allow-Credentials" : true // Required for cookies, authorization headers with HTTPS 
        },
        "body": JSON.stringify({ "message": "Hello World!" })
    })
};
