import {
    CognitoUserPool,
    CognitoUserAttribute,
    AuthenticationDetails,
    CognitoUser } from 'amazon-cognito-identity-js';
import constants from './constants.js';

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
        },

        onFailure: function(err) {
            alert(err);
        },

    });
}