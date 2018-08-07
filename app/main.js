import React from 'react';
import ReactDOM from 'react-dom';
import Navigation from './js/routes.jsx';
import Amplify, { API } from 'aws-amplify';
import aws_exports from './js/aws-exports';

Amplify.configure(aws_exports);

ReactDOM.render(
  <Navigation />,
  document.getElementById('dynamic')
);