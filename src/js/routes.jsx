import React from "react";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import NameForm from './authform.jsx';
import HelloMessage from './home.jsx';
import MarkDownEditor from './edit.jsx';
import { PrivateRoute } from './private-route.jsx';

const Navigation = () => (
    <Router>
        <div>
            <ul>
                <li>
                    <Link to="/">Home</Link>
                </li>
                <li>
                    <Link to="/signup">Sign Up</Link>
                </li>
                <li>
                    <Link to="/login">Login</Link>
                </li>
                <li>
                    <Link to="/edit">New Blog</Link>
                </li>
            </ul>
            <hr />
            <Route exact path="/" component={HelloMessage} />
            <Route path="/signup" render={props => <NameForm auth="signup" {...props} />} />
            <Route path="/login" render={props => <NameForm auth="login" {...props} />} />
            <PrivateRoute path="/edit" component={MarkDownEditor} />
        </div>
    </Router>
);

export default Navigation;