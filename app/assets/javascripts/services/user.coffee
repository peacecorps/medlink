angular.module('medSupplies.services')

.factory('UserSession', [
  '$http',
  
  ($http) ->
    UserSession = (options) ->
      angular.extend(this, options)

    UserSession::save = ->
      return $http.post '/users/sign_in',
        user:
          email: @email
          password: @password
          remember_me: @remember_me ? 1 : 0

    UserSession::destroy = ->
      return $http.delete '/users/sign_out'

    return UserSession
])

.factory('UserRegistration', [
  '$http',

  ($http) ->
    UserRegistration = (options) ->
      angular.extend(this, options)

    UserRegistration::save = ->
      return $http.put '/users',
        user:
          email: @email
          phone: @phone
          city: @city
          current_password: @current_password
          password: @password
          password_confirmation: @password_confirmation

    return UserRegistration
])

.factory('CurrentUser', [
  '$resource',
  
  ($resource) ->
    return $resource '/users/current'
])