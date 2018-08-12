import React from 'react';
// import { signUp, logIn } from './cognito.js';
import Auth from '@aws-amplify/auth';
import { Redirect } from "react-router-dom";

export default class NameForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            username: '',
            password: '',
            redirectToReferrer: false
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
        event.preventDefault();
        let username = this.state.username;
        let password = this.state.password;
        if (this.props.auth == "signup") {

            Auth.signUp({
                username,
                password,
                attributes: {
                    email: username
                }
            }).then(data => {
                this.setState({ redirectToReferrer: true });
                console.log(data);
                
            }).catch(err => console.log(err));

            //signUp(this.state.username, this.state.password);
        } else {
            Auth.signIn(username, password)
                .then(user => {
                    this.setState({ redirectToReferrer: true });
                    console.log(user);
    
                }).catch(err => console.log(err));
            // logIn(this.state.username, this.state.password);
        }


        //  alert('A name was submitted: ' + this.state.username);
     
    }

    render() {
        console.log(this.props.location);
        
        const { from } = this.props.location.state || { from: { pathname: "/" } };
        const { redirectToReferrer } = this.state;

        if (redirectToReferrer) {
            console.log('refere: ' + redirectToReferrer);
            console.log(from);
            console.log('from: ' + JSON.stringify(from));
            return <Redirect to={from} />;
        }

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

