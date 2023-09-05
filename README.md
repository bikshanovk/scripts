# scripts
Self-written scripts are presented.

auth.php - script extension https://www.gurock.com/testrail/docs/integrate/auth/ldap for user authentication. There is no functionality in the original script to check which group the user belongs to. There is no support for memberof in the open LDAP layer. Added functionality to read users from one of the ldap groups and check whether the current user is a member of this group. If there is no user in the group, we throw an exception and the user does not get access.

/lua/* - Directory with the results of experiments on learning the lua scripting language.