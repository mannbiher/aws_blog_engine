import React from "react";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import NameForm from './authform.jsx';
import HelloMessage from './home.jsx';

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
            </ul>
            <hr />
            <Route exact path="/" component={HelloMessage} />
            <Route path="/signup" component={NameForm} />
            <Route path="/login" component={NameForm} />
        </div>
    </Router>
);

export default Navigation;