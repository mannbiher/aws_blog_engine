import React from 'react';
import ReactDOM from 'react-dom';
import {
    CognitoUserPool,
    CognitoUserAttribute,
    CognitoUser
} from 'amazon-cognito-identity-js';
import constants from './constants';


export default class NameForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            username: '',
            password: ''
        };

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(event) {
        const target = event.target;
        const value = target.type === 'checkbox' ? target.checked : target.value;
        const name = target.name;

        this.setState({
            [name]: value
        });
    }

    handleSubmit(event) {
        var poolData = {
            UserPoolId: constants.USER_POOL_ID, // Your user pool id here
            ClientId: constants.CLIENT_ID // Your client id here
        };
        //console.log(constants.US)
        var userPool = new CognitoUserPool(poolData);

        var attributeList = [];

        var dataEmail = {
            Name: 'email',
            Value: 'email@mydomain.com'
        };

        var dataPhoneNumber = {
            Name: 'phone_number',
            Value: '+15555555555'
        };
        var attributeEmail = new CognitoUserAttribute(dataEmail);
        var attributePhoneNumber = new CognitoUserAttribute(dataPhoneNumber);

        attributeList.push(attributeEmail);
        attributeList.push(attributePhoneNumber);

        userPool.signUp(this.state.username,
            this.state.password,
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
        //  alert('A name was submitted: ' + this.state.username);
        event.preventDefault();
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <label>
                    User Name:
            <input type="text" name="username" value={this.state.username} onChange={this.handleChange} />
                </label>
                <label>
                    Password:
            <input type="password" name="password" value={this.state.password} onChange={this.handleChange} />
                </label>
                <input type="submit" value="Submit"/>
            </form>
        );
    }
}

