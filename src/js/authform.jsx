import React from 'react';
// import { signUp, logIn } from './cognito.js';
import Auth from '@aws-amplify/auth';

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
        let username = this.state.username;
        let password = this.state.password;
        if (this.props.auth == "signup") {

            Auth.signUp({
                username,
                password,
                attributes: {
                    email: username
                }
            }).then(data => console.log(data))
                .catch(err => console.log(err));

            //signUp(this.state.username, this.state.password);
        } else {
            Auth.signIn(username, password)
                .then(user => console.log(user))
                .catch(err => console.log(err));
            // logIn(this.state.username, this.state.password);
        }


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

