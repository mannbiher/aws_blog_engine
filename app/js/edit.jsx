import React from 'react';

export default class MarkDownEditor extends React.Component {
    constructor(props) {
        super(props);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.input = React.createRef();
    }

    handleSubmit(event) {
        event.preventDefault();
    }

    render() {
        return (
        <form onSubmit={this.handleSubmit}>
        <label>
            Enter your blog in markdown
        <textarea ref={this.input}/>
        </label>
        <input type="submit" value="Submit" />
        </form>
        );
    }
}