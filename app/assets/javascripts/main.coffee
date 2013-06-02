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

    .when('/',
      templateUrl: 'order_list.html'
      controller: 'OrderListCtrl'
    )

    .when('/order_form',
      templateUrl: 'order_form.html'
      controller: 'OrderNewCtrl'
    )

    .when('/supply_list',
      templateUrl: 'supply_list.html'
      controller: 'SupplyListCtrl'
    )
])
