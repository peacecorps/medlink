angular.module('medSupplies.services')

.config([
	'$httpProvider',

	($httpProvider) ->
		$httpProvider.responseInterceptors.push 'authInterceptor'

		# CSRF
		getToken = ->
			el = document.querySelector('meta[name="csrf-token"]')
			return if el then el.getAttribute('content') else ''
		
		updateToken = ->
			headers = $httpProvider.defaults.headers.common
			token = getToken()

			if (token)
				headers['X-CSRF-TOKEN'] = getToken()
				headers['X-Requested-With'] = 'XMLHttpRequest'

		updateToken()
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