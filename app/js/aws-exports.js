export default {
    Auth: {
    // REQUIRED - Amazon Cognito Identity Pool ID
        identityPoolId: 'us-east-1:58a57874-7f9c-485d-ad10-509501633e2a',
    // REQUIRED - Amazon Cognito Region
        region: 'us-east-1', 
    // OPTIONAL - Amazon Cognito User Pool ID
        userPoolId: 'us-east-1_cL0ejBhrW', 
    // OPTIONAL - Amazon Cognito Web Client ID
        userPoolWebClientId: '51ms9igl4ka5q9ethefp5daku',
    },
    API: {
        endpoints: [
            {
                name: "BlogAPI",
                endpoint: "https://api.masteroffew.com"
            }
        ]
    }
}