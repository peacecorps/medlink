angular.module('medSupplies.services', [])

.config([
	'$httpProvider',

	($httpProvider) ->
		$httpProvider.responseInterceptors.push 'authInterceptor'
])

.factory('authInterceptor', [
	'$q',
	'$rootScope',

	($q) ->
		success = (response) ->
			return response

		error = (response) ->
			status = response.status

			if status is 401
				# redirect
				return

			return $q.reject(response)

		return (promise) ->
			return promise.then(success, error)
])