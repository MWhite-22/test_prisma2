import { AuthChecker } from 'type-graphql';
import { Context } from '../@types/context';

export const authChecker: AuthChecker<Context> = async ({ context: { session } }, authorizedRoles) => {
	const currentUser = session.data?.currentUser;

	console.log(
		'\nAUTH_CHECK:',
		{
			'Current User': currentUser ? currentUser.emailPersonal : 'Guest',
			'Authorized Roles Required': authorizedRoles,
		},
		'\n'
	);
	// console.log('Accessed Object: ', root);

	// Confirm there is a logged in user
	if (!currentUser) return false;

	// Checking empty @Authorized() - return true since we know there is a user now
	if (authorizedRoles.length === 0) return true;

	// If 'ADMIN' is an authorized role, check that user has admin privledges
	if (authorizedRoles.includes('ADMIN')) {
		// return currentUser.isAdmin;
	}

	// Check that permissions overlap
	return authorizedRoles.some((role: string) => {
		return role === 'REMOVE AFTER DEV' ? false : true; //DEV: Remove Me
		// currentUser.accessRoles.includes(role)
	});
};
