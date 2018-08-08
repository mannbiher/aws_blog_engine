import React from 'react';
import API from '@aws-amplify/api';

export default class MarkDownEditor extends React.Component {
    constructor(props) {
        super(props);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.input = React.createRef();
    }

    handleSubmit(event) {
        let apiName = 'BlogAPI'; // replace this with your api name.
        let path = '/blogs'; //replace this with the path you have configured on your API
        let myInit = {
            body: { 'Hello': 'word' }, // replace this with attributes you need
            // headers: {} // OPTIONAL
        }

        API.post(apiName, path, myInit).then(response => {
            // Add your code here
        }).catch(error => {
            console.log(error.response)
        });

        event.preventDefault();
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <label>
                    Enter your blog in markdown
        <textarea ref={this.input} />
                </label>
                <input type="submit" value="Submit" />
            </form>
        );
    }
}