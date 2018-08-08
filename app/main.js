import React from 'react';
import ReactDOM from 'react-dom';
import Navigation from './js/routes.jsx';
import Amplify from '@aws-amplify/core';
import aws_exports from './js/aws-exports';

// https://github.com/aws-amplify/amplify-js/wiki/Amplify-modularization
Amplify.configure(aws_exports);


ReactDOM.render(
  <Navigation />,
  document.getElementById('dynamic')
);