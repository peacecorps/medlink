angular.module('medSupplies.services')

.factory('Order', [
  'railsResourceFactory',

  (railsResourceFactory) ->
    return railsResourceFactory(
      url: '/orders'
      name: 'order'
    )
])