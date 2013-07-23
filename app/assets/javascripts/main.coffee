angular.module('medSupplies.services', [])
angular.module('medSupplies.filters', [])
angular.module('medSupplies.directives', [])
angular.module('medSupplies.controllers', [])

angular.module('medSupplies', [
  'rails'
  'ngResource'
  'medSupplies.services'
  'medSupplies.filters'
  'medSupplies.directives'
  'medSupplies.controllers'
])

.config([
  '$routeProvider',
  '$locationProvider',

  ($routeProvider, $locationProvider) ->
    $routeProvider

    .when('/users/sign_in',
      templateUrl: 'session_new.html'
      controller: 'SessionNewCtrl'
    )

    .when('/users/sign_out',
      templateUrl: 'session_new.html'
      controller: 'SessionDestroyCtrl'
    )

    .when('/users/sign_up',
      templateUrl: 'registration_new.html'
      controller: 'RegistrationNewCtrl'
    )

    .when('/users/edit',
      templateUrl: 'registration_edit.html'
      controller: 'RegistrationEditCtrl'
    )

    .when('/help',
      templateUrl: 'help.html'
    )

    .when('/',
      redirectTo: '/users/sign_in'
    )
])


.run([
  '$rootScope',
  '$location',
  'UserSession',
  'CurrentUser',

  ($rootScope, $location, UserSession, CurrentUser) ->
    $rootScope.flash = []

    $rootScope.$on 'flash:add', (e, message) ->
      $rootScope.flash.push message

    $rootScope.$on 'auth:fetch', ->
      CurrentUser.get {}, (user) ->
        $rootScope.current_user = new UserSession(user)

    $rootScope.$on 'auth:update', (e, user) ->
      if (user)
        $rootScope.current_user = new UserSession(user)
      else
        $rootScope.$emit 'auth:fetch'

    $rootScope.$on 'auth:destroy', (e) ->
      $rootScope.current_user = null

    # get the current user on initialization
    $rootScope.$emit 'auth:fetch'
])

# FIXME: extract into a more appropriate location / framework?
$ ->
  $("tr[data-link]").click ->
    window.location = $(this).data "link"

  instructions = $ ".order__instructions textarea"
  remaining = $ ".order__characters"

  update_counts = ->
    count = 160 - instructions.val().length
    remaining.text count + " characters remaining"

  $(".order__message input").click ->
    instructions.val $(this).data "message"
    update_counts()

  instructions.keyup(update_counts).keyup()
