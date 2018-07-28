import React from 'react';
import {
    CognitoUserPool,
    CognitoUserAttribute
} from 'amazon-cognito-identity-js';
import constants from './constants.js';


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

        var userPool = new CognitoUserPool({
            UserPoolId: constants.USER_POOL_ID,
            ClientId: constants.CLIENT_ID
        });

        var attributeList = [];

        var attributeEmail = new CognitoUserAttribute({
            Name: 'email',
            Value: this.state.username
        });

        attributeList.push(attributeEmail);

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
                <input type="submit" value="Submit" />
            </form>
        );
    }
}

