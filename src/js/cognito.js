// TODO remove this file
import {
    CognitoUserPool,
    CognitoUserAttribute,
    AuthenticationDetails,
    CognitoUser } from 'amazon-cognito-identity-js';
import constants from './constants.js';
import AWS from 'aws-sdk';

var userPool = new CognitoUserPool({
    UserPoolId: constants.USER_POOL_ID,
    ClientId: constants.CLIENT_ID
});


export function signUp(username, password) {
    var attributeList = [];

    var attributeEmail = new CognitoUserAttribute({
        Name: 'email',
        Value: username
    });

    attributeList.push(attributeEmail);

    userPool.signUp(username,
        password,
        attributeList,
        null,
        function (err, result) {
            if (err) {
                alert(err.message || JSON.stringify(err));
                return;
            }
            //console.log(result);
            cognitoUser = result.user;
            console.log('user name is ' + cognitoUser.getUsername());
        });
}


export function logIn(username, password) {
    var authenticationDetails = new AuthenticationDetails({
        Username : username,
        Password : password
    });

    var cognitoUser = new CognitoUser({
        Username : username,
        Pool : userPool
    });

    cognitoUser.authenticateUser(authenticationDetails, {
        onSuccess: function (result) {
            var accessToken = result.getAccessToken().getJwtToken();
            console.log(accessToken)
            /* Use the idToken for Logins Map when Federating User Pools with identity pools or when passing through an Authorization Header to an API Gateway Authorizer*/
            var idToken = result.idToken.jwtToken;
            AWS.config.region = "us-east-1";
            AWS.config.credentials = new AWS.CognitoIdentityCredentials({
                IdentityPoolId: constants.IDENTITY_POOL_ID,
                Logins: {
                    'cognito-idp.us-east-1.amazonaws.com/us-east-1_cL0ejBhrW': result.getIdToken().getJwtToken()
                }
            });
            console.log(idToken);
            console.log('another id token: ',result.getIdToken().getJwtToken());

            //refreshes credentials using AWS.CognitoIdentity.getCredentialsForIdentity()
            AWS.config.credentials.refresh((error) => {
                if (error) {
                     console.error(error);
                } else {
                     // Instantiate aws sdk service objects now that the credentials have been updated.
                     // example: 
                    var s3 = new AWS.S3();
                    var parms = { 
                         Bucket: 'yourbucket', 
                         Key: `${AWS.config.credentials.identityId}/hello.txt`,
                         Body: 'Hello World!'
                        };
                    s3.upload(parms, (err,data) => {console.log(err,data)});
                    console.log('Successfully logged!');
                }
            });


        },

        onFailure: function(err) {
            alert(err);
        },

    });
}