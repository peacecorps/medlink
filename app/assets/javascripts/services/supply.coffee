angular.module('medSupplies.services')

.factory('Supply', [
  'railsResourceFactory',

  (railsResourceFactory) ->
    return railsResourceFactory(
      url: '/supplies'
      name: 'supply'
    )
])
