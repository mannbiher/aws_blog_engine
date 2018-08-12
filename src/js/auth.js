import Auth from '@aws-amplify/auth';


export const isAuthenticated = () => {
    Auth.currentAuthenticatedUser()
    .then((data) => {
        console.log(data)
        return true;
    })
    .catch((err) => {
        console.log(err);
        return false
    });
}

