angular.module('medSupplies.services', [])
angular.module('medSupplies.filters', [])
angular.module('medSupplies.directives', [])
angular.module('medSupplies.controllers', [])

angular.module('medSupplies', [
  'rails'
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

    .when('/orders',
      templateUrl: 'order_list.html'
      controller: 'OrderListCtrl'
    )

    .when('/orders/new',
      templateUrl: 'order_form.html'
      controller: 'OrderNewCtrl'
    )

    .when('/supply_list',
      templateUrl: 'supply_list.html'
      controller: 'SupplyListCtrl'
    )

    .when('/orders/:id',
      templateUrl: 'order_show.html'
      controller: 'OrderShowCtrl'
    )

    .when('/',
      redirectTo: '/orders'
    )

    #.otherwise({redirectTo: '/orders'})
])


.run([
  '$rootScope',
  '$location',
  'CurrentUser',

  ($rootScope, $location, CurrentUser) ->
    CurrentUser.get().then (user) ->
      $rootScope.user = user
      if $rootScope.user.role == 'user'
        $location.path '/orders/new'
      else
        $location.path '/orders/'
])