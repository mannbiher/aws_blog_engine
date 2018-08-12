import Auth from '@aws-amplify/auth';

// TODO find better method to detect logged in user
export const isAuthenticated = () => {
    Auth.currentAuthenticatedUser()
      .then(() => { return true; })
      .catch(() => { return false; });
};